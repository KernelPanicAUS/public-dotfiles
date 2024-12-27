default:
	@just --default

apply target="trv4129-3":
	nix -L run nix-darwin -- switch --flake .#{{target}}

update:
	nix flake update
