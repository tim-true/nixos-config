{ pkgs, ... }:
{
  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark";
    terminal = "${pkgs.xfce4-terminal}";
  };

  home.packages = with pkgs; [
    # User only packages
  ];

  programs.git = {
    enable = true;
    settings.user.name = "tim";
    includes = [{ path = "~/.gitconfig.local"; }];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".AddKeysToAgent = "yes";
  };

  home.file.".nanorc".text = "set linenumbers\n";

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };
}
