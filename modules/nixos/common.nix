{ config, pkgs, lib, user, self, ... }:
{
  system.configurationRevision = self.rev or self.dirtyRev or null;

  imports = [
    ../shared/nix-settings.nix
    ../shared/shells.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time zone (adjust as needed per host)
  time.timeZone = lib.mkDefault "Europe/Berlin";

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";

  # X11 windowing system
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
    xkb.layout = "us";
  };

  # Display manager
  services.displayManager = {
    defaultSession = "none+i3";
  };
  services.xserver.displayManager.lightdm.enable = true;

  # Printing
  services.printing.enable = true;

  # Sound with pipewire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Touchpad support
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
    };
  };
 
  # Clipboard
  services.clipmenu.enable = true;

  # OpenSSH
  services.openssh.enable = true;

  # User account
  users.users.${user} = {
    isNormalUser = true;
    description = "Thomas Khalil";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Minimal system packages (most come from home-manager)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
	nix-output-monitor
  ];

  # System state version
  system.stateVersion = lib.mkDefault "26.05";
}
