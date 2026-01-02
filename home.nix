{ config, pkgs, ... }:

{
  home.username = "mike";
  home.homeDirectory = "/home/mike";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Mike Chester";
      user.email = "mike@chester.io";
      init.defaultBranch = "main";
      pull.rebase = true;
      alias.fix = "!git add -A && git commit --fixup HEAD && GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash HEAD~2";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      git_status = {
        conflicted = "⚡";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "✓";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      nix_shell = {
        format = "[$symbol$state( \($name\))]($style) ";
        symbol = " ";
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      k = "kubectl";
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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
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
