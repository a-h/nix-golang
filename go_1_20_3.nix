{ pkgs, stdenv, lib, fetchurl, autoPatchelfHook }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "c1e1161d6d859deb576e6cfabeb40e3d042ceb1c6f444f617c3c9d76269c3565";
    darwin-arm64 = "86b0ed0f2b2df50fa8036eea875d1cf2d76cefdacf247c44639a1464b7e36b95";
    linux-386 = "e12384311403f1389d14cc1c1295bfb4e0dd5ab919403b80da429f671a223507";
    linux-amd64 = "979694c2c25c735755bf26f4f45e19e64e4811d661dd07b8c010f7a8e18adfca";
    linux-arm64 = "eb186529f13f901e7a2c4438a05c2cd90d74706aaa0a888469b2a4a617b6ee54";
    linux-armv6l = "b421e90469a83671641f81b6e20df6500f033e9523e89cbe7b7223704dd1035c";
    linux-ppc64le = "943c89aa1624ea544a022b31e3d6e16a037200e436370bdd5fd67f3fa60be282";
    linux-s390x = "126cf823a5634ef2544b866db107b9d351d3ea70d9e240b0bdcfb46f4dcae54b";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.20.3";

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
