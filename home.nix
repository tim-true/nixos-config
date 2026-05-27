{ pkgs, ... }:
{
  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark";
    terminal = "${pkgs.xfce.xfce4-terminal}";
  };

  home.packages = with pkgs; [
    # User only packages
  ];

  programs.git = {
    enable = true;
    userName = "tim";
    userEmail = "phantom6047@protonmail.com";
  };
}
