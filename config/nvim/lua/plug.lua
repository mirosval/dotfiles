local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig' -- LSP Configurations 
  use 'simrat39/rust-tools.nvim' -- Rust Support
  use {
    'williamboman/mason.nvim', -- mason is used to ensure LSPs are installed
    config = function() require("mason").setup() end
  }
  use {
    'williamboman/mason-lspconfig.nvim', -- mason lspconfig integration
    config = function() require("mason-lspconfig").setup() end
  }
  use 'hrsh7th/nvim-cmp' -- code completions
  use 'hrsh7th/cmp-nvim-lsp' -- LSP as source for code completions
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('plugs.tree_sitter_setup') end
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function() require('plugs.telescope_setup') end
  }
  use {
    'alexghergh/nvim-tmux-navigation',
    config = function() require('plugs.tmux_setup') end
  }
  use { -- colorscheme
    'folke/tokyonight.nvim',
    config = function()
      -- colorscheme
      vim.opt.background = "dark"
      vim.g.tokyonight_style = "night"
      vim.cmd[[colorscheme tokyonight]]
    end
  }
  use {
    'stevearc/aerial.nvim',
    config = function() require('plugs.aerial_setup') end
  }
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() require('plugs.todo_comments_setup') end
  }
  use "lukas-reineke/indent-blankline.nvim"
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  --use "RRethy/vim-illuminate"
  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function() require("nvim-surround").setup({}) end 
  }
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  use "justinmk/vim-sneak"
  use { 
    "johmsalas/text-case.nvim",
    config = function() require('plugs.text_case_setup') end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require('plugs.lualine_setup') end
  }
  use 'arkav/lualine-lsp-progress'
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function() require('plugs.null_ls_setup') end
  }
  use {
    'lewis6991/gitsigns.nvim',
    -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    config = function()
      require('gitsigns').setup()
    end
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
