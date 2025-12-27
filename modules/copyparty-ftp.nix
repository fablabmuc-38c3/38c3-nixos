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

    # Passive FTP data ports (must match firewall below)
    ftpps = "21100-21110";
  };
}
