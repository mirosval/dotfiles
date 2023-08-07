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

.PHONY: build
build:
	nix --show-trace build .#darwinConfigurations.mirosval.system

.PHONY: switch
switch:
	nix --show-trace run . switch -- --flake .

.PHONY: darwin-switch
darwin-switch: build
	result/sw/bin/darwin-rebuild switch --flake .#mirosval

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

