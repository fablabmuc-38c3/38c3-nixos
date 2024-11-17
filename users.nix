{ config, pkgs, ... }:

{

  users.users.server = {
    isNormalUser = true;
    description = "server";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      k9s
      neovim
    ];
  };

  users.users.simon = {
    isNormalUser = true;
    description = "simon";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      k9s
      neovim
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiyUMQ0cq4JoU1aDRq4QwSMxva3+pdayZ2pSi1PG8Gl 38c3-server-simon"
    ];
  };
}
