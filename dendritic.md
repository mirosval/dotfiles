# Dendritic Flake-Parts Migration Plan

## Context

The dotfiles repo is being migrated from a custom `lib/`-based flake structure to the **dendritic pattern**: every `.nix` file under `modules/` is a flake-parts module, auto-imported by `import-tree`. The `flake.nix` already wires this up:

```nix
outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
  (inputs.import-tree ./modules);
```

Two stubs exist (`modules/parts.nix` and `modules/hosts/mirosval/default.nix`). The old `lib/`, `hosts/` trees and the commented-out `outputs` in `flake.nix` are the "before" state to be cleaned up.

### Key constraint

`import-tree` recursively imports every `.nix` file under `modules/` as a flake-parts module. Any file that is not a valid flake-parts module **must** be excluded — either by moving it outside `modules/`, or by placing it in a path containing `/_` (underscore prefix), which `import-tree` skips.

**Current blocker**: `modules/darwin/default.nix` is a raw nix-darwin module (`_: { nix = ...; programs.zsh = ...; system.defaults = ...; }`). `import-tree` will pick it up and try to evaluate it as a flake-parts module, which will fail because it sets nix-darwin options that don't exist in the flake-parts schema.

---

## Target Structure

```
flake.nix              # unchanged — one-liner with import-tree (already done)
home/                  # home-manager module tree (unchanged, stays at root)
darwin/                # shared nix-darwin module (moved from modules/darwin/)
overlays/              # nixpkgs overlays (unchanged)
builders/              # docker cross-compile builder (unchanged)
templates/             # project flake templates (unchanged)
scripts/               # shell utilities (unchanged)
modules/
  parts.nix            # systems, perSystem nixpkgs setup
  hosts/
    mirosval/default.nix   # darwin: home MBP (stub exists, needs filling)
    jimbo/default.nix      # darwin: work MBP (new)
    jimmy/default.nix      # nixos: raspberry pi SD image (new)
    leon/default.nix       # nixos: raspberry pi GNOME desktop (new)
```

**Deleted after migration:**
- `lib/` — replaced by inline `darwinSystem`/`nixosSystem` calls in host modules
- `hosts/` — replaced by `modules/hosts/`

---

## Implementation Steps

### Step 1 — Move the shared darwin module

Move `modules/darwin/default.nix` → `darwin/default.nix` at the repo root.

This removes it from `import-tree`'s scan while keeping it reachable from host modules via relative path (`../darwin` from `modules/hosts/*/`).

The file itself is unchanged — it remains a raw nix-darwin module.

### Step 2 — Fill in `modules/parts.nix`

```nix
{ inputs, lib, ... }: {
  systems = [ "aarch64-darwin" "aarch64-linux" ];

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs { inherit system; };
  };
}
```

If `flake.darwinConfigurations` or `flake.nixosConfigurations` cause "unknown option" errors (depends on the flake-parts version), add explicit declarations here:

```nix
options.flake.darwinConfigurations = lib.mkOption {
  type = lib.types.lazyAttrsOf lib.types.raw;
  default = {};
};
options.flake.nixosConfigurations = lib.mkOption {
  type = lib.types.lazyAttrsOf lib.types.raw;
  default = {};
};
```

### Step 3 — Complete `modules/hosts/mirosval/default.nix`

Replace the empty stub:

```nix
{ inputs, ... }: {
  flake.darwinConfigurations.mirosval = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      ../../../darwin                                  # shared macOS settings
      inputs.home-manager.darwinModules.home-manager
      {
        networking.computerName = "Miro Home MBP";
        networking.hostName = "mirosval";
        users.users.mirosval.home = "/Users/mirosval";
        home-manager.users.mirosval = import ../../../home;
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
    ];
  };
}
```

### Step 4 — Create `modules/hosts/jimbo/default.nix`

Same structure as mirosval. Jimbo-specific differences from `hosts/jimbo/default.nix`:

- `networking.computerName = "Miroslavs Work MBP"`
- `networking.hostName = "miroslavs-work-mbp"`
- `networking.localHostName = "miroslavs-work-mbp"`
- `ids.gids.nixbld = 30000` (GID clash workaround on this machine)

### Step 5 — Create `modules/hosts/jimmy/default.nix`

Jimmy is a Raspberry Pi headless NixOS server (SSH only, `nixpkgs-unstable`, SD card image).

```nix
{ inputs, ... }: {
  flake.nixosConfigurations.jimmy = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      "${inputs.nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ({ ... }: {
        boot.zfs.forceImportRoot = false;
        system.stateVersion = "24.05";
        # ... networking, SSH, users from hosts/jimmy/default.nix
      })
      inputs.home-manager-unstable.nixosModules.home-manager
      {
        home-manager.users.miro = import ../../../home;
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
    ];
    specialArgs = { inherit inputs; };
  };
}
```

Inline all config from `hosts/jimmy/default.nix` (networking, SSH, users/groups).

### Step 6 — Create `modules/hosts/leon/default.nix`

Leon is a Raspberry Pi 4 with GNOME desktop, two users (`leon` and `miro`), GPU acceleration, and `nixos-hardware`.

**Important**: `hosts/leon/default.nix` uses `fetchTarball` for `nixos-hardware` — an impure anti-pattern incompatible with flake purity. Add it as a flake input instead:

```nix
# in flake.nix inputs:
nixos-hardware.url = "github:NixOS/nixos-hardware/61283b30d11f27d5b76439d43f20d0c0c8ff5296";
```

Then in `modules/hosts/leon/default.nix`:

```nix
{ inputs, ... }: {
  flake.nixosConfigurations.leon = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ({ pkgs, ... }: {
        # ... all content from hosts/leon/default.nix (GPU, GNOME, users, etc.)
        # except the fetchTarball import which is replaced by the nixos-hardware input above
      })
      inputs.home-manager-unstable.nixosModules.home-manager
      {
        home-manager.users.miro = import ../../../home;
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
    ];
    specialArgs = { inherit inputs; };
  };
}
```

### Step 7 — Delete old infrastructure

Once all four host modules are wired and verified:

```
rm -rf lib/
rm -rf hosts/
```

The commented-out `outputs` block in `flake.nix` can also be removed.

### Step 8 (Optional, future) — wrapper-modules for program wrappers

`wrapper-modules` is already an input. When ready, add to `modules/parts.nix`:

```nix
imports = [ inputs.wrapper-modules.flakeModules.wrappers ];
```

Then add program wrapper modules, e.g. `modules/programs/neovim.nix`:

```nix
{ ... }: {
  flake.wrappers.neovim = { wlib, pkgs, ... }: {
    imports = [ wlib.wrapperModules.neovim ];
    # ... override neovim config here
  };
}
```

This is a separate phase — it can be done incrementally after the core migration without touching `home/`.

---

## Verification

After each host module is created, verify it evaluates before moving on:

```bash
# Check all outputs are visible
nix flake show

# Build darwin configs (doesn't activate, just ensures they evaluate)
nix build .#darwinConfigurations.mirosval.system
nix build .#darwinConfigurations.jimbo.system

# Build NixOS configs
nix build .#nixosConfigurations.jimmy.config.system.build.sdImage
nix build .#nixosConfigurations.leon.config.system.build.toplevel

```
