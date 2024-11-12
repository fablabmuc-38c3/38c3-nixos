{ config, pkgs, ... }:

let
  # Define paths and passphrase
  usbMountPath = "/mnt/ventoy"; # USB mount path
  ageKeyPath = "${usbMountPath}/sops-key.age"; # Path to encrypted SOPS key on USB
  decryptedKeyPath = "/home/server/.config/sops/age/"; # Temporary path for decrypted key
  agePassphrase = "IF0LcsVSkIuzGD0lY3mZi6oe1QeeYoac"; # Replace with your actual passphrase
  keyChecksumPath = "/run/sops/key-checksum"; # Path to store checksum of the decrypted key
in
{
  # Ensure the system automatically mounts the USB with label "ventoy"
  fileSystems."/mnt/ventoy" = {
    device = "LABEL=ventoy"; # Specify the device by its label
    fsType = "auto"; # Automatically detect filesystem type
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
    ];
  };

  # Define the decryption service, which depends on the USB being mounted first
  systemd.services.sops-key-decryption = {
    description = "Decrypt SOPS key from USB on first boot or when the key changes";
    wantedBy = [ "multi-user.target" ]; # Ensure this runs at startup
    after = [ "mnt-ventoy.mount" ]; # Ensure it runs after the USB is mounted

    # Decrypt the key using the hardcoded passphrase
    script = ''
      mkdir -p /run/sops

      # Check if the USB key exists
      if [ ! -f ${ageKeyPath} ]; then
        echo "Encrypted key not found at ${ageKeyPath}. Ensure USB is mounted."
        exit 1
      fi

      # Compute the checksum of the current key file on the USB drive
      currentChecksum=$(sha256sum ${ageKeyPath} | awk '{ print $1 }')

      # If the key has changed or it's the first boot, decrypt the key
      if [ ! -f ${keyChecksumPath} ] || [ "$(cat ${keyChecksumPath})" != "$currentChecksum" ]; then
        echo "Decrypting SOPS key as it is either the first boot or the key has changed..."

        # Decrypt the key using the hardcoded passphrase
        echo "${agePassphrase}" | age --decrypt -p "${ageKeyPath}" > "${decryptedKeyPath}"
        chmod 600 "${decryptedKeyPath}"

        # Store the checksum to track key changes
        echo "$currentChecksum" > "${keyChecksumPath}"

        echo "SOPS key decrypted and available at ${decryptedKeyPath}"

        # Trigger a rebuild if the key has changed
        echo "Running nixos-rebuild switch..."
        nixos-rebuild switch
      else
        echo "SOPS key has not changed. Skipping decryption and rebuild."
      fi
    '';

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true; # Keep service as "active" after execution
  };

  # Reference the decrypted key in /run for SOPS
  sops.nix.keyFile = decryptedKeyPath;

  # Define SOPS secrets as usual
  sops.secrets = {
    example-secret = {
      path = "/run/secrets/example";
      sopsFile = ./example-secret.yaml;
    };
  };

  # Include age in system packages
  environment.systemPackages = with pkgs; [ age ];
}
