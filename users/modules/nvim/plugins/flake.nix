{
  inputs = {

    nvim-dap-python-src = {
      url = "github:mfussenegger/nvim-dap-python";
      flake = false;
    };
    nvim-alpha-src = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };
    nvim-sqls-src = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };
    nvim-yuck-src = {
      url = "github:elkowar/yuck.vim";
      flake = false;
    };
    nvim-better-digraphs-src = {
      url = "github:protex/better-digraphs.nvim";
      flake = false;
    };
    nvim-nu-src = {
      url = "github:LhKipp/nvim-nu";
      flake = false;
    };
    nvim-regexplainer-src = {
      url = "github:bennypowers/nvim-regexplainer";
      flake = false;
    };
    nvim-lspsaga-src = {
      url = "github:glepnir/lspsaga.nvim";
      flake = false;
    };
  };
  outputs = inputs:
    let
      missingVimPluginsInNixpkgs = pkgs: {
        nvim-dap-python = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-dap-python";
          src = inputs.nvim-dap-python-src;
        };
        nvim-alpha = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-alpha";
          src = inputs.nvim-alpha-src;
        };
        nvim-sqls = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-sqls";
          src = inputs.nvim-sqls-src;
        };
        nvim-yuck = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-yuck";
          src = inputs.nvim-yuck-src;
        };
        nvim-better-digraphs = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-better-digraphs";
          src = inputs.nvim-better-digraphs-src;
        };
        nvim-nu = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-nu";
          src = inputs.nvim-nu-src;
        };
        nvim-regexplainer = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-regexplainer";
          src = inputs.nvim-regexplainer-src;
        };
        nvim-lspsaga = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-lspsaga";
          src = inputs.nvim-lspsaga-src;
        };
      };
    in
    {
      overlay = final: prev: {
        vimPlugins = prev.vimPlugins // (missingVimPluginsInNixpkgs prev.pkgs);
      };

    };
}