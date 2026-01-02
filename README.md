# NixOS Configuration

Personal NixOS configuration for mikepc.

## Features

- **Window Manager**: Hyprland with Wayland
- **Secret Management**: 1Password integration via opnix
- **Container Management**: kubectl and k9s for Kubernetes
- **Gaming**: Steam support
- **Development Tools**: vim (default editor), git, claude-code

## System Packages

Key packages included:
- Terminal: foot, kitty
- Launcher: bolt-launcher, rofi-wayland
- Browser: firefox
- File Manager: thunar
- Status Bar: waybar
- Notifications: dunst
- Communication: discord
- Kubernetes: kubectl, k9s
- Secrets: 1password, gnome-keyring, seahorse

## Secret Management

Uses opnix to sync secrets from 1Password:
- Kubeconfig at `~/.kube/config`
- Atuin key
- SSH keys (ed25519)

## Apply Configuration

```bash
sudo nixos-rebuild switch
```

## Requirements

- NixOS 25.05
- `/etc/opnix.env` file for 1Password integration