.PHONY: clean
clean:
	rm -f du.png

.PHONY: install
install:
	./install.sh

.PHONY: switch
switch:
	nix --show-trace run . switch -- --flake .

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

