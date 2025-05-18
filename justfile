default:
	@just --default

apply target="trv4129-3":
	sudo darwin-rebuild switch --flake .#{{target}}

update:
	nix flake update
