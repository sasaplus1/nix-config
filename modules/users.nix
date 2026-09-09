{ ... }:

{
  # hashedPasswordFile を activation ごとに読み直させる
  # true だとアカウント作成時にしか読まれず、置き忘れると復旧できない
  # root は宣言しないため ! になる。sudo で代用する
  users.mutableUsers = false;

  users.users.sasaplus1 = {
    isNormalUser = true;

    # sudo を使うために必要
    extraGroups = [ "wheel" ];

    # mkpasswd の出力を1行だけ書いたファイルを root:root 600 で置く
    # nix store に載らないのでリポジトリでは管理しない
    hashedPasswordFile = "/etc/passwords/sasaplus1";
  };
}
