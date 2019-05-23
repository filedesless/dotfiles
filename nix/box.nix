# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixbox"; # Define your hostname.

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      autorun = true;
      layout = "us";
      libinput.enable = true;
      displayManager.lightdm.enable = true;
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      desktopManager = {
        default = "xfce";
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = true;
        };
      };
    };
    printing.enable = true;
  };

  environment.systemPackages = with pkgs; [
    haskellPackages.pandoc
    haskellPackages.xmobar
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
    i3lock rxvt_unicode
  ];

}
