{ config, pkgs, lib, ... }:

{
#  home-manager.users.mudrii = {
    programs.alacritty = {
        enable = true;
        settings = {
          env = {
            "TERM" = "xterm-256color";
          };
          window = {
            padding = {
              x = 10;
              y = 10;
            };
            decorations = "none";
          };
          scrolling.history = 100000;
          font = {
            normal = {
              family = "Mononoki Nerd Font";
              style = "Regular";
            };
            bold = {
              family = "Mononoki Nerd Font";
              style = "Bold";
            };
            bold_italic = {
              family = "Mononoki Nerd Font";
              style = "Bold Italic";
            };
            italic = {
              family = "Mononoki Nerd Font";
              style = "Italic";
            };
            size = 11.0;
            offset = {
              x = 1;
              y = 1;
            };
          };
          background_opacity = 1.0;
        };
      };
#    };
}
