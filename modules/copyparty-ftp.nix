{ lib, config, ... }:

{
  services.copyparty.enable = true;

  # Copyparty config is passed through as commandline flags / config values.
  services.copyparty.settings = {
    # Bind only on IPv6 ("::" = all IPv6 interfaces)
    # If you want dual-stack later, use a list with both "::" and "0.0.0.0".
    i = "::";

    # Enable FTP(S) server in Copyparty
    ftp = 21;

    # Anonymous read-only account.
    # NOTE: Copyparty's actual access control is driven by volume rules.
    a = [
      "*::r"
    ];

    # Passive FTP data ports
    # Copyparty flag name: --ftp-pr
    "ftp-pr" = "21100-21110";
  };

  # Serve this directory.
  # Copyparty calls these "volumes"; each volume is a named share.
  # We expose /flash/media as the root of a volume named "media".
  services.copyparty.volumes = {
    media = {
      path = "/flash/media";
      # anonymous read-only
      access = {
        "*" = [ "r" ];
      };
    };
  };

  # Copyparty runs as user `copyparty`, so binding privileged ports (like 21)
  # requires CAP_NET_BIND_SERVICE.
  systemd.services.copyparty.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
  };
}
