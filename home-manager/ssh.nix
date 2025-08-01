{custom, ...}: {
  programs.ssh = {
    controlPath = "/tmp/%r@%n:%p";
    enable = true;

    extraConfig = ''
      HostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-ed25519
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-512
    '';

    extraOptionOverrides.IdentityAgent = "~/${custom.password-manager.ssh-agent}";

    matchBlocks = {
      "asus-rt-ax82u" = {
        forwardAgent = true;
        hostname = "%h.${custom.tailnet.name}";
        user = "cardoso";
      };

      "aws-eu-west-1" = {
        hostname = "%h.${custom.tailnet.name}";
        user = "ubuntu";
      };

      "raspberry-pi-5-16gb-docker" = {
        forwardAgent = true;
        hostname = "%h.${custom.tailnet.name}";
        user = custom.user.name;
      };
    };

    serverAliveInterval = 60;
  };
}
