{
  description = "Home manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";

    # Nvim plugins
    nvim-lspsaga-src = {
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    nvim-dap-python-src = {
      url = "github:mfussenegger/nvim-dap-python";
      flake = false;
    };
    nvim-alpha-src = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };
    nvim-copilot-src = {
      url = "github:github/copilot.vim";
      flake = false;
    };
    nvim-cmp-copilot-src = {
      url = "github:hrsh7th/cmp-copilot";
      flake = false;
    };
  };
  outputs = { self, nur, ... }@inputs:
    let
      newPlugins = pkgs: {
        nvim-lsp-saga = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-lsp-saga";
          src = inputs.nvim-lspsaga-src;
        };
        nvim-dap-python = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-dap-python";
          src = inputs.nvim-dap-python-src;
        };
        nvim-alpha = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-alpha";
          src = inputs.nvim-alpha-src;
        };
        nvim-copilot = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-copilot";
          src = inputs.nvim-copilot-src;
        };
        nvim-cmp-copilot = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-cmp-copilot";
          src = inputs.nvim-cmp-copilot;
        };
      };

      overlays = [
        nur.overlay

        (final: prev: {
          vimPlugins = prev.vimPlugins // (newPlugins prev.pkgs);
        })

      ];
    in
    {
      homeConfigurations = {
        nixos = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/sherub";
          username = "sherub";
          configuration = { config, lib, pkgs, ... }@configInput:
            {
              # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
              _module.args = {
                colorscheme = (import ./colorschemes/dracula.nix);
              };

              nixpkgs.config = { allowUnfree = true; };
              nixpkgs.overlays = overlays;

              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;

              imports = [
                ./modules/browser.nix
                ./modules/git.nix
                ./modules/desktop-environment
                ./modules/nvim
                ./modules/cli
                ./modules/fonts.nix
                ./modules/kitty.nix
                ./modules/alacritty.nix
                ./modules/system-management
                ./modules/work.nix
              ];

              # Packages that don't fit in the modules that we have
              home.packages = with pkgs; [
                # GUI Apps
                discord
                p3x-onenote

                # Busybox replacements: As the default ones give out very
                # limited info which is extremely unhelpful when debugging
                # something
                pciutils
                usbutils
                less
                stress

                gnome3.networkmanager-openvpn
              ];
            };
        };

        macbook-pro = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-darwin";
          homeDirectory = "/Users/sherubthakur";
          username = "sherubthakur";
          configuration = { config, lib, pkgs, ... }:
            {
              # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
              _module.args = {
                colorscheme = (import ./colorschemes/dracula.nix);
              };
              xdg.configFile."nix/nix.conf".text = ''
                experimental-features = nix-command flakes ca-references
              '';
              nixpkgs.config = { allowUnfree = true; };
              nixpkgs.overlays = overlays;

              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;

              home.packages = with pkgs; [
                docker
              ];

              imports = [
                ./modules/kitty.nix
                ./modules/git.nix
                ./modules/nvim
                ./modules/cli
                ./modules/fonts.nix
                ./modules/kitty.nix
                ./modules/alacritty.nix
                ./modules/tmux.nix
                ./modules/system-management
                ./modules/work.nix
              ];
            };
        };
      };
    };
}
