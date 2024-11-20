environment.etc."docker/traefik"

api:
  dashboard: true
  debug: true
entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"
serversTransport:
  insecureSkipVerify: true
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    filename: /config.yml
certificatesResolvers:
  cloudflare:
    acme:
      email: schurgel@gmail.com
      storage: acme.json
      dnsChallenge:
        provider: cloudflare
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
# Limiting the Logs to Specific Fields
accessLog:
  filePath: "/configdir/access.log"
  format: clf
  fields:
    defaultMode: keep
    names:
      ClientUsername: drop
    headers:
      defaultMode: keep
      names:
          User-Agent: keep
          Authorization: keep
          Content-Type: keep
