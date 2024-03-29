{ config, pkgs, lib, ... }:

{
#  home-manager.users.mudrii = {
    programs.i3status-rust = {
      enable = true;
      bars.top = {
        icons = "awesome";
        theme = "solarized-dark";
        blocks = [
          {
            block = "disk_space";
            alert = 10.0;
            alias = "/";
            info_type = "available";
            interval = 20;
            path = "/";
            unit = "GB";
            warning = 20.0;
            format = "{icon} {available} {used}";
          }
          {
            block = "memory";
            clickable = true;
            critical_mem = 90;
            display_type = "memory";
            format_mem = "{mem_free} {mem_total_used}";
            icons = true;
            interval = 5;
            warning_mem = 70;
          }
          {
            block = "custom";
            command = "printf '\\\uf70f ' ; cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon8/fan1_input";
            # command = "sensors thinkpad-isa-0000 | awk '/fan1/ {print $2}'";
            interval = 5;
          }
          {
            block = "custom";
            # command = "sensors thinkpad-isa-0000 | awk '/fan2/ {print $2}'";
            # command = "echo -ne '\uf70f ' ; cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon8/fan2_input";
            command = "printf '\\\uf70f ' ; cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon8/fan2_input";
            interval = 5;
          }
          {
            block = "cpu";
            critical = 90;
            format = "{utilization} {frequency}";
            info = 30;
            interval = 1;
            warning = 60;
          }
          {
            block = "load";
            format = "{1m} {5m} {15m}";
            interval = 2;
          }
          {
            block = "temperature";
            chip = "coretemp-isa-0000";
            collapsed = false;
            format = "{max}";
            good = 40;
            idle = 60;
            info = 80;
            interval = 10;
            warning = 90;
          }
          {
            block = "nvidia_gpu";
            interval = 1;
            label = "";
            show_clocks = true;
            show_fan_speed = false;
            show_memory = false;
            show_temperature = true;
            show_utilization = true;
          }
          {
            block = "net";
            device = "wlp82s0";
            hide_inactive = true;
            hide_missing = true;
            interval = 5;
            format = "{ssid}";
          }
          {
            block = "net";
            device = "enp0s31f6";
            hide_inactive = true;
            hide_missing = true;
            interval = 5;
            format = "{ip}";
          }
          {
            block = "sound";
            show_volume_when_muted = true;
            headphones_indicator = true;
          }
          {
            block = "backlight";
            device = "intel_backlight";
            invert_icons = true;
          }
          # {
          #   block = "bluetooth";
          #   mac = "DC:71:96:F0:ED:B1";
          # }
          {
            block = "battery";
            format = "{percentage} {time}";
            # interval = 10;
            driver = "upower";
          }
          {
            block = "time";
            format = "%a %d/%m %R";
            interval = 10;
          }
          {
            block = "custom";
            command = "printf '\\\uF011'";
            # command = "echo '\uF011'";
            # command = "echo '\u23fb'";
            interval = 999999;
            on_click = "i3-nagbar -t warning -m 'What do you want to do?' -b 'Shutdown' 'shutdown now' -b 'Hibernate' 'systemctl hibernate' -b 'Reboot' 'reboot'";
          }
        ];
      };
    };
#  };
}
