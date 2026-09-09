{ ... }:

{
  users.users.sasaplus1 = {
    isNormalUser = true;

    # sudo を使うために必要
    extraGroups = [ "wheel" ];

    # mkpasswd の出力を1行だけ書いたファイルを root:root 600 で置く
    # nix store に載らないのでリポジトリでは管理しない
    hashedPasswordFile = "/etc/passwords/sasaplus1";
  };
}
