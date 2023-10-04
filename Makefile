.PHONY: clean
clean:
	rm -f du.png

.PHONY: install
install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
	| sh -s -- install

.PHONY: uninstall
uninstall:
	/nix/nix-installer uninstall

.PHONY: mirosval-build
mirosval-build:
	nix --show-trace --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.mirosval.system

.PHONY: jimbo-build
jimbo-build:
	nix --show-trace --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.jimbo.system

.PHONY: switch
switch:
	nix --show-trace run . switch -- --flake .

.PHONY: butters-switch
butters-switch:
	nixos-rebuild switch --show-trace --flake .#butters

.PHONY: darwin-switch
darwin-switch: mirosval-build
	result/sw/bin/darwin-rebuild switch --flake .#mirosval

.PHONY: jimbo-switch
jimbo-switch: jimbo-build
	result/sw/bin/darwin-rebuild switch --flake .#jimbo

.PHONY: update
update:
	nix flake update

# Cleans up old nix generations to free up disk space
.PHONY: gc
gc:
	nix-collect-garbage -d

# Opens an image showing the disk space consumed by nix
du: du.png
	open du.png

du.png:
	nix-du -s=500MB | dot -Tpng > du.png

# Raspberry PI builders based on https://github.com/JamesGuthrie/nix-docker-builder-macos

builders/linux-aarch64/keys/id_ed25519:
	ssh-keygen -t ed25519 -f builders/linux-aarch64/keys/id_ed25519 -N '' -C 'nix-docker-builder-client'

builders/linux-aarch64/keys/ssh_host_ed25519_key:
	ssh-keygen -t ed25519 -f builders/linux-aarch64/keys/ssh_host_ed25519_key -N '' -C 'nix-docker-builder-host'

builder-keys: builders/linux-aarch64/keys/id_ed25519 builders/linux-aarch64/keys/ssh_host_ed25519_key

.PHONY: builder-image
builder-image:
	docker build \
		--rm \
		-t nix-docker-builder-linux-aarch64 \
		-f builders/linux-aarch64/Dockerfile \
		builders/linux-aarch64

.PHONY: builder-container
builder-container: 
	docker run \
		--name=nix-docker-builder-linux-aarch64 \
		--detach \
		--init \
		-p 3022:22 \
		nix-docker-builder-linux-aarch64:latest

.PHONY: builder-shell
builder-shell:
	docker exec \
		-it \
		nix-docker-builder-linux-aarch64 \
		bash

.PHONY: builder-clean
builder-clean:
	docker stop nix-docker-builder-linux-aarch64
	docker rm nix-docker-builder-linux-aarch64

.PHONY: builder-ping
builder-ping:
	nix store ping --store ssh://builder

.PHONY: butters-image
jimmy-image:
	nix build -vv .#nixosConfigurations.jimmy.config.system.build.sdImage

.PHONY: leon-image
leon-image:
	nix build -vv .#nixosConfigurations.leon.config.system.build.sdImage
