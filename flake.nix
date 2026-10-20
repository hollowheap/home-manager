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

      checks.x86_64-linux = {
        artifacts-helper-test = pkgs.runCommand "artifacts-helper-test" {
          nativeBuildInputs = [
            pkgs.artifacts-helper
            pkgs.coreutils
            pkgs.gnugrep
            pkgs.gnused
            pkgs.gawk
          ];
        } ''
          set -euo pipefail

          # Test 1: Empty workspace
          mkdir -p ws1
          export ARTIFACTS_DIR="$PWD/ws1/artifacts"

          status_out=$(artifacts.sh status)
          if [ "''${status_out}" != "CONTEXT:none DEC:0 SPEC:0 TASK:0" ]; then
            echo "FAIL: Expected 'CONTEXT:none DEC:0 SPEC:0 TASK:0', got '  ''${status_out}'" >&2
            exit 1
          fi

          dec_out=$(artifacts.sh unconverted-decs)
          if [ "''${dec_out}" != "NONE" ]; then
            echo "FAIL: Expected NONE for unconverted-decs, got '  ''${dec_out}'" >&2
            exit 1
          fi

          spec_out=$(artifacts.sh unconverted-specs)
          if [ "''${spec_out}" != "NONE" ]; then
            echo "FAIL: Expected NONE for unconverted-specs, got '  ''${spec_out}'" >&2
            exit 1
          fi

          next_out=$(artifacts.sh next-tasks)
          if [ "''${next_out}" != "NONE" ]; then
            echo "FAIL: Expected NONE for next-tasks, got '  ''${next_out}'" >&2
            exit 1
          fi

          links_out=$(artifacts.sh verify-links)
          if [ "''${links_out}" != "OK" ]; then
            echo "FAIL: Expected OK for verify-links, got '  ''${links_out}'" >&2
            exit 1
          fi

          # Test 2: Populated workspace with unconverted items and blocked vs unblocked tasks
          mkdir -p ws2/artifacts
          export ARTIFACTS_DIR="$PWD/ws2/artifacts"

          cat << 'EOF' > "$ARTIFACTS_DIR/context.md"
# Context
## Stack & Entrypoints
Nix Home Manager
## Commands
- eval: nix flake check --no-build
- build: nix build .#homeConfigurations.hollowheap.activationPackage
## Module Seams
options/ai.nix -> programs/opencode.nix
EOF

          cat << 'EOF' > "$ARTIFACTS_DIR/decisions.md"
# Decisions
- [ ] DEC-01: Use SQLite for storage | Why: embedded simplicity
- [x] DEC-02: Use OpenCode harness | Why: native skill support
## Non-Goals
- Cloud sync
EOF

          cat << 'EOF' > "$ARTIFACTS_DIR/specs.md"
# Specs
- [ ] SPEC-01 [DEC-01]: Database seam interface | Verify: nix eval
- [x] SPEC-02 [DEC-02]: Harness permission rules | Verify: nix flake check
EOF

          cat << 'EOF' > "$ARTIFACTS_DIR/plan.md"
# Plan
- [x] TASK-01 [SPEC-01] (blocked-by: none): Setup DB schema | Verify: check-db
- [ ] TASK-02 [SPEC-01] (blocked-by: TASK-01): Query helpers | Verify: check-query
- [ ] TASK-03 [SPEC-02] (blocked-by: TASK-02): Wire harness | Verify: check-harness
EOF

          status_out2=$(artifacts.sh status)
          if [ "''${status_out2}" != "CONTEXT:present DEC:1 SPEC:1 TASK:2" ]; then
            echo "FAIL: Expected 'CONTEXT:present DEC:1 SPEC:1 TASK:2', got '  ''${status_out2}'" >&2
            exit 1
          fi

          dec_out2=$(artifacts.sh unconverted-decs)
          if ! echo "''${dec_out2}" | grep -q 'DEC-01' || echo "''${dec_out2}" | grep -q 'DEC-02'; then
            echo "FAIL: unconverted-decs should include only DEC-01, got: ''${dec_out2}" >&2
            exit 1
          fi

          spec_out2=$(artifacts.sh unconverted-specs)
          if ! echo "''${spec_out2}" | grep -q 'SPEC-01' || echo "''${spec_out2}" | grep -q 'SPEC-02'; then
            echo "FAIL: unconverted-specs should include only SPEC-01, got: ''${spec_out2}" >&2
            exit 1
          fi

          # Blocked vs unblocked tasks
          next_out2=$(artifacts.sh next-tasks)
          if ! echo "''${next_out2}" | grep -q '^- \[ \] TASK-02'; then
            echo "FAIL: next-tasks should have TASK-02, got: ''${next_out2}" >&2
            exit 1
          fi
          if echo "''${next_out2}" | grep -q '^- \[ \] TASK-03' || echo "''${next_out2}" | grep -q '^- \[x\] TASK-01'; then
            echo "FAIL: next-tasks contained unexpected tasks: ''${next_out2}" >&2
            exit 1
          fi

          # Scoped context TASK-02 extraction
          ctx_out=$(artifacts.sh context TASK-02)
          if ! echo "''${ctx_out}" | grep -q '## Commands' || ! echo "''${ctx_out}" | grep -q 'TASK-02' || ! echo "''${ctx_out}" | grep -q 'SPEC-01' || ! echo "''${ctx_out}" | grep -q 'DEC-01'; then
            echo "FAIL: context TASK-02 missing expected parts: ''${ctx_out}" >&2
            exit 1
          fi
          if echo "''${ctx_out}" | grep -q 'SPEC-02' || echo "''${ctx_out}" | grep -q 'DEC-02' || echo "''${ctx_out}" | grep -q '## Stack & Entrypoints'; then
            echo "FAIL: context TASK-02 leaked unreferenced sections: ''${ctx_out}" >&2
            exit 1
          fi

          # Direct DEC link in task
          echo "- [ ] TASK-04 [DEC-01] (blocked-by: TASK-03): Direct seam task | Verify: true" >> "$ARTIFACTS_DIR/plan.md"
          ctx_out4=$(artifacts.sh context TASK-04)
          if ! echo "''${ctx_out4}" | grep -q 'TASK-04' || ! echo "''${ctx_out4}" | grep -q 'DEC-01'; then
            echo "FAIL: context TASK-04 direct DEC extraction failed: ''${ctx_out4}" >&2
            exit 1
          fi
          sed -i '/TASK-04/d' "$ARTIFACTS_DIR/plan.md"

          # Valid link verification
          links_out2=$(artifacts.sh verify-links)
          if [ "''${links_out2}" != "OK" ]; then
            echo "FAIL: Expected OK for verify-links, got '  ''${links_out2}'" >&2
            exit 1
          fi

          # Test 3: Broken link detection
          echo "- [ ] SPEC-99 [DEC-99]: Broken spec | Verify: false" >> "$ARTIFACTS_DIR/specs.md"
          if artifacts.sh verify-links > /dev/null 2>&1; then
            echo "FAIL: verify-links should have failed on missing DEC-99" >&2
            exit 1
          fi

          # Fix specs and break plan with broken SPEC
          sed -i '/SPEC-99/d' "$ARTIFACTS_DIR/specs.md"
          echo "- [ ] TASK-99 [SPEC-88] (blocked-by: none): Broken task | Verify: false" >> "$ARTIFACTS_DIR/plan.md"
          if artifacts.sh verify-links > /dev/null 2>&1; then
            echo "FAIL: verify-links should have failed on missing SPEC-88" >&2
            exit 1
          fi

          # Break plan with broken direct DEC link
          sed -i '/TASK-99/d' "$ARTIFACTS_DIR/plan.md"
          echo "- [ ] TASK-98 [DEC-77] (blocked-by: none): Broken direct DEC link | Verify: false" >> "$ARTIFACTS_DIR/plan.md"
          if artifacts.sh verify-links > /dev/null 2>&1; then
            echo "FAIL: verify-links should have failed on missing DEC-77 in plan.md" >&2
            exit 1
          fi

          mkdir -p $out
          touch $out/success
        '';
      };

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
