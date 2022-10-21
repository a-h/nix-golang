{ pkgs, stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "b2828a2b05f0d2169afc74c11ed010775bf7cf0061822b275697b2f470495fb7";
    darwin-arm64 = "e46aecce83a9289be16ce4ba9b8478a5b89b8aa0230171d5c6adbc0c66640548";
    linux-386 = "9acc57342400c5b0c2da07b5b01b50da239dd4a7fad41a1fb56af8363ef4133f";
    linux-amd64 = "acc512fbab4f716a8f97a8b3fbaa9ddd39606a28be6c2515ef7c6c6311acffde";
    linux-arm64 = "49960821948b9c6b14041430890eccee58c76b52e2dbaafce971c3c38d43df9f";
    linux-armv6l = "efe93f5671621ee84ce5e262e1e21acbc72acefbaba360f21778abd083d4ad16";
    linux-ppc64le = "4137984aa353de9c5ec1bd8fb3cd00a0624b75eafa3d4ec13d2f3f48261dba2e";
    linux-s390x = "ca1005cc80a3dd726536b4c6ea5fef0318939351ff273eff420bd66a377c74eb";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.19.1";

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
  builder = ./go-install.sh;
  system = builtins.currentSystem;
}
