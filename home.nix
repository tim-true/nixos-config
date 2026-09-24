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

  # `matchBlocks` and `addKeysToAgent` are deprecated aliases; `settings` is the
  # replacement and takes upstream OpenSSH directive names verbatim.
  #
  # enableDefaultConfig = false opts out of home-manager's legacy `Host *`
  # defaults, which are on their way out. Everything it used to set (ForwardAgent
  # no, Compression no, ControlMaster no, ...) already matches OpenSSH's own
  # built-in defaults, so the only one worth restating is AddKeysToAgent.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      # GitHub over 443 so it works from networks that block port 22.
      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
      };
      "*".AddKeysToAgent = "yes";
    };
  };

  programs.fish = {
    enable = true; 
    shellAliases = {
      avalon-rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#avalon";
      flake-update = "sudo nix flake update --flake ~/nixos-config";
      randmac = "sudo systemctl stop NetworkManager && sudo macchanger -r wlp0s20f3 && sudo systemctl start NetworkManager";
    };
  };
}
