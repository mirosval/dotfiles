.PHONY: install
install:
	./install.sh

.PHONY: switch
switch:
	nix run . switch -- --flake .
