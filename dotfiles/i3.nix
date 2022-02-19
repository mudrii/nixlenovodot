{ config, pkgs, lib, ... }:

let
  modifier = "Mod4";
in

{
  home-manager.users.mudrii = {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        floating.modifier = modifier;
        focus.followMouse = false;
        gaps = {
          inner = 5;
          outer = 5;
        };
        fonts = {
          names = [ "monospace" ];
          size = 10.0;
        };

        assigns = {
          "1" = [{ class = "^Firefox$"; window_role = "focus"; }];
          "2" = [{ class = "^Code$"; }];
          "3" = [{ class = "^Chromium$"; }];
          "4" = [{ class = "^Slack$"; }];
          "5" = [{ class = "^zoom$"; }];
          "6" = [{ class = "^sublime_text$"; }];
          "9" = [{ class = "^vlc$"; window_role = "floating enable"; }];
          "10" = [{ class = "^spotify$"; }];
        };

        modes = {
          resize = {
            Down = "resize grow height 5 px or 5 ppt";
            Left = "resize shrink width 5 px or 5 ppt";
            Right = "resize grow width 5 px or 5 ppt";
            Up = "resize shrink height 5 px or 5 ppt";
            h = "resize shrink width 1 px or 1 ppt";
            k = "resize grow height 1 px or 5 ppt";
            j = "resize shrink height 1 px or 1 ppt";
            i = "resize grow width 1 px or 1 ppt";
            Escape = "mode default";
            Return = "mode default";
          };
        };

        bars = [{
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome" ];
            size = 10.0;
          };
          position = "top";
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-top.toml";
          colors = {
            background = "#222222";
            separator = "#666666";
            statusline = "#dddddd";
            focusedWorkspace = { border = "#0088CC"; background = "#0088CC"; text = "#ffffff"; };
            activeWorkspace = { border = "#333333"; background = "#333333"; text = "#ffffff"; };
            inactiveWorkspace = { border = "#333333"; background = "#333333"; text = "#888888"; };
            urgentWorkspace = { border = "#2f343a"; background = "#900000"; text = "#ffffff"; };
          };
        }];

        keybindings = lib.mkOptionDefault {
            "${modifier}+Return" = "exec kitty";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+q" = "kill";
            "${modifier}+d" = "exec rofi -show drun -sidebar-mode";
            # "${modifier}+q" = "exec rofi -show run -sidebar-mode";
          };
        # };

      };
      extraConfig = ''
      
      # bar {
      #   font pango:DejaVu Sans Mono, FontAwesome 10
      #   position top
      #   status_command i3status-rs ~/.config/i3status-rust/config-top.toml
      #   colors {
      #     separator #666666
      #     background #222222
      #     statusline #dddddd
      #     focused_workspace #0088CC #0088CC #ffffff
      #     active_workspace #333333 #333333 #ffffff
      #     inactive_workspace #333333 #333333 #888888
      #     urgent_workspace #2f343a #900000 #ffffff
      #   }
      # }

      mode "$mode_system" {
        bindsym l exec --no-startup-id $Locker, mode "default"
        bindsym e exec --no-startup-id i3-msg exit, mode "default"
        bindsym s exec --no-startup-id $Locker && systemctl suspend, mode "default"
        bindsym h exec --no-startup-id $Locker && systemctl hibernate, mode "default"
        bindsym r exec --no-startup-id systemctl reboot, mode "default"
        bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"
        bindsym Return mode "default"
        bindsym Escape mode "default"
      bindsym h exec --no-startup-id $Locker, mode "default"
      }

      bindsym Mod4 + Print mode "$mode_system"

      for_window [window_role="pop-up"] floating enable
      for_window [window_role="task_dialog"] floating enable
      # for_window [class="spotify"] move to workspace 10
      for_window [class=URxvt|Firefox|Chromium|vlc|Slack|zoom] focus
      for_window [class=zoom|Slack|arandr|psensor|pavucontrol|nvidia-settings] floating enable        

      # bindsym Mod4+Return exec kitty
      # bindsym Mod4+q kill
      bindsym Mod4+Ctrl+d exec dmenu_run
      # bindsym Mod4+d exec rofi -show drun -sidebar-mode 
      bindsym Mod4+Shift+d exec rofi -show drun -sidebar-mode -run-command 'gksudo {cmd}'
      bindsym Mod4+Tab exec rofi -show window -i 
      bindsym Mod4+n exec networkmanager_dmenu
      bindsym Mod4+j focus left
      bindsym Mod4+k focus down
      bindsym Mod4+l focus up
      bindsym Mod4+semicolon focus right
      bindsym Mod4+Left focus left
      bindsym Mod4+Down focus down
      bindsym Mod4+Up focus up
      bindsym Mod4+Right focus right
      bindsym Mod4+Shift+j move left
      bindsym Mod4+Shift+k move down
      bindsym Mod4+Shift+l move up
      bindsym Mod4+Shift+semicolon move right
      bindsym Mod4+Shift+Left move left
      bindsym Mod4+Shift+Down move down
      bindsym Mod4+Shift+Up move up
      bindsym Mod4+Shift+Right move right
      bindsym Mod4+h split h
      bindsym Mod4+v split v
      bindsym Mod4+f fullscreen toggle
      bindsym Mod4+s layout stacking
      bindsym Mod4+w layout tabbed
      bindsym Mod4+e layout toggle split
      bindsym Mod4+Shift+space floating toggle
      bindsym Mod4+space focus mode_toggle
      bindsym Mod4+a focus parent
      bindsym Mod4+z focus child
      bindsym Mod4 + r mode "resize"

      bindsym Mod4+1 workspace 1
      bindsym Mod4+2 workspace 2
      bindsym Mod4+3 workspace 3
      bindsym Mod4+4 workspace 4
      bindsym Mod4+5 workspace 5
      bindsym Mod4+6 workspace 6
      bindsym Mod4+7 workspace 7
      bindsym Mod4+8 workspace 8
      bindsym Mod4+9 workspace 9
      bindsym Mod4+0 workspace 10

      bindsym Mod4+Shift+1 move container to workspace 1
      bindsym Mod4+Shift+2 move container to workspace 2
      bindsym Mod4+Shift+3 move container to workspace 3
      bindsym Mod4+Shift+4 move container to workspace 4
      bindsym Mod4+Shift+5 move container to workspace 5
      bindsym Mod4+Shift+6 move container to workspace 6
      bindsym Mod4+Shift+7 move container to workspace 7
      bindsym Mod4+Shift+8 move container to workspace 8
      bindsym Mod4+Shift+9 move container to workspace 9
      bindsym Mod4+Shift+0 move container to workspace 10
      bindsym Mod4+Shift+c reload
      bindsym Mod4+Shift+r restart
      bindsym Mod4+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

      set $mode_display Ext Screen (d) DP0 ON, (f) DP1 ON, (e) eDP ON, (h) HDMI ON, (x) DP0 OFF, (y) DP1 OFF, (w) eDP OFF, (z) HDMI OFF
      mode "$mode_display" {
          bindsym d exec --no-startup-id xrandr --output DP-0 --primary --auto, mode "default"
          bindsym f exec --no-startup-id xrandr --output DP-1 --primary --auto, mode "default"
          bindsym e exec --no-startup-id xrandr --output eDP-1-1 --auto, mode "default"
          bindsym h exec --no-startup-id xrandr --output HDMI-0 --auto, mode "default"
          bindsym x exec --no-startup-id xrandr --output DP-0 --off, mode "default"
          bindsym y exec --no-startup-id xrandr --output DP-1 --off, mode "default"
          bindsym w exec --no-startup-id xrandr --output eDP-1-1 --off, mode "default"
          bindsym z exec --no-startup-id xrandr --output HDMI-0 --off, mode "default"
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
      bindsym Mod4+m mode "$mode_display"

      bindsym XF86AudioRaiseVolume exec amixer -q sset Master 5%+ unmute
      bindsym XF86AudioLowerVolume  exec amixer -q sset Master 5%- unmute
      bindsym XF86AudioMute exec amixer -q sset Master toggle
      bindsym XF86AudioMicMute exec amixer -q sset Capture toggle
      bindsym Mod4+= exec amixer -q sset Master 5%+ unmute
      bindsym Mod4+- exec amixer -q sset Master 5%- unmute
      bindsym XF86MonBrightnessUp exec xbacklight -inc 5 # increase screen brightness
      bindsym XF86MonBrightnessDown exec xbacklight -dec 5 # decrease screen brightness
      bindsym Mod4+x [urgent=latest] focus

      exec_always --no-startup-id nm-applet --indicator
      exec --no-startup-id numlockx on


      exec_always --no-startup-id xautolock -time 15 -locker 'i3lock-fancy -gpf Comic-Sans-MS' -detectsleep
      bindsym Mod4+p exec --no-startup-id $Locker, mode "default"
      set $Locker i3lock-fancy -gpf Comic-Sans-MS && sleep 1
      set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
       


      bindsym Mod4+Ctrl+1 exec ~/.config/i3/start_w1.sh
      bindsym Mod4+Ctrl+2 exec ~/.config/i3/start_w2.sh
      bindsym Mod4+Ctrl+3 exec ~/.config/i3/start_w3.sh
      bindsym Mod4+Ctrl+4 exec ~/.config/i3/start_w4.sh
      bindsym Mod4+Ctrl+5 exec ~/.config/i3/start_w5.sh
      bindsym Mod4+Ctrl+6 exec ~/.config/i3/start_w6.sh
      bindsym Mod4+Ctrl+f exec --no-startup-id firefox
      bindsym Mod4+Ctrl+v exec --no-startup-id vlc
      bindsym Mod4+Ctrl+c exec --no-startup-id chromium
      bindsym Mod4+Ctrl+r exec --no-startup-id urxvt -e ranger
      bindsym Mod4+Ctrl+Delete exec $Locker, mode "default"

      bindsym --release Shift+Print exec "escrotum -s '/home/mudrii/Images/%Y-%m-%d-%H-%M-%S.png'"
      bindsym --release Print exec "escrotum '/home/mudrii/Images/%Y-%m-%d-%H-%M-%S.png'"
      bindsym --release Ctrl+Print exec "escrotum -C "
    '';
    };
  };
}
