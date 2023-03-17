.PHONY: install
install:
	./install.sh

.PHONY: switch
switch:
	nix --show-trace run . switch -- --flake .
