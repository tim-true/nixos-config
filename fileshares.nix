# File shares / cloud storage — everything mounted under /mnt.
# Wired in via flake.nix's module list, same as packages.nix.
#
#   /mnt/onedrive     OneDrive (abraunegg/onedrive), local two-way sync
#   /mnt/protondrive  Proton Drive, rclone FUSE mount (networked, not a copy)
#   /mnt/qnap/<name>  QNAP NFS shares (data, backups, movies, shows)

{ config, lib, pkgs, ... }:

let
  # QNAP. Private LAN address — reachable directly on the LAN, or off-LAN via
  # the Tailscale subnet route (configuration.nix sets --accept-routes and
  # tailscale-autoconnect brings the tunnel up at boot).
  nasHost = "192.168.1.34";

  # /mnt/qnap/<name>  <-  ${nasHost}:<export path on the NAS>
  # Confirm the export paths in the QNAP UI: Control Panel > Shared Folders >
  # Edit > NFS  (often /share/CACHEDEV1_DATA/<Name>, case-sensitive).
  qnapShares = {
    data    = "/share/data";
    backups = "/share/backups";
    movies  = "/share/movies";
    shows   = "/share/shows";
  };

  nfsOptions = [
    "nfsvers=4"
    "noatime"
    "x-systemd.automount"          # mount on first access, nothing at boot
    "x-systemd.idle-timeout=600"   # unmount after 10 min idle
    "x-systemd.mount-timeout=20s"
    "_netdev"
    "soft" "timeo=50" "retrans=2"  # fail fast instead of hanging when unreachable
  ];
in
{
  environment.systemPackages = [ pkgs.rclone pkgs.fuse3 pkgs.nfs-utils ];
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;   # required for NFSv3; harmless for v4

  # Mount points for the two cloud dirs (NFS mount points are made by NixOS).
  # Owned by tim so the user services can populate them.
  systemd.tmpfiles.rules = [
    "d /mnt/onedrive    0755 tim users -"
    "d /mnt/protondrive 0755 tim users -"
  ];

  ############################################################################
  # OneDrive  (abraunegg/onedrive) -> /mnt/onedrive
  ############################################################################
  # `onedrive-launcher` (auto-enabled user service) spawns
  # `onedrive@onedrive.service` (`onedrive --monitor`) on login.
  #
  # First-time / after changing sync_dir, as your user (no sudo):
  #   rsync -a ~/OneDrive/ /mnt/onedrive/     # move existing data first
  #   onedrive --resync                       # required after a sync_dir change
  #   systemctl --user restart onedrive@onedrive.service
  # Status: systemctl --user status onedrive@onedrive.service
  services.onedrive.enable = true;
  home-manager.users.tim.xdg.configFile."onedrive/config".text = ''
    sync_dir = "/mnt/onedrive"
  '';

  ############################################################################
  # Proton Drive  (rclone read/write FUSE mount) -> /mnt/protondrive
  ############################################################################
  # Networked mount, not a local copy; a VFS cache under ~/.cache/rclone
  # absorbs reads/writes.
  #
  # One-time setup, as your user (no sudo):
  #   rclone config
  #     n) new remote -> name: proton -> storage: protondrive
  #     enter Proton email + password (+ mailbox password if two-password mode)
  #     enter a current 2FA code when prompted
  #   systemctl --user start protondrive-mount.service
  # Note: the protondrive backend uses Proton's unofficial API and can break on
  # Proton-side changes; rclone.conf holds lightly-obscured credentials (chmod 600).
  systemd.user.services.protondrive-mount = {
    description = "Proton Drive (rclone FUSE mount at /mnt/protondrive)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    # /run/wrappers/bin has the setuid fusermount3 an unprivileged user needs to
    # mount FUSE; the default user-service PATH doesn't include it.
    path = [ "/run/wrappers" ];
    serviceConfig = {
      Type = "notify";
      # Clear a stale mount left by an unclean shutdown; ignore failure.
      ExecStartPre = "-/run/wrappers/bin/fusermount3 -uz /mnt/protondrive";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount proton: /mnt/protondrive \
          --vfs-cache-mode full \
          --dir-cache-time 1h \
          --transfers 1 --checkers 1 \
          --umask 077
      '';
      ExecStop = "/run/wrappers/bin/fusermount3 -u /mnt/protondrive";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  ############################################################################
  # QNAP NAS  (NFS) -> /mnt/qnap/{data,backups,movies,shows}
  ############################################################################
  # Declarative automounts: the automount units come up at boot, but the actual
  # NFS mount happens transparently on first access to /mnt/qnap/<name>, so boot
  # never waits on the NAS and a missing NAS just makes access fail (soft) rather
  # than hang. `ls /mnt/qnap/movies` is enough to trigger a mount.
  fileSystems = lib.mapAttrs'
    (name: export: lib.nameValuePair "/mnt/qnap/${name}" {
      device = "${nasHost}:${export}";
      fsType = "nfs";
      options = nfsOptions;
    })
    qnapShares;
}
