return {
  -- Catppuccin
  {
    "catppuccin/nvim",
    config = function()
      vim.cmd("colorscheme catppuccin")
    end,
    lazy = false,
    name = "catppuccin",
    priority = 1000,
  },

  -- Lsp
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- For advertising to lsps
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          local opts = { buffer = args.buf }

          -- Code action
          if client.supports_method("textDocument/codeAction") then
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          end

          -- Formatt
          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
          end

          -- Hover
          if client.supports_method("textDocument/hover") then
            vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
          end
        end,
      })

      -- Bash
      lspconfig.bashls.setup({ capabilities = capabilities })

      -- Clang
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      -- Typescript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = "palenight",
      sections = {
        lualine_x = { "os.date('%H:%M %p')", "filetype" },
        lualine_y = {},
      },
    },
  },

  -- Neo-Tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "3rd/image.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree filesystem toggle float<cr>", desc = "Neotree toggle" },
    },
    lazy = false,
    opts = {
      filesystem = {
        cwd_target = "window",
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behaviour = "open_default",
        position = "float",
      },
    },
  },

  -- None-Ls
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.refactoring, -- Several languages
          null_ls.builtins.diagnostics.pylint,       -- Python
          null_ls.builtins.formatting.black,         -- Python
          null_ls.builtins.formatting.prettier,      -- Prettier
          null_ls.builtins.formatting.stylua,        -- Lua
        },
      })
    end,
  },

  -- Telescope UI Select
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local builtin = require("telescope.builtin")
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({ winblend = 10 }),
          },
        },

        -- Customize UI
        pickers = {
          find_files = {},
        },
      })

      telescope.load_extension("ui-select")

      -- Set keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    tag = "0.1.8",
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      ensure_installed = {
        "lua",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
}
