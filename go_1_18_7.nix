{ pkgs, stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "048cd3dab42d9923ec1d81752859ada96c6f69ac4c644ef00a590a6de0473bca";
    darwin-arm64 = "0b00b5f658ef066941d9b996ab0aa4d2d1072617886e99fb6334e68c54f243db";
    linux-386 = "34d14312a599fc8f8956ad93a6f0545e28e31ba4e67845961b818228677d3e9a";
    linux-amd64 = "6c967efc22152ce3124fc35cdf50fc686870120c5fd2107234d05d450a6105d8";
    linux-arm64 = "dceea023a9f87dc7c3bf638874e34ff1b42b76e3f1e489510a0c5ffde0cad438";
    linux-armv6l = "2238c2a4fef887f14ecf37d4c4cd5e1da7c392f4faca3c029a972acf1343bd5e";
    linux-ppc64le = "57aa7293bf085fbf5eb50e162fa1d9314a53f025961992744051f14289d65870";
    linux-s390x = "e03938284758d59cd32251760631a4ecfecc24a91a97cdc4e682c804770739fe";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.18.7";

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
