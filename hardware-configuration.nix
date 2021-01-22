# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{

  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "coretemp" "kvm-intel" "acpi_call" "tp_smapi" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.acpi_call
    config.boot.kernelPackages.tp_smapi
  ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/7f4bbb31-4183-4ec4-9927-0a5fa2c5f2e9";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/40dd2d7f-06d6-4092-8611-8944d1408cd0";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/7C04-BEEF";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/swapfile"; } ];

  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

}
