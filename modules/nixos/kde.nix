# Stan-only KDE input/shortcut configuration.
#
# - kanata (nixpkgs `services.kanata`): Caps Lock tap = Esc, hold = Super.
# - Plasma global shortcuts (./kglobalshortcutsrc): the Meta+* aliases (the
#   held Caps Lock becomes Super) and the true 4-modifier
#   Ctrl+Shift+Alt+Meta+* Hyper bindings from MiroWindowsManager.
{ self, inputs, ... }:
{
  flake.nixosModules.kde = { ... }:
  {
    # Only Caps Lock needs remapping on the Linux side; everything else is
    # a Plasma global shortcut.
    services.kanata = {
      enable = true;
      # `devices = []` (default): let kanata detect the keyboards to
      # intercept.
      keyboards.default = {
        # Only Caps Lock is remapped; deflayermap still registers it as a
        # mapped key even with an empty defsrc. Keep process-unmapped-keys
        # off so every other key bypasses kanata's state machine entirely
        # (raw passthrough) - no need to enumerate the full keyboard.
        extraDefCfg = "process-unmapped-keys no";
        config = ''
          ;; defsrc is still required, but not the whole keyboard, thanks
          ;; to deflayermap.
          (defsrc)
          ;; Caps Lock: tap = Esc, hold = Super (lmet).
          ;; f24 wrapper: documented Linux workaround for tap-hold
          ;; auto-repeat quirks
          ;; (https://github.com/jtroo/kanata/discussions/422).
          (deflayermap (default)
            caps (multi f24 (tap-hold 200 200 esc lmet)))
        '';
      };
    };

    # KDE global shortcuts: Nix is the source of truth for
    # ~/.config/kglobalshortcutsrc. Home manager rewrites the file on
    # every activation, so whatever was set in the UI gets overridden.
    # Edit ./kglobalshortcutsrc to change them.
    home-manager.users.miro = {
      xdg.configFile.kglobalshortcutsrc.source = ./kglobalshortcutsrc;
    };
  };
}
