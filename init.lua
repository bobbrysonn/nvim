require("config.lazy")

local opt = vim.opt

-- Clipboard
opt.clipboard = "unnamedplus"

-- Editing
opt.history = 1000

-- Indentation
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.smarttab = true
opt.tabstop = 2

-- User Interface
opt.number = true
opt.relativenumber = true
opt.termguicolors = true

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true

