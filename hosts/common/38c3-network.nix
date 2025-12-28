{ config, pkgs, ... }:

{
  networking.tempAddresses = "disabled";
  #networking.interfaces.enp1s0.acceptRA = true;
  #  networking.interfaces.enp43s0 = {
  #    ipv4.addresses = [
  #      {
  #        address = "151.217.62.81";
  #        prefixLength = 23;
  #      }
  #    ];
  #  };
  networking.networkmanager = {
    settings.connection."ipv6.addr-gen-mode" = "eui64";
    settings.connection."ipv6.ip6-privacy" = "0";
  };
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  networking.extraHosts = ''
    2a01:4f8:1c1f:b8da::2 github.com
    2a01:4f8:1c1f:b8da::3 api.github.com
    2a01:4f8:1c1f:b8da::4 codeload.github.com
    2a01:4f8:1c1f:b8da::6 ghcr.io
    2a01:4f8:1c1f:b8da::7 pkg.github.com npm.pkg.github.com maven.pkg.github.com nuget.pkg.github.com rubygems.pkg.github.com
    2a01:4f8:1c1f:b8da::8 uploads.github.com
    2606:50c0:8000::133 objects.githubusercontent.com www.objects.githubusercontent.com release-assets.githubusercontent.com gist.githubusercontent.com repository-images.githubusercontent.com camo.githubusercontent.com private-user-images.githubusercontent.com avatars0.githubusercontent.com avatars1.githubusercontent.com avatars2.githubusercontent.com avatars3.githubusercontent.com cloud.githubusercontent.com desktop.githubusercontent.com support.github.com
    2606:50c0:8000::154 support-assets.githubassets.com github.githubassets.com opengraph.githubassets.com github-registry-files.githubusercontent.com github-cloud.githubusercontent.com
  '';

  #  networking.defaultGateway.interface = "enp43s0";
  #  networking.defaultGateway.address = "151.217.62.1";

  services.lldpd.enable = true;

  services.lldpd.extraArgs = [
    "-S"
    "Assembly: Fabulous Lab Munich - contact: admin@dh274.com - description: Server in Club Mate Crate"
  ];
  networking.firewall.allowedUDPPorts = [ 646 ]; # Port used for LLDP

  # Firewall
  networking.firewall = {
    enable = true;

    pingLimit = "--limit 1/minute --limit-burst 5";

    # Allow HTTP and HTTPS on all interfaces
    allowedTCPPorts = [
      80
      443
      21
      22
      25565
      3923
    ];

    # Allow FTP and ssh on enp43s0
    allowedTCPPortRanges = [
      {
        from = 21100;
        to = 21110;
      } # Passive mode data ports
    ];

    interfaces.tailscale0 = {
      allowedTCPPorts = [ 22 ];
    };

  };
}
