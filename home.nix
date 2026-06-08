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

  home.file.".nanorc".text = "set linenumbers\n";

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks."github.com" = {
      hostname = "ssh.github.com";
      port = 443;
      user = "git";
    };
  };

  programs.fish = {
    enable = true; 
    shellAliases = {
      avalon-rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#avalon";
      flake-update = "sudo nix flake update --flake ~/nixos-config";
    };
  };
}
