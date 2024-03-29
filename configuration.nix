# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, options, pkgs, lib, callPackage, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
    /*
      overlays = [
      (_: prev: {
      linuxPackagesFor = kernel:
      (prev.linuxPackagesFor kernel).extend (_: _: { ati_drivers_x11 = null; });
      })
      ];
    */
  };
in

{

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      # "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
      #./home-manager-nelu.nix
      ./home.nix
      # ./containers.nix
    ];
  /*
    imports = [
    ./containers/gcpdrgn.nix
    ./containers/gcpsndp.nix
    ./containers/gcpion.nix
    ./containers/awsndp.nix
    ./containers/awsion.nix
    ];

    containers = {
    gcpdrgn.autoStart = false;
    gcpsndp.autoStart = false;
    gcpion.autoStart = true;
    awsndp.autoStart = false;
    awsion.autoStart = true;
    };
  */


  boot = {
    supportedFilesystems = [ "ntfs" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = unstable.linuxPackages_latest;
    blacklistedKernelModules = [ "nouveau" ];
    cleanTmpDir = true;
    # extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    # extraModulePackages = [ config.boot.kernelPackages.wireguard ];
    # kernelParams = [ "nvidia-drm.modeset=1" ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      grub = {
        enableCryptodisk = true;
        # enable = true;
        # devices = [ "nodev" ];
        # efiInstallAsRemovable = true;
        # efiSupport = true;
        # useOSProber = true;
      };
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    ledger.enable = true;
    enableRedistributableFirmware = true;
    # enableAllFirmware = true;

    sane = {
      enable = true;
      extraBackends = with pkgs; [ hplipWithPlugin ];
    };

    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      # package = "config.boot.kernelPackages.nvidiaPackages.beta";
      modesetting.enable = true;
      # nvidiaPersistenced = false;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  networking = {
    hostName = "p53-nixos";
    enableIPv6 = false;
    useDHCP = false;
    # interfaces.enp0s31f6.useDHCP = true;
    # nameservers = [ "8.8.8.8" "8.8.4.4" ];
    # defaultGateway = "192.168.1.1";
    #nameservers = [ "1.1.1.1" "1.0.0.1" ];
    #resolvconf.enable = false;
    # interfaces.enp0s31f6.ipv4.addresses = [{
    #   address = "192.168.1.11";
    #   prefixLength = 24;
    # }];
    networkmanager = {
      enable = true;
      #insertNameservers = [ "45.90.28.239" "45.90.30.239" ];
      #dns = "none";
      #unmanaged = [ "enp0s31f6" ];
    };
    # Enables wireless support via wpa_supplicant.
    # wireless.enable = true;
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    /*
      nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "enp0s31f6";
      };
    */

    # Open ports in the firewall.
    firewall = {
      # Or disable the firewall altogether.
      enable = true;
      allowedTCPPorts = [ 20 21 22 53 80 443 2022 ];
      allowedUDPPorts = [ 53 ];
      allowedTCPPortRanges = [ { from = 51000; to = 51999; } ];
      allowPing = true;
      trustedInterfaces = [ "docker0" "virbr0" ];
    };
  };

  # TPM has hardware RNG
  security = {
    polkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    # Yubikey for Login
    # nix-shell -p yubico-pam -p yubikey-personalization
    # ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible
    # ykpamcfg -2 -v
    /*
      pam.yubico = {
      enable = true;
      debug = true;
      mode = "challenge-response";
      control = "required"; # for sudo
      };
    */
    # Finger Print Auth //Not working 100% yet with fprint
    /*
      pam.services = {
      login.fprintAuth = true;
      xautolock.fprintAuth = true;
      };
    */

    # Example how to use pam
    /*
      pam.services = [
      { name = "gnome_keyring"
      text = ''
      auth     optional    ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
      session  optional    ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so auto_start
      password  optional    ${gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
      '';
      }
      ];
    */
  };

  /*
    powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor =  "ondemand"; # "powersave", "performance"
    cpuFreqGovernor =  "powersave"; # "ondemand", "performance"
    };
  */

  fileSystems."/home/mudrii/mnt/nvme" = {
    device = "/dev/nvme1n1p2";
    fsType = "ext4";
    options = [ "rw" "nofail" "noatime" "nodiratime" "discard" "auto" "exec" ];
  };

  fileSystems."/home/mudrii/.bitmonero" = {
    device = "/dev/nvme1n1p1";
    fsType = "ext4";
    options = [ "rw" "nofail" "noatime" "nodiratime" "discard" "auto" "exec" ];
    # options = [ "rw" "uid=1000"];
  };

  programs = {
    # seahorse app works with gnome-keyring
    seahorse.enable = true;
    vim.defaultEditor = true;
    mtr.enable = true;
    nm-applet.enable = true;

    ssh = {
      startAgent = false;
      # forwardX11 = true;
      # setXAuthLocation = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    chromium = {
      enable = true;
    };

    bash = {
      enableCompletion = true;
      # shellInit = "neofetch";
      promptInit = ''
        PS1="\n\[\033[1;32m\]\e[0;31m[\[\e]0;\u@\h: \w\a\]\e[01;32m\u@\[\e[1;34m\]\h:\[\e[01;36m\]\w\[\e[01;32m\]\e[0;31m]\[\033[0m\]\$(__git_ps1)\[\e[01;32m\]\$\[\033[0m\] "
      '';
    };

    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
      };
      # shellInit = "neofetch";
      # functions = { fish_greeting = ""; };
      /*
        promptInit = ''
        any-nix-shell fish --info-right | source
        '';
      */
    };

    nano.nanorc = ''
      unset backup
      set nonewlines
      set nowrap
      set tabstospaces
      set tabsize 4
      set constantshow
    '';
  };

  # List services that you want to enable:
  virtualisation = {
    /*
      docker = {
      enable = true;
      enableNvidia = true;
      autoPrune.enable = true;
      enableOnBoot = true;
      };
    */
    podman = {
      enable = true;
      #extraPackages = [ pkgs.gvisor ];
      enableNvidia = true;
      dockerCompat = true;
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };
    /*
      lxd = {
      enable = true;
      };
    */
    /*
      virtualbox = {
      host.enable = true;
      host.enableExtensionPack = true;
      };
    */
  };

  services = {
    #resolved.enable = false;
    # localtime.enable = true;
    # urxvtd.enable = true;
    # vnstat.enable = true;
    blueman.enable = true;
    fwupd.enable = true;
    fstrim.enable = true;
    sysstat.enable = true;
    gnome.gnome-keyring.enable = true;
    fail2ban.enable = true;
    #emacs.enable = true;
    pcscd.enable = true; # needed for YubiKey
    xmr-stak.cudaSupport = true;
    lorri.enable = true;
    #autorandr.enable = true;
    upower.enable = true;
/*
    nextdns = {
      enable = true;
      arguments = [
        "-config"
        "5954dd"
      ];
    };

*/
/*
    unbound = {
      enable = true;
      settings = {
        server = {
          interface = [ "127.0.0.1" ];
        };
        forward-zone = {
          name = ".";
          forward-tls-upstream =  "yes";
          forward-addr = [
            "45.90.28.0#2ed827.dns1.nextdns.io"
            "2a07:a8c0::#2ed827.dns1.nextdns.io"
            "45.90.30.0#2ed827.dns2.nextdns.io"
            "2a07:a8c1::#2ed827.dns2.nextdns.io"
          ];
        };
      };
    };
*/
    vsftpd = {
      enable = true;
    # cannot chroot && write
    #  chrootlocalUser = true;
      writeEnable = true;
      localUsers = true;
      userlist = [ "mudrii" ];
      userlistEnable = true;
      extraConfig = ''
        pasv_enable=Yes
        pasv_min_port=51000
        pasv_max_port=51999
      '';
    };

    logrotate = {
      enable = true;
    };
    /*
      # Finger Print unlock login
      fprintd = {
      enable = true;
      package = unstable.pkgs.fprintd;
      };
    */
    /*
      clamav = {
      daemon.enable = true;
      updater.enable = true;
      };
    */
    udev = {
      packages = [
        pkgs.yubikey-personalization # needed for YubiKey
        pkgs.libu2f-host # needed for Yubikey
      ];
      path = [
        pkgs.coreutils
      ];
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video %S%p/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w %S%p/brightness"
      '';
    };


    thinkfan = {
      enable = true;
      /*
        levels = ''
        (0,     0,      65)
        (1,     58,     70)
        (2,     60,     71)
        (3,     62,     73)
        (6,     66,     75)
        (7,     70,     95)
        (127,   90,     32767)
        '';
      */
    };

    undervolt = {
      enable = true;
      package = pkgs.undervolt;
      temp = 97;
      coreOffset = -125;
    };

    # Power button invokes suspend, not shutdown.
    logind = {
      extraConfig = "HandlePowerKey=suspend";
      lidSwitch = "suspend";
    };

    # Generate thermal-conf.xml
    # git clone https://github.com/intel/dptfxtract.git
    # cd dptfxtract
    # sudo acpidump > acpi.out
    # acpixtract -a acpi.out
    # sudo ./dptfxtract-static *.dat

    thermald = {
      enable = true;
      configFile = builtins.toFile "thermal-conf.xml" ''
         <!-- BEGIN -->
         <ThermalConfiguration>
         <Platform>
                <Name> Auto generated </Name>
                <ProductName>Standard PC (Q35 + ICH9, 2009)</ProductName>
                <Preference>QUIET</Preference>
                <ThermalZones>
                        <ThermalZone>
                                <Type>auto_zone_0</Type>
                                <TripPoints>
                                        <TripPoint>
                                                <SensorType>B0D4</SensorType>
                                                <Temperature>100000</Temperature>
                                                <Type>Passive</Type>
                                                <CoolingDevice>
                                                        <Type>B0D4</Type>
                                                        <SamplingPeriod>0</SamplingPeriod>
                                                </CoolingDevice>
                                        </TripPoint>
                                </TripPoints>
                        </ThermalZone>
                        <ThermalZone>
                                <Type>auto_zone_1</Type>
                                <TripPoints>
                                        <TripPoint>
                                                <SensorType>SEN1</SensorType>
                                                <Temperature>99000</Temperature>
                                                <Type>Passive</Type>
                                                <CoolingDevice>
                                                        <Type>B0D4</Type>
                                                        <SamplingPeriod>1</SamplingPeriod>
                                                </CoolingDevice>
                                        </TripPoint>
                                </TripPoints>
                        </ThermalZone>
                </ThermalZones>
        </Platform>
        </ThermalConfiguration>
        <!-- END -->
      '';
    };

    chrony = {
      enable = true;
      servers = [
        "0.sg.pool.ntp.org"
        "1.sg.pool.ntp.org"
        "2.sg.pool.ntp.org"
        "3.sg.pool.ntp.org"
      ];
    };

    /*
      timesyncd = {
      enable = true;
      servers = [
      "0.sg.pool.ntp.org"
      "1.sg.pool.ntp.org"
      "2.sg.pool.ntp.org"
      "3.sg.pool.ntp.org"
      ];
      };
    */

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      forwardX11 = true;
      ports = [ 2022 ];
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      # drivers = [ unstable.pkgs.epson-escpr ];
      drivers = with pkgs; [ unstable.epson-escpr ];
    };

    avahi = {
      enable = true;
      hostName = config.networking.hostName;
      ipv4 = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    tlp = {
      enable = true;
      # extraConfig = ''
      settings = {
        # Detailked info can be found https://linrunner.de/tlp/settings/index.html

        # Disables builtin radio devices on boot:
        #   bluetooth
        #   wifi – Wireless LAN (Wi-Fi)
        #   wwan – Wireless Wide Area Network (3G/UMTS, 4G/LTE, 5G)
        # DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wifi"

        # When a LAN, Wi-Fi or WWAN connection has been established, the stated radio devices are disabled:
        #   bluetooth
        #   wifi – Wireless LAN
        #   wwan – Wireless Wide Area Network (3G/UMTS, 4G/LTE, 5G)
        # DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
        # DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
        # DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"

        # When a LAN, Wi-Fi, WWAN connection has been disconnected, the stated radio devices are enabled.
        # DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan"
        # DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
        # DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT=""

        # Set battery charge thresholds for main battery (BAT0) and auxiliary/Ultrabay battery (BAT1). Values are given as a percentage of the full capacity. A value of 0 is translated to the hardware defaults 96/100%.
        START_CHARGE_THRESH_BAT0 = 30;
        STOP_CHARGE_THRESH_BAT0 = 70;

        # Control battery feature drivers:
        NATACPI_ENABLE = 1;
        TPACPI_ENABLE = 1;
        TPSMAPI_ENABLE = 1;

        # Defines the disk devices the following parameters are effective for. Multiple devices are separated with blanks.
        DISK_DEVICES = "nvme0n1 nvme1n1";

        # Set the “Advanced Power Management Level”. Possible values range between 1 and 255.
        #  1 – max power saving / minimum performance – Important: this setting may lead to increased disk drive wear and tear because of excessive read-write head unloading (recognizable from the clicking noises)
        #  128 – compromise between power saving and wear (TLP standard setting on battery)
        #  192 – prevents excessive head unloading of some HDDs
        #  254 – minimum power saving / max performance (TLP standard setting on AC)
        #  255 – disable APM (not supported by some disk models)
        #  keep – special value to skip this setting for the particular disk (synonym: _)
        DISK_APM_LEVEL_ON_AC = "254 254";
        DISK_APM_LEVEL_ON_BAT = "128 128";

        # Set the min/max/turbo frequency for the Intel GPU. Possible values depend on your hardware. See the output of tlp-stat -g for available frequencies.
        # INTEL_GPU_MIN_FREQ_ON_AC=0
        # INTEL_GPU_MIN_FREQ_ON_BAT=0
        # INTEL_GPU_MAX_FREQ_ON_AC=0
        # INTEL_GPU_MAX_FREQ_ON_BAT=0
        # INTEL_GPU_BOOST_FREQ_ON_AC=0
        # INTEL_GPU_BOOST_FREQ_ON_BAT=0

        # Selects the CPU scaling governor for automatic frequency scaling.
        # For Intel Core i 2nd gen. (“Sandy Bridge”) or newer Intel CPUs. Supported governors are:
        #  powersave – recommended (kernel default)
        #  performance
        # CPU_SCALING_GOVERNOR_ON_AC=powersave;
        # CPU_SCALING_GOVERNOR_ON_BAT=powersave;

        # Set Intel CPU energy/performance policy HWP.EPP. Possible values are
        #  performance
        #  balance_performance
        #  default
        #  balance_power
        #  power
        # for tlp-stat Version 1.3 and higher 'tlp-stat -p'
        # CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance;
        # CPU_ENERGY_PERF_POLICY_ON_BAT=power;

        # Set Intel CPU energy/performance policy HWP.EPP. Possible values are
        #   performance
        #   balance_performance
        #   default
        #   balance_power
        #   power
        # Version 1.2.2 and lower For version 1.3 and higher this parameter is replaced by CPU_ENERGY_PERF_POLICY_ON_AC/BAT
        # CPU_HWP_ON_AC=balance_performance;
        # CPU_HWP_ON_BAT=power;

        # Define the min/max P-state for Intel Core i processors. Values are stated as a percentage (0..100%) of the total available processor performance.
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;

        # Disable CPU “turbo boost” (Intel) or “turbo core” (AMD) feature (0 = disable / 1 = allow).
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # Minimize number of used CPU cores/hyper-threads under light load conditions (1 = enabled, 0 = disabled). Depends on kernel and processor model.
        SCHED_POWERSAVE_ON_AC = 0;
        SCHED_POWERSAVE_ON_BAT = 1;

        # Set Intel CPU energy/performance policy EPB. Possible values are (in order of increasing power saving):
        #   performance
        #   balance-performance
        #   default (deprecated: normal)
        #   balance-power
        #   power (deprecated: powersave)
        # Version 1.2.2 and lower For version 1.3 and higher this parameter is replaced by CPU_ENERGY_PERF_POLICY_ON_AC/BAT
        # ENERGY_PERF_POLICY_ON_AC=balance-performance;
        # ENERGY_PERF_POLICY_ON_BAT=power;

        # Timeout (in seconds) for the audio power saving mode (supports Intel HDA, AC97). A value of 0 disables power save.
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # Controls runtime power management for PCIe devices.
        # RUNTIME_PM_ON_AC=on;
        # RUNTIME_PM_ON_BAT=auto;

        # Exclude PCIe devices assigned to listed drivers from runtime power management. Use tlp-stat -e to lookup the drivers (in parentheses at the end of each output line).
        # RUNTIME_PM_DRIVER_BLACKLIST="mei_me nouveau nvidia pcieport radeon"

        # Sets PCIe ASPM power saving mode. Possible values:
        #    default – recommended
        #    performance
        #    powersave
        #    powersupersave
        # PCIE_ASPM_ON_AC=default;
        # PCIE_ASPM_ON_BAT=default;
        #'';
      };
    };

    dbus = {
      enable = true;
      packages = [ pkgs.fwupd ];
    };

    locate = {
      enable = true;
      locate = unstable.pkgs.mlocate;
      localuser = null; # mlocate does not support this option so it must be null
      # interval = "daily";
      interval = "hourly";
      pruneNames = [
        ".git"
        "cache"
        ".cache"
        ".cpcache"
        ".aot_cache"
        ".boot"
        "node_modules"
        "USB"
      ];
      prunePaths = options.services.locate.prunePaths.default ++ [
        "/dev"
        "/lost+found"
        "/nix/var"
        "/proc"
        "/run"
        "/sys"
        "/usr/tmp"
      ];
    };
    /*
      # Monitor plug n play
      # https://github.com/phillipberndt/autorandr/blob/v1.0/README.md#how-to-use
      autorandr = {
      enable = true;
      };
    */
    xserver = {
      enable = true;
      # autorun = false;
      # videoDrivers = [ "intel" ];
      # videoDrivers = [ "nvidiaBeta" ];
      videoDrivers = [ "nvidia" ];
      layout = "us";
      xkbOptions = "eurosign:e";
      dpi = 90;

      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          naturalScrolling = false;
          additionalOptions = ''
            Option "PalmDetection" "True"
          '';
        };

      };

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        /*
          sessionCommands = ''
          ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          Xft.dpi: 192
          EOF
          '';
        */
        /*
          setupCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
          ${pkgs.xorg.xrandr}/bin/xrandr --auto
          '';
        */
        defaultSession = "none+i3";
        #autoLogin.enable = true;
        #autoLogin.user = "mudrii";

        lightdm = {
          enable = true;
          #greeter.enable = false; # for outo login
          greeter.enable = true;
        };
      };

      windowManager = {
        i3.enable = true;
        i3.package = pkgs.i3-gaps;
        i3.extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3lock #default i3 screen locker
          # i3status # gives you the default i3 status bar
          # i3blocks #if you are planning on using i3blocks over i3status
          # i3status-rust
          i3-gaps
          i3lock-fancy
          xautolock
          # rofi
          numlockx
          # conky
          # rxvt_unicode
          # rxvt_unicode-with-plugins
          # (lowPrio urxvt_perls)
          # (lowPrio urxvt_font_size)
          acpilight
          glxinfo
          pavucontrol
          networkmanager_dmenu
          arandr
          escrotum
          obs-studio
          libva-utils
          networkmanagerapplet
          gimp
        ];
      };
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    # font = "Powerline";
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      corefonts
      # inconsolata
      # unifont
      ubuntu_font_family
      # symbola
      nerdfonts
      freefont_ttf
      powerline-fonts
      # font-awesome
      font-awesome_4
      dejavu_fonts
      google-fonts
      noto-fonts
      # noto-fonts-cjk
      # noto-fonts-emoji
      # liberation_ttf
      # fira-code
      # fira-code-symbols
      # mplus-outline-fonts
      # dina-font
      # proggyfonts
      # emojione
      # twemoji-color-font
      # mononoki
    ];
  };

  # Enable sound.
  sound.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  #  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  #  environment.systemPackages = with pkgs; [ xorg.xbacklight ];

  environment = {
    etc."sysconfig/lm_sensors".text = ''
      # Generated by sensors-detect on Tue Aug  7 10:54:09 2018
      # This file is sourced by /etc/init.d/lm_sensors and defines the modules to
      # be loaded/unloaded.
      #
      # The format of this file is a shell script that simply defines variables:
      # HWMON_MODULES for hardware monitoring driver modules, and optionally
      # BUS_MODULES for any required bus driver module (for example for I2C or SPI).

      HWMON_MODULES="coretemp"
    '';

    # YubiKey SSH and GPG support

    shellInit = ''
        export GPG_TTY="$(tty)"
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      #  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';

    variables = {
      # Preferred applications
      EDITOR = "nvim";
      BROWSER = "qutebrowser";
    };

    enableDebugInfo = true;

    systemPackages = with pkgs; [
      efibootmgr
      efivar
      chkrootkit
      lynis
      # nixfmt
      nix-index
      nixpkgs-fmt
      nixpkgs-lint
      nix-prefetch
      nix-du
      nix-top
      nix-linter
      nixpkgs-review
      nixpkgs-pytools
      nix-update
      nix-tree
      nixos-generators
      nvd
      rnix-lsp
      unstable.nix-simple-deploy
      niv
      graphviz
      (lowPrio nix-prefetch-git)
      nix-prefetch-scripts
      #qemu
      #qemu-utils
      qemu_full
      #unstable.virt-manager
      #unstable.virt-viewer
      virt-manager
      virt-viewer
      virt-top
      # undervolt
      acpica-tools
      patchelf
      binutils
      cryptsetup
      dstat
      unstable.duf
      duff
      gptfdisk
      parted
      mc
      nnn
      # vifm
      # lf
      trash-cli
      traceroute
      whois
      which
      nmap
      wget
      curl
      speedtest-cli
      unstable.neovim
      # micro
      commonsCompress
      libarchive
      archiver
      # p7zip
      unzip
      unrar
      zstd
      unstable.cpu-x
      lsof
      acpi
      pciutils
      usbutils
      powertop
      tree
      jdupes
      #ag
      silver-searcher
      gtop
      iftop
      atop
      nethogs
      nmon
      iotop
      sysstat
      tcpdump
      atool
      rsync
      gnutls
      bind
      mkpasswd
      openssl
      unstable.cfssl
      file
      lshw
      lm_sensors
      inxi
      s-tui
      stress-ng
      tpacpi-bat
      # tlp
      cpufrequtils
      msr-tools
      nvtop
      sshfs
      vdpauinfo
      dmidecode
      fwupd
      # fwupdate
      ncdu
      smartmontools
      pass
      encfs
      linuxPackages.perf
      networkmanager
      wirelesstools
      # blueman
      # (lowPrio bluez)
      # bluez-tools
      mtr
      nftables
      psmisc
      ripgrep-all
      du-dust
      # exa
      srm
      tcpdump
      ethtool
      bmon
      (lowPrio inetutils)
      socat
      iptables
      iperf
      gping
      nload
      nvme-cli
      ncurses
      protonvpn-cli
      # unstable.protonvpn-gui
      openvpn
      wireguard-tools
      # wireshark-cli
      # wireshark
      # aircrack-ng
      gopass
      xmrig
      xmr-stak
      unstable.linux-wifi-hotspot
      unstable.dnsmasq
      # unstable.solaar # logitech mous unify receiver config
      #nextdns
    ];

    shellAliases = {
      ans = "ansible";
      ansp = "ansible-paybook";
      ansv = "ansible-vault";
      ccat = "pygmentize -f terminal256 -g -P style=monokai";
      cp = "cp -i";
      diff = "diff --color=auto";
      dmesg = "dmesg --color=always | lless";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      gcl = "gcloud";
      grep = "grep --color=auto";
      gadc = "git add -A; and git commit";
      gad = "git add .";
      gcm = "git commit";
      gdf = "git diff";
      gl = "git log";
      glg = "git log --color --graph --pretty --oneline";
      gpl = "git pull";
      gps = "git push";
      gst = "git status";
      kcl = "kubectl";
      kns = "kubens";
      ktx = "kubectx";
      la = "exa -alg --group-directories-first -s=type --icons";
      # la="ls -lha --color=auto --group-directories-first";
      lless = "set -gx LESSOPEN '|pygmentize -f terminal256 -g -P style=monokai %s' && set -gx LESS '-R' && less -m -g -i -J -u -Q";
      # ll="ls -lah";
      # ls="ls --color=auto";
      ll = "exa -la";
      ls = "exa";
      mv = "mv -i";
      nixcl = "sudo nix-store --optimise -v && sudo nix-collect-garbage -d";
      nixup = "sudo nix-channel --update && sudo nixos-rebuild switch";
      nixts = "sudo nix-channel --update && sudo nixos-rebuild test";
      nixg = "git --git-dir=$HOME/src/nixlenovodot/ --work-tree=/etc/nixos";
      py = "python";
      ping = "ping -c3";
      ps = "ps -ef";
      pvpn = "sudo protonvpn";
      pul = "pulumi";
      # rm = "rm -i";
      # rmf = "rm -rf";
      rm = "trash-put";
      unrm = "trash-restore";
      rmcl = "trash-empty";
      rml = "trash-list";
      sudo = "sudo -i";
      suf = "su --shell=/usr/bin/fish";
      ter = "terraform";
      vdir = "vdir --color=auto";
    };
  };

  users = {
    mutableUsers = false;
    users.irutsu = {
      isNormalUser = true;
      home = "/home/irutsu";
      shell = pkgs.fish;
      description = "irutsu";
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    # mkpasswd -m sha-512 password
      hashedPassword = "$6$/BP5EUle$Hycukkdtd/iBkM99UNrNIo5r/xQPIjBzK4QO2TXHRfjGZwYZJCwOMmcD1N5Wvw8M/5L/IJQLWEGhVSs8efnUS/";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzc7Xx3FVqz2cV1qzkPFV9DmfXCvS98HWs6nzcZ+1zMQDpZUuSGY2hV8UyXgiitogLl3BTaKztvBmrzh3FeeRHYDX39eR+tvcL7mY+qIqUwyCrDcrXC+KHuMVcYWJPJBx+enlId/ZbBgzz4SpBTOVANGDv1AhkNhl1CDfSrIOSdoRdhQpcYqtjwmiy/giGhfwNwtTGFVJNXG5CZEtyKRyjN43dX12/g6eEThLpjAS7QxF8pCzLh754rjD4V4Qmg/t+BawOglSyNaqEBtdyd0xiI353hzdNG4U+6V3yPYKSdkZzHaGACwCNMKSfrF7IrIQtUc5d9b0H+XEjpKzPWaZWXg9Io/vKhSTK4brXeAnsck4kbWYj1RiU6noAZNZRleM8fMO6UdwzLZzrxGMOBFSSZHHUlgLEjadkc2kmGwvXx5bmEUXMCAb7jUIzv+TEoOcJfCj8xUGxCQtlk9kIguV0l8BWY0B6iwyNn8XM7taLdfIEMACkuD9v0y7SCBWRm6DL3PoVijnGX+g3ox1bGvx/9+4h1HbPH3POj5/C2Vh6kWtXFKTVHSrU4m8HsV94slD4ILTyfJxGWgL2TzjSJz3eKUlVNe9r1Pv14CDb2XaN4lGGxWV2aYDYwCwNaZyJTOXi/9tiflfmcHIiYRoABrss6nssfL2f6fNa0hm0ZAUClw== mudrii@arch" ];
      packages = with pkgs; [
        home-manager
      ];
    };

    users.mudrii = {
      isNormalUser = true;
      home = "/home/mudrii";
      shell = pkgs.fish;
      description = "mudrii";
      extraGroups = [ "wheel" "docker" "lp" "audio" "video" "tty" "input" "networkmanager" "libvirtd" "disk" "kvm" "qemu-libvirtd" ];
      # mkpasswd -m sha-512 password
      hashedPassword = "$6$ewXNcoQRNG$czTic9vE8CGH.eo4mabZsHVRdmTjtJF4SdDnIK0O/4STgzB5T2nD3Co.dRpVS3/uDD24YUxWrTDy2KRv7m/3N1";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/tE2+oIwLnCnfzPSTqiZaeW++wUPNW5fOi124eGzWfcnOQGrjuwir3sZDKMS9DLqSTDNtvJ3/EZf6z/MLN/uxUE8lA+aKaSs0yopE7csQ89Aqkvp5fvCpz3BJuZgpxtwebPZyTc7QRGQWE4lM3fix3aJhfj827bdxA+sCiq8OnNiwYSXrIag1cQigafhLy6tYtCKdWcxzJq2ebGJF2wu2LU0zArb1SAOanhEOXxz0dG1I/7yMDBDC92R287nWpL+BwxuQcDv0xh/sWnViKixKv+B9ewJnz98iQPcg3WmYWe9BYAcaqkbgMqbwfUPqOHhFXmiQWUpOjsni2O6VoiN mudrii@nixos"];
      packages = with pkgs; [
        home-manager
        unstable.bpytop
        unstable.glances
        neofetch
        poppler_utils
        elinks
        w3m
        ffmpeg-full
        ffmpegthumbnailer
        exif
        exiftool
        mupdf
        screen
        keychain
        unstable.minio-client
        google-cloud-sdk-gce
        unstable.awscli
       # unstable.clojure
       # clojure-lsp
       # pulumi-bin
       # unstable.pulumi-bin
        unstable.gitAndTools.gitFull
        unstable.gitAndTools.gh
        unstable.git-crypt
        unstable.git-lfs
        unstable.terraform
        unstable.terraform-lsp
        unstable.tflint
        unstable.kubernetes
        unstable.kubernetes-helm
       # unstable.kubeseal
       # unstable.helmfile
       # unstable.helmsman
       # unstable.kind
       # unstable.kube3d
       # unstable.skopeo
       # unstable.dive
       # unstable.lens
       # unstable.docker-machine-kvm2
       # unstable.minikube
       # unstable.fluxctl
       # unstable.argo
       # unstable.argocd
       # unstable.kustomize
       # unstable.k9s
       # unstable.velero
       # unstable.go
       # unstable.xmind
       # teams
        signal-desktop
       # kubectx
        dep
        /*
        (unstable.terraform.withPlugins(p: with p; [
          archive
          aws
          external
          google
          helm
          kubernetes
          local
          null
          random
          template
        ]))
        */
        # (lowPrio unstable.python39Full)
        # python3Full
        # python39Full
        # python39Packages.poetry
        # unstable.python38Packages.pynvim
        # poetry
        (
          python39.withPackages (
            ps: with ps; [
              #poetry
              pip
              powerline
              pygments
              yubico-client
              pygments-markdown-lexer
              xstatic-pygments
              # pylint
              # pandas
              # pycuda
              # numpy
              # opencv4
              # scipy
              # matplotlib
              # jupyter
              pynvim
              pyopenssl
            ]
          )
        )
        aspell
        aspellDicts.en
        asciinema
        unstable.direnv
        psensor
        thunderbird
        # libreoffice
        onlyoffice-bin
        qutebrowser
        bitwarden
        bitwarden-cli
        shotcut
        # unstable.amfora
        unstable.lagrange
        unstable.vscode
        # vscodium
        unstable.sublime4
        unstable.sublime-merge
        # unstable.insomnia
        slack
        vlc
        gpicview
        ripgrep
        ripgrep-all
        tldr
        procs
        fd
        # zathura
        mpv
        pv
        feh
        # weechat
        gcc
        gnumake
        gnupg
        pinentry-curses
        pinentry-qt
        paperkey
        pam_u2f
        libu2f-host
        libu2f-server
        gpa
        imagemagick
        spotify
        bookworm
        ltrace
        /*
          (unstable.tor-browser-bundle-bin.override {
          mediaSupport = true;
          pulseaudioSupport = true;
          })
        */
        unstable.keepassxc
        openconnect_openssl
        networkmanager-openconnect
        unstable.element-desktop
        unstable.ansible
        graphviz
        scrcpy
        unstable.pcmanfm
        #mucommander
        unstable.hexchat
        unstable.grsync
        unstable.luckybackup
        unstable.drawio
        unstable.youtube-dl
        yubikey-manager
        yubico-piv-tool
        yubikey-manager-qt
        yubikey-personalization
        yubikey-personalization-gui
        yubioath-desktop
        yubico-pam
        unstable.monero
        unstable.monero-gui
        #unstable.xmrig
        #unstable.xmr-stak
        unstable.ledger
        unstable.ledger-web
        unstable.ledger-live-desktop
        unstable.audacity
        unstable.nodejs
        unicode-paracode
        system-config-printer
        play-with-mpv
        jetbrains.idea-ultimate
        viber
      ];
    };
  };

  nix = {
    # package = pkgs.nixUnstable;
    package = pkgs.nixFlakes;
    useSandbox = true;
    autoOptimiseStore = true;
    readOnlyStore = false;
    allowedUsers = [ "@wheel" "mudrii" ];
    trustedUsers = [ "@wheel" "mudrii" ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      # preallocate-contents = false
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d --max-freed $((64 * 1024**3))";
      # dates = "Mon *-*-* 06:00:00";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

  };

  nixpkgs = {
    config = {
      pulseaudio = true;
      allowBroken = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "python3.9-poetry-1.1.12"
      ];
      packageOverrides = pkgs: {
        # unstable = import <nixpkgs-unstable> {
        #   config = config.nixpkgs.config;
        # };
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    /*
      overlays = [
      (self: super: {

      element-desktop = super.element-desktop.overrideAttrs (old: rec {
      version = "1.7.27";
      src = pkgs.fetchFromGitHub {
      owner = "vector-im";
      repo = "element-desktop";
      rev = "v${version}";
      sha256 = "0rgsc2cc1v6gjsklwvsjlqq9a8j9j80h9ac0jkvf9lhq33f3c57k";
      };
      });

      /*
      fwup = super.fwup.overrideAttrs (old: {
      src = super.fetchFromGitHub {
      owner = "fhunleth";
      repo = "fwup";
      rev = "v1.8.3";
      sha256 = "0p3kp1kai5zrgagjzhd41gl84gfqk04qnq1d1dnf0ckvhsfdq9vb";
      };
      buildInputs = with super; [
      libarchive
      libconfuse
      which
      xdelta
      ];
      });
    */
    /*
      youtube-dl = super.youtube-dl.overrideAttrs (old: rec {
      pname = "youtube-dl";
      version = "2020.11.11-3";
      postInstall = "";
      src = pkgs.fetchurl {
      url = "https://github.com/blackjack4494/yt-dlc/archive/${version}.tar.gz";
      sha256 = "116azzzj0df3bv99zwn0rsarirw56knbq7xqn1fs8v4ilslqp7v4";
      };
      });
    */
    #      })
    #    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system = {
    copySystemConfiguration = true;
    stateVersion = "22.05"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      dates = "weekly";
      allowReboot = false;
      # dates = "Sun *-*-* 04:00:00";
    };
  };
  /*
    system = {
    autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = self.outPath;
    flags = [
    "--recreate-lock-file"
    "--no-write-lock-file"
    "-L" # print build logs
    ];
    dates = "daily";
    };
    }:
  */
}
