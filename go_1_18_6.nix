{ pkgs, stdenv, lib, fetchurl, autoPatchelfHook }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "05ef7855970fd9caf4e8d34fe73146cffcff740b80d00189d129302f13d22e6b";
    darwin-arm64 = "bbe22ae2f9d284b0decd67baf82a8ec840f31ca312915af1afba8adfa764e23c";
    linux-386 = "52a8ec92dc1c192fbbfc3c9583ded388edf14ee8b687b034e3c1034024bf2970";
    linux-amd64 = "bb05f179a773fed60c6a454a24141aaa7e71edfd0f2d465ad610a3b8f1dc7fe8";
    linux-arm64 = "838ffa94158125f16e4aa667ee4f6b499ea57e3e35a7e2517ad357ea06714691";
    linux-armv6l = "fca2a46dfdab541f63afaa04029c0d75e934e05464bf8c4f636c9d9856dfdaf2";
    linux-ppc64le = "bcec49f08bb67ae2821ece8fecbc2ba678d54ce6f8cfaa572b86448aa09ca816";
    linux-s390x = "661af75e03cb8effcf90705dc0a12875efdb653ad8a0ca434905ef665189350a";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.18.6";

  toGoPlatform = platform: "${toGoKernel platform}-${toGoCPU platform}";

  platform = toGoPlatform stdenv.hostPlatform;
in
stdenv.mkDerivation {
  pname = "go";
  version = version;
  src = fetchurl {
    url = "https://golang.org/dl/go${version}.${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "Missing Go bootstrap hash for platform ${platform}");
  };
  nativeBuildInputs = if pkgs.stdenv.isLinux
    then [ autoPatchelfHook ]
    else [];
  installPhase = ./go-install.sh;
  system = builtins.currentSystem;
}
