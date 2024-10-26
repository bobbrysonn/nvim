return {
  "Wansmer/treesj",
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  keys = {
    { "<leader>m", "<CMD>TSJToggle<CR>", desc = "Toggle Treesitter Join" },
  },
  opts = { use_default_keymaps = false }
}
