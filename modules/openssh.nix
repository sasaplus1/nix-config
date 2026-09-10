{ ... }:

{
  # PasswordAuthentication は既定の true のままにする
  # 鍵が通らなくても締め出されない
  # PermitRootLogin の既定は prohibit-password で、root は
  # そもそもパスワードを持たないため設定は足さない
  services.openssh.enable = true;

  # 公開鍵なのでリポジトリで管理してよい
  # https://github.com/sasaplus1.keys と同じもの
  users.users.sasaplus1.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILsSOhejrkaEKhWTCPGL7lYecL6IjX8WxfjofEkkbdZZ"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfkfMCfdAYeitBeuq7/3u6k68EPio4TP8pPM5Iucqu4"
  ];
}
