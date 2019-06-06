# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.bluetooth.enable = true;
  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;

  networking.hostName = "nixpad"; # Define your hostname.
  networking.networkmanager.enable = true;

  system.activationScripts = {
    mkpub = {
      text= "mkdir -p /srv/pub";
      deps = [];
    };
  };

  services.samba = {
    enable = true;
    shares = {
      public = {
        browseable = "yes";
        comment = "Public samba share";
        "guest ok" = "yes";
        path = "/srv/pub";
        "read only" = true;
      };
    };
  };


  environment.systemPackages = with pkgs; [
    bluedevil wirelesstools
  ];

}
