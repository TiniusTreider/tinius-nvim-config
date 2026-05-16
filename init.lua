-- ========================
-- lazy.nvim bootstrap
-- ========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- ========================
-- plugins
-- ========================
require("lazy").setup({
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_background = false,
				contrast = "hard",
				dim_inactive = false,
				transparent_mode = false,
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},

	{ "junegunn/fzf" },
	{ "junegunn/fzf.vim" },
	{ "ntpeters/vim-better-whitespace" },

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		opts = {
			ensure_installed = { "c", "cpp", "lua", "vim", "bash" },
			highlight = { enable = true },
			indent = { enable = true },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},

	{
		"williamboman/mason.nvim",
		config = true,
	-----
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "clangd" },
		},
	},

	-- Standard Neovim 0.11+ LSP Configuration
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Standard activation using default server settings
			vim.lsp.enable("clangd")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
})

-- ========================
-- basic settings
-- ========================
vim.o.updatetime = 100
vim.o.clipboard = "unnamedplus"

vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"

vim.o.autoread = true
vim.o.foldlevelstart = 99

vim.o.number = true
vim.o.visualbell = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "└── "

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.mouse = "a"

vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.signcolumn = "yes"

vim.o.grepprg = "rg --vimgrep"
vim.o.laststatus = 2

vim.o.expandtab = false
vim.o.autoindent = true
vim.o.cinoptions = "(0,Ws"

-- ========================
-- clipboard behavior
-- ========================
vim.keymap.set("x", "p", '"_dP')

-- ========================
-- fzf keybinds
-- ========================
vim.keymap.set("n", "<C-p>", ":fs<CR>")
vim.keymap.set("n", "<C-g>", ":rg<CR>")

-- ========================
-- Ctrl + hjkl movement in insert mode
-- ========================
vim.keymap.set("i", "<C-h>", "<C-o>h")
vim.keymap.set("i", "<C-j>", "<C-o>j")
vim.keymap.set("i", "<C-k>", "<C-o>k")
vim.keymap.set("i", "<C-l>", "<Esc>la")

-- ========================
-- Custom LSP Mappings
-- ========================
vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, { desc = "Go to References" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.hover, { desc = "Hover Documentation" })

-- ========================
-- language specific config
-- ========================
function _G.SetTab(width)
	vim.bo.tabstop = width
	vim.bo.shiftwidth = width
	vim.bo.softtabstop = width
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		SetTab(8)
		vim.opt_local.expandtab = true
		vim.opt_local.colorcolumn = "80"
		vim.opt_local.formatprg = "clang-format"
	end,
})

