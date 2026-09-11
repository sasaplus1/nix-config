{ ... }:

{
  services.openssh.enable = true;

  users.users.sasaplus1.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3xF/76yF5V3td1/GHjUInjQ8TJ/Q4evH+l2u0w/LtJ"
  ];
}
