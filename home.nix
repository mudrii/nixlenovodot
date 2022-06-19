{ config, lib, pkgs, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in

{

  fonts.fontconfig.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.mudrii = {
      imports = [
       ./home-common.nix 
#       ./home-pkgs-nelu.nix
       ./dotfiles/bashrc.nix
       ./dotfiles/rofi.nix
       ./dotfiles/i3status-rs.nix
       ./dotfiles/neovim.nix
       ./dotfiles/git.nix
       ./dotfiles/alacritty.nix
       ./dotfiles/tmux.nix
       ./dotfiles/bashrc.nix
       ./dotfiles/fish.nix
       ./dotfiles/kitty.nix
       ./dotfiles/ssh.nix
       ./dotfiles/gpg.nix
     ];
      services = {
        lorri.enable = true;
      };
    };

    users.irutsu = {
      imports = [
       ./home-common.nix 
       ./dotfiles/bashrc.nix
       ./dotfiles/rofi.nix
       ./dotfiles/i3status-rs.nix
       ./dotfiles/git.nix
       ./dotfiles/neovim.nix
       ./dotfiles/tmux.nix
       ./dotfiles/bashrc.nix
       ./dotfiles/fish.nix
       ./dotfiles/kitty.nix
      ];
    };
  };
}

