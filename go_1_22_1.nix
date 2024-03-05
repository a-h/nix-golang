{ pkgs, stdenv, lib, fetchurl, autoPatchelfHook }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "3bc971772f4712fec0364f4bc3de06af22a00a12daab10b6f717fdcd13156cc0";
    darwin-arm64 = "f6a9cec6b8a002fcc9c0ee24ec04d67f430a52abc3cfd613836986bcc00d8383";
    freebsd-amd64 = "51c614ddd92ee4a9913a14c39bf80508d9cfba08561f24d2f075fd00f3cfb067";
    linux-386 = "8484df36d3d40139eaf0fe5e647b006435d826cc12f9ae72973bf7ec265e0ae4";
    linux-amd64 = "aab8e15785c997ae20f9c88422ee35d962c4562212bb0f879d052a35c8307c7f";
    linux-arm64 = "e56685a245b6a0c592fc4a55f0b7803af5b3f827aaa29feab1f40e491acf35b8";
    linux-armv6l = "8cb7a90e48c20daed39a6ac8b8a40760030ba5e93c12274c42191d868687c281";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.22.1";

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
