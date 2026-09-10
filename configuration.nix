# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-88737d29-779b-4d69-a7e6-7ca12838b8b3".device = "/dev/disk/by-uuid/88737d29-779b-4d69-a7e6-7ca12838b8b3";
  networking.hostName = "avalon"; 
 
  # Enable NetworkManager
  networking.networkmanager.enable = true;
  #networking.networkmanager.wifi.macAddress = "random";

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable VirtualBox (host). Installs the VirtualBox package + kernel modules.
  virtualisation.virtualbox.host.enable = true;
  # Extension pack: USB 2.0/3.0, RDP, disk encryption, PXE boot.
  # NOTE: unfree and not in the binary cache, so this compiles locally.
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable Tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  services.tailscale.extraUpFlags = [ "--accept-routes" ];

  # Connect to Tailscale automatically at boot. The node is already
  # authenticated, so this just flips it to "running" and (re)installs accepted
  # subnet routes — which is what lets the QNAP shares mount on boot when
  # off-LAN. `tailscale down` still works for a session; it comes back on the
  # next boot. Remove this block to go back to connecting by hand.
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = "20s";
    };
    script = "${pkgs.tailscale}/bin/tailscale up --accept-routes";
  };

  # Enable fwupd firmware update daemon (provides `fwupdmgr`, LVFS metadata,
  # D-Bus activation and udev rules). The package alone is not enough.
  services.fwupd.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define user account.
  users.users.tim = {
    isNormalUser = true;
    description = "Tim";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  security.pam.services.lightdm.enableGnomeKeyring = true;

  system.stateVersion = "25.11";

}
