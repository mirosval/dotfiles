# Nix builders

I'm primarily running Nix on my M1 Mac, but when I want to create a Nix image for my Raspberry PI, that can not be done, because `darwin-aarch64` is not `linux-aarch64`. To overcome this, its possible to register remote builder machines in Nix. Then this machine can be used to create nix image for the Raspberry PI.

Current defficiencies:
* Currently I have no crypto set up such as sops, so the SSH keys are just git ignored
* I have not yet set up something like morph to then deploy to the remote RPI once its already running nix

## Process for creating Nix RPI images

### Prerequisite: generate SSH Keys

To generate SSH keys in `builders/linux-aarch64/keys` run

```shell
make builder-keys
```

The 2 key pairs generated are:

* `id_ed25519` Key pair for Nix to connect to the builder
* `ssh_host_ed25519_key` Builder host fingerprint

### Create the builder

The builder is a Docker image and can be created with:

```shell
make builder-image builder-container
```

This will create a long-running docker image named `nix-docker-builder-linux-aarch64`.

The configuration needed to register the container as a builder along with the configuration to connect to it via SSH is in `hosts/mirosval/default.nix` as that's my main machine.

### Use the builder to create the image

```shell
make jimmy-image
make leon-image
```

Which runs `nix build` for the top level derivation for `butters` in the flake. This produces an image located at `result/sd-image/nixos-sd-image-<date>-aarch64-linux.img.zst`.

I have just flashed this to the SD card using the official Raspberry imager application, but you can just use `dd` for the job as well.

