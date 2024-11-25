{ config, pkgs, ... }:

{

  system.activationScripts.updateUnboundRecords =
    let
      records = ''
        server:
        # local-zone: "38c3.tschunk.social." static
         local-zone: "38c3.tschunk.social" redirect
         local-data: "38c3.tschunk.social IN  A 10.1.1.76"
         local-data: "bla.tld IN  A 10.1.1.76"
      '';
    in
    ''
      cat > /etc/unbound/conf.d/records.conf << EOF
      ${records}
      EOF
      chown root:root /etc/unbound/conf.d/records.conf
      chmod 0644 /etc/unbound/conf.d/records.conf
    '';

}
