{ config, lib, pkgs, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in

{

  imports = [
    # ./dotfiles/.tmux.conf.nix
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
    # ./dotfiles/lf.nix

  ];

  fonts.fontconfig.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.mudrii = {
      services = {
        lorri.enable = true;
      };

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
            enableFlakes = true;
          };
        };

        home-manager = {
          enable = true;
          path = [ pkgs.user-environment ];
        };
        /* 
          starship = {
          enable = true;
          enableFishIntegration = true;
          };
        */
        /* 
          vim = {
          enable = true;
          settings = { ignorecase = true; };
          extraConfig = builtins.readFile dotfiles/.vimrc;
          plugins = with pkgs.vimPlugins; [
          vim-nix
          vim-airline
          vim-airline-themes
          nerdtree
          ctrlp-vim
          vim-fugitive
          fzf-vim
          syntastic
          ];
          };
        */
      };

      home = {
        stateVersion = "21.11";
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
          # ".config/nixpkgs/home.nix".source = dotfiles/home.nix;
          # ".bashrc".source = dotfiles/.bashrc;
          # ".inputrc".source = dotfiles/.inputrc;
          # ".dircolors".source = dotfiles/.dircolors;
          # ".git-completion.bash".source = dotfiles/.git-completion.bash;
          # ".git-prompt.sh".source = dotfiles/.git-prompt.sh;
          # ".Xresources".source = dotfiles/.Xresources;
          # ".config/fontconfig/fonts.conf".source = dotfiles/fonts.conf;
          # ".config/lf/lfrc".source = dotfiles/lfrc;
          # ".gnupg/gpg-agent.conf".source = dotfiles/gpg-agent.conf;
          # ".gnupg/gpg.conf".source = dotfiles/gpg.conf;
          # ".ssh/config".source = dotfiles/config.ssh;
          # ".config/kitty/kitty.conf".source = dotfiles/kitty.conf;
          ".config/i3/config".source = dotfiles/config;
          ".config/i3/start_w1.sh".source = dotfiles/start_w1.sh;
          ".config/i3/start_w2.sh".source = dotfiles/start_w2.sh;
          ".config/i3/start_w3.sh".source = dotfiles/start_w3.sh;
          ".config/i3/start_w4.sh".source = dotfiles/start_w4.sh;
          ".config/i3/start_w5.sh".source = dotfiles/start_w5.sh;
          ".config/i3/start_w6.sh".source = dotfiles/start_w6.sh;
          ".config/i3/workspace_1.json".source = dotfiles/workspace_1.json;
          ".config/i3/workspace_2.json".source = dotfiles/workspace_2.json;
          ".config/i3/workspace_3.json".source = dotfiles/workspace_3.json;
          ".config/i3/workspace_4.json".source = dotfiles/workspace_4.json;
          ".config/i3/workspace_5.json".source = dotfiles/workspace_5.json;
          ".config/i3/workspace_6.json".source = dotfiles/workspace_6.json;
          #".config/i3status-rs/config.toml".source = dotfiles/config.toml;
          ".config/networkmanager-dmenu/config.ini".source = dotfiles/config.ini;
          # ".config/conky/conky.conf".source = dotfiles/conky.conf;
          # ".config/nixpkgs/config.nix".source = dotfiles/config.nix;
          ".config/ranger/commands_full.py".source = dotfiles/ranger/commands_full.py;
          ".config/ranger/commands.py".source = dotfiles/ranger/commands.py;
          ".config/ranger/rc.conf".source = dotfiles/ranger/rc.conf;
          ".config/ranger/rifle.conf".source = dotfiles/ranger/rifle.conf;
          ".config/ranger/scope.sh".source = dotfiles/ranger/scope.sh;
          ".config/ranger/plugins/ranger_devicons/__init__.py".source = dotfiles/ranger/plugins/ranger_devicons/__init__.py;
          ".config/ranger/plugins/ranger_devicons/devicons.py".source = dotfiles/ranger/plugins/ranger_devicons/devicons.py;
          # ".config/fish/config.fish".source = dotfiles/fish/config.fish;
          # ".config/fish/functions/fish_user_key_bindings.fish".source = dotfiles/fish/fish_user_key_bindings.fish;
          # ".config/fish/functions/fish_greeting.fish".source = dotfiles/fish/fish_greeting.fish;
        };
      };
    };
  };
}
