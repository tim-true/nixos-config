{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI
    git
    vim
    htop
    btop
    glances
    fish
    fastfetch
    powertop
    alacritty
    onefetch

    # Utilities
    rofi
    bitwarden-desktop
    gnome-disk-utility
    gparted
    kdePackages.filelight
    unzip
    pdftricks
    rpi-imager
    fwupd

    # Networking
    tor
    traceroute
    qbittorrent
    wget
    curl
    rsync
    macchanger
    
    # Dev
    gcc
    gnumake
    code
    jetbrains.clion
    jetbrains.idea
    jetbrains.pycharm
    zed-editor
    claude-code
    claude-monitor
    #sublime-merge
    #sublime4

    # Internet
    firefox
    thunderbird
    tor-browser
    librewolf

    # Multimedia
    spotify
    vlc
    blender
    darktable
    gimp
    freecad
    video-trimmer
    prusa-slicer
    ffmpeg-full

    # Uncatagorized
    obsidian
    libreoffice
    
    # Games
    steam
    bastet
    
  ];
}
