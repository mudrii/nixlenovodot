{ config, lib, pkgs, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in

{

  programs = {
    jq.enable = true;
    bat.enable = true;
    command-not-found.enable = true;
    dircolors.enable = true;
    htop.enable = true;
    info.enable = true;
    exa.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    home-manager = {
      enable = true;
      path = [ pkgs.user-environment ];
    };
  };

  home = {
    stateVersion = "21.11";
    packages = with pkgs; [
      mediainfo
      ffmpeg-full
      mupdf
      unstable.zoom-us
      firefox-bin
      chromium
      brave
      filezilla
      unstable.skypeforlinux
      spotify
      ranger
      highlight
    ];
    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "fish";
      BROWSER = "firefox";
      MANPAGER = "nvim -c 'set ft=man' -";
      TERM = "xterm-256color";
      # KUBECTL_EXTERNAL_DIFF = "meld";
      # DOCKER_BUILDKIT = "1";
      # LESS = "-R";
    };

    file = {
      ".config/libvirt/libvirt.conf".source = dotfiles/libvirt.conf;
      ".config/neofetch/config.conf".source = dotfiles/config.conf;
      ".config/i3/config".source = dotfiles/config;
      ".config/networkmanager-dmenu/config.ini".source = dotfiles/config.ini;
      ".config/ranger/commands_full.py".source = dotfiles/ranger/commands_full.py;
      ".config/ranger/commands.py".source = dotfiles/ranger/commands.py;
      ".config/ranger/rc.conf".source = dotfiles/ranger/rc.conf;
      ".config/ranger/rifle.conf".source = dotfiles/ranger/rifle.conf;
      ".config/ranger/scope.sh".source = dotfiles/ranger/scope.sh;
      ".config/ranger/plugins/ranger_devicons/__init__.py".source = dotfiles/ranger/plugins/ranger_devicons/__init__.py;
      ".config/ranger/plugins/ranger_devicons/devicons.py".source = dotfiles/ranger/plugins/ranger_devicons/devicons.py;
    };
  };
}
