{
  description = "hollowheap's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        tinted-zed.follows = "nixpkgs";
        tinted-tmux.follows = "nixpkgs";
        tinted-kitty.follows = "nixpkgs";
        base16-fish.follows = "nixpkgs";
        base16-helix.follows = "nixpkgs";
        base16-vim.follows = "nixpkgs";
        firefox-gnome-theme.follows = "nixpkgs";
        gnome-shell.follows = "nixpkgs";
        nur.follows = "nixpkgs";
      };
    };

    # noctalia-shell = {
    #   url = "github:noctalia-dev/noctalia-shell/cachix";
    # };

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

  nixConfig = {
    # extra-substituters = [ "https://noctalia.cachix.org" ];
    # extra-trusted-public-keys = [
    #   "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    # ];
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

        overlays = [ (_: prev: import ./pkgs/default.nix prev) ];
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

      hmConfigurations =
        with inputs;
        usernames:
        nixpkgs.lib.genAttrs usernames (
          name:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = {
              inherit inputs;
              stable = import inputs.nixpkgs-stable packageConfig;
            };

            modules = [
              stylix.homeModules.stylix
              # noctalia-shell.homeModules.default
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
          pico-sdk = pkgs.pico-sdk.override { withSubmodules = true; };
          ts = pkgs.mkShell {
            name = "ts-dev";
            packages = with pkgs; [
              nodejs
              pnpm
              bun
              deno
              typescript
              typescript-language-server
              biome
            ];
          };
        in
        {
          pico = pkgs.mkShell {
            name = "pico-dev";
            packages = with pkgs; [
              cmake
              gnumake
              gcc-arm-embedded
              pico-sdk
              python3
            ];
            env = {
              PICO_SDK_PATH = "${pico-sdk}/lib/pico-sdk";
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

          python = pkgs.mkShell {
            name = "python-dev";
            packages = with pkgs; [
              python3
              uv
            ];
          };

          rust = pkgs.mkShell {
            name = "rust-dev";
            packages = with pkgs; [
              cargo
              rustc
              rustfmt
              clippy
              rust-analyzer
            ];
          };

          nix = pkgs.mkShell {
            name = "nix-dev";
            packages = with pkgs; [
              nil
              nixfmt
            ];
          };

          inherit ts;
          typescript = ts;
          js = ts;
        };
    };
}
