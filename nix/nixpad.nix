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
  users.users.filedesless.extraGroups = [ "networkmanager" ];
  services = {
    xserver = {
      enable = true;
      autorun = true;
      layout = "us";
      libinput.enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.plasma5.enable = true;
    };
    printing.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kdeFrameworks.kwallet
    kdeApplications.kwalletmanager
    kdeApplications.spectacle
    kdeApplications.print-manager
    kwallet-pam kwalletcli simple-scan kgpg
    pinentry_qt5 kdeplasma-addons bluedevil
    kmail okular openshift ansible ansible-lint
    google-chrome
  ];

}
