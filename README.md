# Go Nix flakes

## Usage

To run a shell with the latest Go version.

```sh
nix develop github:a-h/nix-golang
```

## Usage - specific versions

Specific versions are exported.

To run a shell with Go version 1.17.3.

```sh
nix develop github:a-h/nix-golang#v1.17.3
```

To run a shell with Go version 1.18.5.

```sh
nix develop github:a-h/nix-golang#v1.18.5
```

## Bumping version

To add a new version...

Get the Go hashes for the specific version and copy the output to your clipboard.

```sh
./print-go-hashes.sh 1.18.6
darwin-amd64 = "05ef7855970fd9caf4e8d34fe73146cffcff740b80d00189d129302f13d22e6b";
darwin-arm64 = "bbe22ae2f9d284b0decd67baf82a8ec840f31ca312915af1afba8adfa764e23c";
linux-386 = "52a8ec92dc1c192fbbfc3c9583ded388edf14ee8b687b034e3c1034024bf2970";
linux-amd64 = "bb05f179a773fed60c6a454a24141aaa7e71edfd0f2d465ad610a3b8f1dc7fe8";
linux-arm64 = "838ffa94158125f16e4aa667ee4f6b499ea57e3e35a7e2517ad357ea06714691";
linux-armv6l = "fca2a46dfdab541f63afaa04029c0d75e934e05464bf8c4f636c9d9856dfdaf2";
linux-ppc64le = "bcec49f08bb67ae2821ece8fecbc2ba678d54ce6f8cfaa572b86448aa09ca816";
linux-s390x = "661af75e03cb8effcf90705dc0a12875efdb653ad8a0ca434905ef665189350a";
```

## Development

To test locally, you can run `nix develop`.

To run a specific version, `nix develop .#go_1_17_3`.

You can test the Nix package on NixOS in Docker using `docker run`. First start a shell.

```sh
docker run -w /nix-golang -v `pwd`:/nix-golang -it --rm nixos/nix /bin/sh
```

Then you can run `nix develop` to build the flake and test it locally.

```sh
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
```

