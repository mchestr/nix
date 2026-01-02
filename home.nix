{ config, pkgs, ... }:

{
  home.username = "mike";
  home.homeDirectory = "/home/mike";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Mike Chester";
      user.email = "mike@chester.io";
      init.defaultBranch = "main";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
      
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
    '';
  };

  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
        ];
      };
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      airline
    ];
    settings = { 
      ignorecase = true; 
      number = true;
      mouse = "a";
    };
    extraConfig = ''
      " Set leader key (optional, but common)
      let mapleader = " "

      " Remap Leader + n to open NERDTree
      nnoremap <Leader>n :NERDTreeToggle<CR>
    '';
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://sh.chestr.dev";
      search_mode = "fuzzy";
      key_path = "/home/mike/.local/share/opnix/atuin-key";
    };
  };

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/dunst".source = ./config/dunst;
  home.file.".config/nixpkgs".source = ./config/nixpkgs;
}
