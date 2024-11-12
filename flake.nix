{
  description = "system flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    sops-nix.url = "github:Mic92/sops-nix";
    nur.url = "github:dragonhunter274/nur-packages";
  };
  outputs =
    {
      self,
      nixpkgs,
      sops-nix,
      nur,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            sops-nix.nixosModules.sops
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ (final: prev: { nur-packages = nur.packages.${system}; }) ];
              }
            )
          ];
        };
      };
    };
}
