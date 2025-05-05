{
  sops = {
    age = {
      keyFile = "/var/lib/nixos/sops-nix/sops.key";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
  };
}
