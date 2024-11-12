{ config, pkgs, ... }:

{
  networking.interfaces.enp0s1.ipv6.privacy = "disable";
  networking.useDHCPv6 = false;
  networking.interfaces.enp0s1.acceptRA = true;

  services.lldpd.enable = true;

  # Configure additional LLDP options
  services.lldpd.extraConfig = ''
    configure system hostname ${config.networking.hostName};
    configure system description "Fabulous Lab Munich Assembly Server in Club Mate Crate";
    configure system contact "admin@dh274.com";
  '';

  networking.firewall.allowedUDPPorts = [ 646 ]; # Port used for LLDP

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
