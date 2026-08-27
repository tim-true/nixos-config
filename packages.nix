{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.problems.handlers.sublimetext4.broken = "ignore";
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
    nfs-utils

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
    zed-editor
    sublime-merge
    sublime4

    # Networking
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
    (obsidian.override { commandLineArgs = "--no-sandbox --disable-gpu"; })

    # System Utilities
    bitwarden-desktop
    fwupd
    gnome-disk-utility
    gparted
    kdePackages.filelight
    pdftricks
    rofi
    rpi-imager
    unzip

    # Games
    bastet
    steam

  ];
}
