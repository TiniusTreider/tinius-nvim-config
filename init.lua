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

-- ========================
-- plugins
-- ========================
require("lazy").setup({
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_contrast_dark = "hard"
			vim.cmd("colorscheme gruvbox")
		end,
	},

	{
		"junegunn/fzf",
	},

	{
		"junegunn/fzf.vim",
	},

	{
		"ntpeters/vim-better-whitespace",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
		pcall(function()
			require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "cpp", "lua", "vim", "bash" },
			highlight = { enable = true },
			indent = { enable = true },
			})
		end)
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Mason: installs LSP servers automatically
	{
		"williamboman/mason.nvim",
		config = function()
		require("mason").setup()
		end,
	},

	-- Bridges mason and lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
		require("mason-lspconfig").setup({
			ensure_installed = { "clangd" },
		})
		end,
	},

	-- The actual LSP config
	{
	    "neovim/nvim-lspconfig",
	    config = function()
		vim.lsp.config('clangd', {})
		vim.lsp.enable('clangd')
	    end,
	},

	{
	    "windwp/nvim-autopairs",
	    event = "InsertEnter",
	    config = function()
		require("nvim-autopairs").setup({
		    check_ts = true,
		})
	    end,
	},
})

-- ========================
-- basic settings (legacy.vim)
-- ========================
vim.o.updatetime = 100
vim.o.hidden = true
vim.o.clipboard = "unnamedplus"

vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"

vim.o.autoread = true
vim.o.foldlevelstart = 99

vim.o.number = true
vim.o.ruler = true
vim.o.visualbell = true
vim.o.encoding = "utf-8"

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "└── "

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.mouse = "a"

vim.o.backup = false
vim.o.writebackup = false
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.signcolumn = "yes"

vim.o.grepprg = "rg --vimgrep"
vim.o.laststatus = 2

vim.o.expandtab = false
vim.o.autoindent = true
vim.o.cinoptions = "(0,W4"

vim.cmd("syntax on")

-- ========================
-- clipboard fix (don't overwrite on paste)
-- ========================
vim.keymap.set("x", "p", '"_dP')

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

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
-- indentation helper
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

-- ========================
-- trailing whitespace highlight
-- ========================
vim.cmd([[
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
]])

