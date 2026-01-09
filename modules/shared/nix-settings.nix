{ config, pkgs, lib, ... }:
{
  nix = {
    settings = {
      eval-cores = 0;
      extra-experimental-features = "parallel-eval";
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = "536870912";
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.flakehub.com"
      ];
      trusted-users = [ "root" "@wheel" ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.flakehub.com-1:t4T5C3BdwjIVbGSy9TN5CAQY+E9bATYKBSJjY3EFx0w="
        "cache.flakehub.com-2:6u+hPkIRZTE3FdmJLWcf3p0Ra4cIIJNSKJQ20RVqIiY="
        "cache.flakehub.com-3:hJIIzkJODPo46oxzAWu+yvmkY5NnI0m3wNMi2+JbQvA="
        "cache.flakehub.com-4:KoXczBVWcXk7pNRolL8dwi0RkKw3UJjdaK9CDAglvpg="
        "cache.flakehub.com-5:t31zKRs/Ve7VNLaptLZS5uea2eso3jXurls5PSRBv6o="
        "cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU="
        "cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8="
        "cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ="
        "cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o="
        "cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
