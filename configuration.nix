{ config, lib, pkgs, pkgs-unstable, ... }:

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

  environment.variables = {
    EDITOR = "vim";
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      font-awesome
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
      };
    };
  };

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
    package = pkgs-unstable.steam;
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

      ssh-key-private = {
        source = "op://NixOS/ssh-key/private key";
        path = "/home/mike/.ssh/id_ed25519";
        mode = "0600";
        user = "mike";
        group = "users";
      };

      ssh-key-public = {
        source = "op://NixOS/ssh-key/public key";
        path = "/home/mike/.ssh/id_ed25519.pub";
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

  environment.systemPackages = 
    (with pkgs; [
      bibata-cursors
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
      kubectl
      libsecret
      networkmanager
      pavucontrol
      rofi-wayland
      seahorse
      waybar
      wget
      wireplumber
      xdg-desktop-portal-hyprland
    ])
    ++
    (with pkgs-unstable; [
      heroic
      umu-launcher
    ]);

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}

