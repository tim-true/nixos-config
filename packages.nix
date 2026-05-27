{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

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
    gcc
    gnumake
    jetbrains.clion
    jetbrains.idea
    jetbrains.pycharm
    zed-editor
    #sublime-merge
    #sublime4

    # Networking
    curl
    macchanger
    qbittorrent
    rsync
    tor
    traceroute
    wget

    # Browsers & Internet
    firefox
    librewolf
    thunderbird
    tor-browser

    # Media & Graphics
    blender
    darktable
    ffmpeg-full
    freecad
    gimp
    prusa-slicer
    spotify
    video-trimmer
    vlc

    # Office & Productivity
    libreoffice
    obsidian

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
