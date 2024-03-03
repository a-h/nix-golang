{ pkgs, stdenv, lib, fetchurl, autoPatchelfHook }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "ebca81df938d2d1047cc992be6c6c759543cf309d401b86af38a6aed3d4090f4";
    darwin-arm64 = "bf8e388b09134164717cd52d3285a4ab3b68691b80515212da0e9f56f518fb1e";
    dragonfly-amd64 = "357ab446200effa26c73ccaf3e8551426428950bf2490859fb296a09e53228b1";
    freebsd-amd64 = "50f421c7f217083ac94aab1e09400cb9c2fea7d337679ec11f1638a11460da30";
    freebsd-386 = "b8065da37783e8b9e7086365a54d74537e832c92311b61101a66989ab2458d8e";
    freebsd-arm64 = "e23385e5c640787fa02cd58f2301ea09e162c4d99f8ca9fa6d52766f428a933d";
    freebsd-arm = "c9c8b305f90903536f4981bad9f029828c2483b3216ca1783777344fbe603f2d";
    linux-386 = "1e209c4abde069067ac9afb341c8003db6a210f8173c77777f02d3a524313da3";
    linux-amd64 = "f6c8a87aa03b92c4b0bf3d558e28ea03006eb29db78917daec5cfb6ec1046265";
    linux-arm64 = "6a63fef0e050146f275bf02a0896badfe77c11b6f05499bb647e7bd613a45a10";
    linux-armv6l = "0525f92f79df7ed5877147bce7b955f159f3962711b69faac66bc7121d36dcc4";
    linux-ppc64le = "0e57f421df9449066f00155ce98a5be93744b3d81b00ee4c2c9b511be2a31d93";
    linux-s390x = "2e546a3583ba7bd3988f8f476245698f6a93dfa9fe206a8ca8f85c1ceecb2446";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.22.0";

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
