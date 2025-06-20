# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."ftpserver" = {
    image = "metabrainz/docker-anon-ftp";
    environment = {
      "FTPD_BANNER" = "Welcome to the Faboulous FTP Mate Box!";
    };
    volumes = [
      "/etc/vsftpd.conf:/etc/vsftp.conf:ro"
      "/flash/media:/var/ftp:rw"
    ];
    ports = [
      "21:21/tcp"
      "20:20/tcp"
      "65500:65500/tcp"
      "65501:65501/tcp"
      "65502:65502/tcp"
      "65503:65503/tcp"
      "65504:65504/tcp"
      "65505:65505/tcp"
      "65506:65506/tcp"
      "65507:65507/tcp"
      "65508:65508/tcp"
      "65509:65509/tcp"
      "65510:65510/tcp"
      "65511:65511/tcp"
      "65512:65512/tcp"
      "65513:65513/tcp"
      "65514:65514/tcp"
      "65515:65515/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=vsftpd"
      "--network=traefik-test_default"
    ];
  };
  systemd.services."podman-ftpserver" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-traefik-test_default.service"
    ];
    requires = [
      "podman-network-traefik-test_default.service"
    ];
    partOf = [
      "podman-compose-traefik-test-root.target"
    ];
    wantedBy = [
      "podman-compose-traefik-test-root.target"
    ];
  };
  virtualisation.oci-containers.containers."oauth2-proxy" = {
    image = "quay.io/oauth2-proxy/oauth2-proxy:latest";
    environment = {
      "OAUTH2_PROXY_CLIENT_ID" = "Ov23liKH7rfJBxmBN0vI";
      "OAUTH2_PROXY_CLIENT_SECRET" = "99e4c67b304b2f7147926e29fa602507358a7ccc";
      "OAUTH2_PROXY_COOKIE_DOMAINS" = ".38c3.tschunk.social";
      "OAUTH2_PROXY_COOKIE_SECRET" = "acVnYPFTRTdvZ2ypgAKaTmBLy_isCpE9dH6FGLNbgBo=";
      "OAUTH2_PROXY_EMAIL_DOMAINS" = "*";
      "OAUTH2_PROXY_GITHUB_ORG" = "fablabmuc-38c3";
      "OAUTH2_PROXY_PASS_USER_HEADERS" = "true";
      "OAUTH2_PROXY_PROVIDER" = "github";
      "OAUTH2_PROXY_REDIRECT_URL" = "https://oauth2.38c3.tschunk.social/oauth2/callback";
      "OAUTH2_PROXY_REVERSE_PROXY" = "true";
      "OAUTH2_PROXY_SET_XAUTHREQUEST" = "true";
      "OAUTH2_PROXY_SHOW_DEBUG_ON_ERROR" = "true";
      "OAUTH2_PROXY_UPSTREAMS" = "static://202";
      "OAUTH2_PROXY_WHITELIST_DOMAINS" = ".38c3.tschunk.social";
    };
    ports = [
      "4180:4180/tcp"
    ];
    cmd = [ "--http-address=0.0.0.0:4180" ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.oauth2.entrypoints" = "websecure";
      "traefik.http.routers.oauth2.rule" = "(Host(`oauth2.38c3.tschunk.social`) && PathPrefix(`/oauth2/`)) || (PathPrefix(`/oauth2/`))";
      "traefik.http.routers.oauth2.tls" = "true";
      "traefik.http.routers.oauth2.tls.certResolver" = "letsencrypt";
      "traefik.http.services.oauth2.loadbalancer.server.port" = "4180";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=oauth2-proxy"
      "--network=traefik-test_default"
    ];
  };
  systemd.services."podman-oauth2-proxy" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-traefik-test_default.service"
    ];
    requires = [
      "podman-network-traefik-test_default.service"
    ];
    partOf = [
      "podman-compose-traefik-test-root.target"
    ];
    wantedBy = [
      "podman-compose-traefik-test-root.target"
    ];
  };
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "ghcr.io/hotio/qbittorrent";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Etc/UTC";
      "UMASK" = "002";
      "WEBUI_PORTS" = "8080/tcp,8080/udp";
    };
    volumes = [
      "/flash/downloads:/data:rw"
      "traefik-test_qbittorrent-data:/config:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.torrent.entryPoints" = "websecure";
      "traefik.http.routers.torrent.middlewares" = "oauth2-auth@file";
      "traefik.http.routers.torrent.rule" = "Host(`torrent.38c3.tschunk.social`)";
      "traefik.http.routers.torrent.tls.certResolver" = "letsencrypt";
      "traefik.http.services.torrent.loadbalancer.server.port" = "8080";
      "traefik.port" = "8080";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=qbittorrent"
      "--network=traefik-test_default"
    ];
  };
  systemd.services."podman-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-traefik-test_default.service"
      "podman-volume-traefik-test_qbittorrent-data.service"
    ];
    requires = [
      "podman-network-traefik-test_default.service"
      "podman-volume-traefik-test_qbittorrent-data.service"
    ];
    partOf = [
      "podman-compose-traefik-test-root.target"
    ];
    wantedBy = [
      "podman-compose-traefik-test-root.target"
    ];
  };
  virtualisation.oci-containers.containers."simple-service" = {
    image = "mendhak/http-https-echo";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.whoami.entryPoints" = "websecure";
      "traefik.http.routers.whoami.middlewares" = "oauth2-auth@file";
      "traefik.http.routers.whoami.rule" = "Host(`whoami.38c3.tschunk.social`)";
      "traefik.http.routers.whoami.tls.certResolver" = "letsencrypt";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=whoami"
      "--network=traefik-test_default"
    ];
  };
  systemd.services."podman-simple-service" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-traefik-test_default.service"
    ];
    requires = [
      "podman-network-traefik-test_default.service"
    ];
    partOf = [
      "podman-compose-traefik-test-root.target"
    ];
    wantedBy = [
      "podman-compose-traefik-test-root.target"
    ];
  };
  virtualisation.oci-containers.containers."whoami" = {
    image = "traefik/whoami";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.whoami2.entryPoints" = "websecure";
      "traefik.http.routers.whoami2.middlewares" = "oauth2-auth@file";
      "traefik.http.routers.whoami2.rule" = "Host(`whoami.38c3.tschunk.social`) && Header(`x-auth-request-user`, `DragonHunter274`)";
      "traefik.http.routers.whoami2.tls.certResolver" = "letsencrypt";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=whoami2"
      "--network=traefik-test_default"
    ];
  };
  systemd.services."podman-whoami" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-traefik-test_default.service"
    ];
    requires = [
      "podman-network-traefik-test_default.service"
    ];
    partOf = [
      "podman-compose-traefik-test-root.target"
    ];
    wantedBy = [
      "podman-compose-traefik-test-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-traefik-test_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f traefik-test_default";
    };
    script = ''
      podman network inspect traefik-test_default || podman network create traefik-test_default
    '';
    partOf = [ "podman-compose-traefik-test-root.target" ];
    wantedBy = [ "podman-compose-traefik-test-root.target" ];
  };

  # Volumes
  systemd.services."podman-volume-traefik-test_qbittorrent-data" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect traefik-test_qbittorrent-data || podman volume create traefik-test_qbittorrent-data
    '';
    partOf = [ "podman-compose-traefik-test-root.target" ];
    wantedBy = [ "podman-compose-traefik-test-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-traefik-test-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
