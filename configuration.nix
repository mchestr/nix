{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mikepc";
  networking.networkmanager.enable = true;

  services.getty.autologinUser = "mike";

  time.timeZone = "America/Vancouver";
  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "mike" ];
  };
  programs.steam = {
    enable = true;
  };

  opnix = {
    environmentFile = "/etc/opnix.env";
    
    secrets = {
      # Kubeconfig secret
      kubeconfig = {
        source = "op://NixOS/kubeconfig/file";
        path = "/home/mike/.kube/config";
        mode = "0600";
        user = "mike";
        group = "users";
      };
      
      # Atuin key secret
      atuin-key = {
        source = "op://NixOS/atuin/key";
        path = "/home/mike/.local/share/opnix/atuin-key";
        mode = "0600";
        user = "mike";
        group = "users";
      };
    };
  };
  systemd.services.opnix = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };


  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.polkit.enable = true;

  users.users.mike = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    bolt-launcher
    brightnessctl
    claude-code
    discord
    dunst
    fastfetch
    foot
    git
    gnome-keyring
    hyprpaper
    jq
    k9s
    killall
    kitty
    libsecret
    networkmanager
    rofi-wayland
    seahorse
    waybar
    wget
    wireplumber
    xdg-desktop-portal-hyprland
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}

