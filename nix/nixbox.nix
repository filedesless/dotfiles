# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixbox"; # Define your hostname.
  virtualisation.libvirtd.enable = true;
  users.users.filedesless.extraGroups = [ "libvirtd" ];

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "no";
    };
  };

}