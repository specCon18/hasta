{
  description = "A Template for HASTA Stack";

  inputs={
    nixpkgs.url = "nixpkgs/23.05";
  };
  
  outputs = {self, nixpkgs}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    build-tailwind = pkgs.writeShellScriptBin "build-tailwind" ''
      #!/usr/bin/env zsh
      set -e
      export PATH=${pkgs.nodejs_20}/bin:${pkgs.nodePackages_latest.pnpm}/bin:$PATH
      pnpm dlx tailwindcss -i src/styles/tailwind.css -o assets/main.css --watch
    '';

  in {
    defaultPackage.${system} = with pkgs; stdenv.mkDerivation {
      name = "HASTA Template";
      src = self;

      buildInputs = [
        openssl
        pkgconfig
        rustc
        cargo
        cargo-watch
        just
        nodejs_20
        nodePackages_latest.pnpm
      ];

      shellHook = ''
        export OPENSSL_DIR=${openssl.dev}
        export OPENSSL_LIB_DIR=${openssl.out}/lib
        export OPENSSL_INCLUDE_DIR=${openssl.dev}/include
      '';
    };
    tailwind = build-tailwind;
  };
}
