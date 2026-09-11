# ghtkn is not packaged in nixpkgs, so the official release binary is
# installed here.
#
# It is the first tool a fresh machine needs: it mints the GitHub App user
# access token that everything else is fetched with. Pulling it from the same
# declarative pipeline as every other package removes the need to curl a binary
# before any token exists.
{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  # renovate: datasource=github-releases depName=suzuki-shunsuke/ghtkn
  #
  # NOTE: renovate bumps this version but cannot update the hashes below.
  # After a bump they go stale and the build fails. The upstream release ships
  # ghtkn_checksums.txt with the sha256 of every asset, so convert the relevant
  # lines with `nix hash to-sri --type sha256 <hex>`.
  version = "0.4.0";

  assets = {
    aarch64-darwin = {
      suffix = "darwin_arm64";
      hash = "sha256-tSq6R9nHd+HusgXtS0PSguvgcqdvM+vR5cZpAYffOvc=";
    };
    x86_64-darwin = {
      suffix = "darwin_amd64";
      hash = "sha256-RHB+pC7vvMv02CYJ/RuYKdi/lYMqMQpPX4Tn/uGs/Ck=";
    };
    x86_64-linux = {
      suffix = "linux_amd64";
      hash = "sha256-Lbzc0NQJZv2hNSKyPGUiuMZoLw5xkwExln4PXXDxJSY=";
    };
    aarch64-linux = {
      suffix = "linux_arm64";
      hash = "sha256-M6Dh+RU1/AqQDdwI4sGCsd69VlYSQVPECMLJapr8Qjg=";
    };
  };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ghtkn";
  inherit version;

  src =
    let
      asset =
        assets.${stdenvNoCC.hostPlatform.system}
          or (throw "ghtkn: unsupported system ${stdenvNoCC.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/suzuki-shunsuke/ghtkn/releases/download/v${finalAttrs.version}/ghtkn_${asset.suffix}.tar.gz";
      inherit (asset) hash;
    };

  # The archive has no top-level directory.
  sourceRoot = ".";

  # Upstream builds every release binary with CGO_ENABLED=0 (see
  # .goreleaser.yml), so it is statically linked and needs no patching.
  installPhase = ''
    runHook preInstall
    install -Dm755 ghtkn $out/bin/ghtkn
    runHook postInstall
  '';

  meta = {
    description = "CLI to create short-lived GitHub App user access tokens for secure local development";
    homepage = "https://github.com/suzuki-shunsuke/ghtkn";
    license = lib.licenses.mit;
    mainProgram = "ghtkn";
    platforms = lib.attrNames assets;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
