{
  description = "hollowheap's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      unfreePackages = [
        "modrinth-app"
        "modrinth-app-unwrapped"
        "antigravity-cli"
        "github-copilot-cli"
        "kiro-cli"
        "kiro-cli-unwrapped"
        "crush"
        "steam"
        "steam-unwrapped"
        "zoom"
      ];

      packageConfig = {
        localSystem = "x86_64-linux";

        config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) unfreePackages;
        # config.permittedInsecurePackages = [ "electron-40.10.5" ];

        overlays = [
          (_: prev: import ./pkgs/default.nix prev)
          (final: prev: {
            typescript-language-server = prev.typescript-language-server.overrideAttrs (old: {
              pnpmDeps = final.fetchPnpmDeps {
                inherit (old) pname version src;
                pnpm = final.pnpm_12;
                fetcherVersion = 4;
                hash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
              };
            });
          })
        ];
      };

      stateVersionConfig = {
        home.stateVersion = "26.11";
      };

      homeConfig = username: {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
        };
      };

      pkgs = import inputs.nixpkgs packageConfig;

      toolchains = {
        nix = with pkgs; [
          nil
          nixfmt
        ];
        ts = with pkgs; [
          nodejs
          pnpm
          bun
          deno
          typescript
          typescript-language-server
          biome
        ];
        rust = with pkgs; [
          cargo
          rustc
          rustfmt
          clippy
          rust-analyzer
        ];
        python = with pkgs; [
          python3
          uv
          basedpyright
          ruff
        ];
        c = with pkgs; [
          clang-tools
          cmake
          gnumake
          gcc
          gdb
        ];
        pico = with pkgs; [
          cmake
          gnumake
          gcc-arm-embedded
          pico-sdk
          python3
        ];
      };

      hmConfigurations =
        with inputs;
        usernames:
        nixpkgs.lib.genAttrs usernames (
          name:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = {
              inherit inputs toolchains;
              stable = import inputs.nixpkgs-stable packageConfig;
            };

            modules = [
              zen-browser.homeModules.twilight
              nvf.homeManagerModules.default
              sops-nix.homeManagerModules.sops
              stateVersionConfig
              (homeConfig name)
              ./home.nix
            ];
          }
        );
    in
    {
      homeConfigurations = hmConfigurations [ "hollowheap" ];



      devShells.x86_64-linux =
        let
          ts = pkgs.mkShell {
            name = "ts-dev";
            packages = toolchains.ts;
          };
          c = pkgs.mkShell {
            name = "c-dev";
            packages = toolchains.c;
          };
        in
        {
          inherit ts c;
          typescript = ts;
          js = ts;
          clang = c;
          cpp = c;

          nix = pkgs.mkShell {
            name = "nix-dev";
            packages = toolchains.nix;
          };

          rust = pkgs.mkShell {
            name = "rust-dev";
            packages = toolchains.rust;
          };

          python = pkgs.mkShell {
            name = "python-dev";
            packages = toolchains.python;
          };

          pico = pkgs.mkShell {
            name = "pico-dev";
            packages = toolchains.pico;
            env = {
              PICO_SDK_PATH = "${pkgs.pico-sdk}/lib/pico-sdk";
            };
            shellHook = ''
              rm -f .clangd
              cat << EOF > .clangd
CompileFlags:
  CompilationDatabase: build
  Add:
    - -isystem
    - ${pkgs.gcc-arm-embedded}/arm-none-eabi/include
EOF
            '';
          };
        };
    };
}
