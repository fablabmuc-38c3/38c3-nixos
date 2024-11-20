# Auto-generated using compose2nix v0.2.3.
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
  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."bazarr" = {
    image = "lscr.io/linuxserver/bazarr";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/London";
    };
    volumes = [
      "/home/simon/compose-test/bazarr/data/config:/config:rw"
      "/mounted:/video:rw"
    ];
    ports = [
      "6767:6767/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.bazarr.entryPoints" = "websecure";
      "traefik.http.routers.bazarr.rule" = "Host(`bazarr.domain.name`)";
      "traefik.http.routers.bazarr.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.bazarr.loadbalancer.server.port" = "6767";
      "traefik.port" = "6767";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=bazarr"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-bazarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."flaresolverr" = {
    image = "flaresolverr/flaresolverr:latest";
    environment = {
      "CAPTCHA_SOLVER" = "none";
      "LOG_HTML" = "false";
      "LOG_LEVEL" = "info";
      "TZ" = "Europe/Paris";
    };
    ports = [
      "8191:8191/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=flaresolverr"
      "--network=38c3-compose_default"
    ];
  };
  systemd.services."podman-flaresolverr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-38c3-compose_default.service"
    ];
    requires = [
      "podman-network-38c3-compose_default.service"
    ];
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."heimdall" = {
    image = "ghcr.io/linuxserver/heimdall";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/Paris";
    };
    volumes = [
      "/home/simon/compose-test/heimdall:/config:rw"
    ];
    ports = [
      "90:90/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.heimdall.entryPoints" = "websecure";
      "traefik.http.routers.heimdall.rule" = "Host(`hub.domain.name`)";
      "traefik.http.routers.heimdall.tls.certResolver" = "letsEncrypt";
      "traefik.port" = "80";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=heimdall"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-heimdall" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."lidarr" = {
    image = "lscr.io/linuxserver/lidarr";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/paris";
    };
    volumes = [
      "/home/simon/compose-test/lidarr/data:/config:rw"
      "/mounted:/music:rw"
    ];
    ports = [
      "8686:8686/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.lidarr.entryPoints" = "websecure";
      "traefik.http.routers.lidarr.rule" = "Host(`lidarr.domain.name`)";
      "traefik.http.routers.lidarr.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.lidarr.loadbalancer.server.port" = "8686";
      "traefik.port" = "8686";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=lidarr"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-lidarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."overseerr" = {
    image = "sctx/overseerr:latest";
    environment = {
      "LOG_LEVEL" = "info";
      "TZ" = "Europe/Paris";
    };
    volumes = [
      "/home/simon/compose-test/overseerr/app/config:/app/config:rw"
    ];
    ports = [
      "5055:5055/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.overseerr.entryPoints" = "websecure";
      "traefik.http.routers.overseerr.rule" = "Host(`request.domain.name`)";
      "traefik.http.routers.overseerr.tls.certResolver" = "letsEncrypt";
      "traefik.port" = "5055";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=overseerr"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-overseerr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."portainer" = {
    image = "portainer/portainer-ce";
    volumes = [
      "/data/portainer:/data:rw"
      "/etc/localtime:/etc/localtime:ro"
      "/etc/timezone:/etc/timezone:ro"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    ports = [
      "9000:9000/tcp"
    ];
    cmd = [ "-H" "unix:///var/run/docker.sock" ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.portainer.entryPoints" = "websecure";
      "traefik.http.routers.portainer.rule" = "Host(`portainer.domain.name`)";
      "traefik.http.routers.portainer.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.portainer.loadbalancer.server.port" = "9000";
      "traefik.port" = "9000";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=portainer"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-portainer" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "ghcr.io/linuxserver/prowlarr:develop";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/paris";
    };
    volumes = [
      "/home/simon/compose-test/prowlarr/data:/config:rw"
    ];
    ports = [
      "9696:9696/tcp"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.prowlarr.entryPoints" = "websecure";
      "traefik.http.routers.prowlarr.rule" = "Host(`prowlarr.domain.name`)";
      "traefik.http.routers.prowlarr.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=prowlarr"
      "--network=38c3-compose_default"
    ];
  };
  systemd.services."podman-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-38c3-compose_default.service"
    ];
    requires = [
      "podman-network-38c3-compose_default.service"
    ];
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."radarr" = {
    image = "linuxserver/radarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/paris";
    };
    volumes = [
      "/home/simon/compose-test/radarr/data:/config:rw"
      "/mounted:/video:rw"
    ];
    ports = [
      "7676:7878/tcp"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.radarr.entryPoints" = "websecure";
      "traefik.http.routers.radarr.rule" = "Host(`radarr.domain.name`)";
      "traefik.http.routers.radarr.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.radarr.loadbalancer.server.port" = "7878";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=radarr"
      "--network=38c3-compose_default"
    ];
  };
  systemd.services."podman-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-38c3-compose_default.service"
    ];
    requires = [
      "podman-network-38c3-compose_default.service"
    ];
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."readarr" = {
    image = "ghcr.io/linuxserver/readarr:nightly";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/paris";
    };
    volumes = [
      "/home/simon/compose-test/readarr/data:/config:rw"
      "/mounted:/books:rw"
    ];
    ports = [
      "8788:8787/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.readarr.entryPoints" = "websecure";
      "traefik.http.routers.readarr.rule" = "Host(`readarr.domain.name`)";
      "traefik.http.routers.readarr.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.readarr.loadbalancer.server.port" = "8787";
      "traefik.port" = "8787";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=readarr"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-readarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."sonarr" = {
    image = "ghcr.io/linuxserver/sonarr:latest";
    environment = {
      "DOCKER_MODS" = "ghcr.io/gilbn/theme.park:sonarr";
      "PGID" = "1000";
      "PUID" = "1000";
      "TP_THEME" = "organizr";
      "TZ" = "Europe/paris";
    };
    volumes = [
      "/home/simon/compose-test/sonarr/data:/config:rw"
      "/mounted:/video:rw"
    ];
    ports = [
      "7878:7878/tcp"
      "8989:8989/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.sonarr.entryPoints" = "websecure";
      "traefik.http.routers.sonarr.rule" = "Host(`sonarr.domain.name`)";
      "traefik.http.routers.sonarr.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.sonarr.loadbalancer.server.port" = "8989";
      "traefik.port" = "8989";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=sonarr"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."traefik" = {
    image = "traefik:v2.5.1";
    volumes = [
      "/home/simon/compose-test/traefik/logs:/var/log:rw"
      "/home/simon/compose-test/traefik/routes:/etc/traefik/routes:ro"
      "/home/simon/compose-test/traefik/traefik.yml:/etc/traefik/traefik.yml:ro"
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    ports = [
      "80:80/tcp"
      "443:443/tcp"
      "8080:8080/tcp"
    ];
    labels = {
      "traefik.constraint-label" = "traefik-public";
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=traefik"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-traefik" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."uptime-kuma" = {
    image = "louislam/uptime-kuma";
    volumes = [
      "/home/simon/compose-test/uptime-kuma:/app/data:rw"
    ];
    ports = [
      "3001:3001/tcp"
    ];
    labels = {
      "traefik.docker.network" = "traefik-public";
      "traefik.enable" = "true";
      "traefik.http.routers.uptime_kuma.entryPoints" = "websecure";
      "traefik.http.routers.uptime_kuma.rule" = "Host(`status.domain.name`)";
      "traefik.http.routers.uptime_kuma.tls.certResolver" = "letsEncrypt";
      "traefik.http.services.uptime_kuma.loadbalancer.server.port" = "3001";
      "traefik.port" = "3001";
    };
    dependsOn = [
      "traefik"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=uptime-kuma"
      "--network=traefik-public"
    ];
  };
  systemd.services."podman-uptime-kuma" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    partOf = [
      "podman-compose-38c3-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-38c3-compose-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-38c3-compose_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f 38c3-compose_default";
    };
    script = ''
      podman network inspect 38c3-compose_default || podman network create 38c3-compose_default
    '';
    partOf = [ "podman-compose-38c3-compose-root.target" ];
    wantedBy = [ "podman-compose-38c3-compose-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-38c3-compose-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
