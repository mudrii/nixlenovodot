{ config, pkgs, lib, ... }:

{
  home-manager.users.mudrii = {
    programs.ssh = {
      enable = true;
      compression = true;
      controlMaster = "auto";
      controlPersist = "10m";
      forwardAgent = true;
      hashKnownHosts = true;
      matchBlocks = {
        github = {
          host = "github.com";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_rsa_yubikey.pub";
        };
        nixtst = {
          hostname = "192.168.122.15";
          user = "mudrii";
        };
        rasvi = {
          hostname = "192.168.86.33";
          user = "pi";
        };
        piholew = {
          hostname = "192.168.86.22";
          user = "pi";
        };
        piholel = {
          hostname = "192.168.1.12";
          user = "pi";
        };
        rasviv = {
          hostname = "192.168.1.9";
          user = "pi";
        };
        rasppi1 = {
          hostname = "192.168.1.8";
          user = "pi";
        };
        rasppi2 = {
          hostname = "192.168.1.7";
          user = "pi";
        };
        rasppi3 = {
          hostname = "192.168.1.6";
          user = "pi";
        };
        rasppi4 = {
          hostname = "192.168.1.4";
          user = "pi";
        };
        rasmasterm = {
          hostname = "192.168.1.3";
          user = "pi";
        };
      };
    };
  };
}

