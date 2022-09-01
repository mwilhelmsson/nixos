# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Get me proprietary packages
  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
    };
  };

  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # https://github.com/NixOS/nixpkgs/issues/124215
    settings.extra-sandbox-paths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
  };

  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;


  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Stockholm";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    openrgb
    i2c-tools
    ddccontrol
  ];
  environment.pathsToLink = [ "/libexec" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.dconf.enable = true;

  # List services that you want to enable:
  services.openssh.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.enableRedistributableFirmware = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Enable the X11 windowing system.
  services.blueman.enable = true;
  services.xserver = {
    enable = true;
    xkbOptions = "caps:swapescape";
    autoRepeatDelay = 200;
    autoRepeatInterval = 20;

    desktopManager.session = [
      {
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.micke = {
    isNormalUser = true;
    # Enable ‘sudo’, 'audio' for the user.
    extraGroups = [ "wheel" "audio" "docker" "qemu-libvirtd" "libvirtd" ];
  };

  # Switch Pro Controller udev rules
  # NOTE: Removing these udev rules
  # services.udev.extraRules = ''
  #   ${builtins.readFile ./openrgb.rules}
  # '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  users.extraGroups.vboxusers.members = [ "micke" ];
  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
}
