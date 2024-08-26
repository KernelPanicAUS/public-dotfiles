default:
	@just --default

apply:
	nix run nix-darwin -- switch --flake .#trv4129-3

update:
	nix flake update
