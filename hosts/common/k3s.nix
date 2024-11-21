{ config, pkgs, ... }:

{
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--disable servicelb"
    "--disable traefik"
    "--write-kubeconfig-mode 644"
  ];
  sops.secrets.githubToken = {
    file = ./secrets/secrets.yaml; # Path to your SOPS-encrypted secrets.yaml
    key = "github_token"; # YAML key containing the GitHub token
    exportAs = "GITHUB_TOKEN"; # Export the decrypted secret as an environment variable
  };
  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
  environment.systemPackages = with pkgs; [
    k3s
    kubectl
    fluxcd
    sops
  ];

  systemd.services.flux-bootstrap = {
    description = "Bootstrap FluxCD if not already bootstrapped";
    after = [
      "network.target"
      "k3s.service"
    ]; # Ensure K3s is running first
    wantedBy = [ "multi-user.target" ];

    # Use GITHUB_TOKEN to bootstrap Flux with the GitHub repo
    serviceConfig = {
      Environment = "GITHUB_TOKEN=${config.sops.secrets.githubToken.path}";
      ExecStart = "${pkgs.bash}/bin/bash -c 'kubectl get ns flux-system || flux check || flux bootstrap github --owner=dragonhunter274 --repository=nix-ops --branch=main --path=./cluster --personal --token=${GITHUB_TOKEN}'";
      Restart = "on-failure"; # Retry on failure
    };
  };
}
