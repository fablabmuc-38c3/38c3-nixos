# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];
  disko.devices.disk.main.device = "/dev/nvme0n1";
  networking.hostName = "fablabmuc-38c3-minipc"; # Define your hostname.
}
