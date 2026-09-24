{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  # sublime4 declares two meta.problems and each needs its own handler:
  #   broken  - plugin host needs insecure OpenSSL (only for versions < 4205)
  #   removal - Python 3.3 plugin support dropped ahead of upstream
  # Neither affects normal editing, so silence both.
  nixpkgs.config.problems.handlers.sublimetext4 = {
    broken = "ignore";
    removal = "ignore";
  };
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "electron-39.8.10"
    "librewolf-151.0.2-1"
    "librewolf-unwrapped-151.0.2-1"
  ];

  environment.systemPackages = with pkgs; [
    # CLI
    alacritty
    btop
    fastfetch
    fish
    git
    glances
    htop
    onefetch
    powertop
    vim

    # Development
    claude-code
    claude-monitor
    code
    docker
    gcc
    gnumake
    jetbrains.clion
    jetbrains.idea
    jetbrains.pycharm
    nodejs
    zed-editor
    sublime-merge
    sublime4

    # Networking
    # NOTE: tailscale (the daemon + `tailscale` CLI) is installed by
    # `services.tailscale.enable` in configuration.nix. Do NOT add `tailscale`
    # here - the module-provided one is what tailscaled actually runs against.
    curl
    macchanger
    nmap
    proton-vpn
    qbittorrent
    rsync
    tail-tray
    tailscale-systray
    tor
    traceroute
    wget

    # Browsers & Internet
    discord
    firefox
    librewolf
    protonmail-desktop
    thunderbird
    tor-browser

    # Media & Graphics
    blender
    darktable
    ffmpeg-full
    gimp
    prusa-slicer
    spotify
    video-trimmer
    vlc

    # Office & Productivity
    libreoffice
    onlyoffice-desktopeditors
    (obsidian.override { commandLineArgs = "--no-sandbox --disable-gpu"; })

    # System Utilities
    # NOTE: fwupd (the `fwupdmgr` CLI) is installed by `services.fwupd.enable`
    # in configuration.nix. Do NOT add `fwupd` here.
    bitwarden-desktop
    gnome-disk-utility
    gparted
    kdePackages.filelight
    pdftricks
    rofi
    rpi-imager
    unzip
    xarchiver

    # Games
    bastet
    steam

    # Virtualization
    # NOTE: VirtualBox (GUI + CLI + kernel modules + extension pack) is installed
    # by `virtualisation.virtualbox.host.enable` in configuration.nix. Do NOT add
    # `virtualbox` here - it would collide with the module-provided package.

  ];
}
