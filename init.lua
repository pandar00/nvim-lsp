-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	-- See: https://www.youtube.com/watch?v=UVcC5ifbXL8
	-- Required LSP config for Neovim
	-- Exec :LspInfo to find out the current LSP
  	{
		"neovim/nvim-lspconfig",
	},
	-- Mason helps installing LSPs for various languages 
	{
		"williamboman/mason.nvim",
		config = function() 
		     require("mason").setup()
		end,
	},
	-- mason-lspconfig maintains mapping between language and lsp server names
	-- e.g.) Go files -> gopls
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = ("mason.nvim"),
		config = function() 
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,

	},
	-- Telescope for nice visualization of various vim vars 
	-- Exec :Telescope
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	}
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
