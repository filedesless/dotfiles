# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      wget vim emacs26-nox auctex tmux git file python3 thunderbird
      firefox irssi sudo man-pages htop stack dmenu lightlocker
      bat screenfetch gnumake rxvt_unicode keepassxc mpv docker
      multimarkdown ansible ansible-lint i3lock openshift
      evince system-config-printer remmina openconnect
      haskellPackages.pandoc
      haskellPackages.xmobar
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "lo" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # docker
  virtualisation.docker.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.filedesless = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
  };

  # Nix auto garbage collection
  nix.gc.automatic = true;

  # Nix auto upgrade
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
