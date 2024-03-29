vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.tex",
  command = "silent !zathura %:r.pdf &",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tex",
  command = "!xelatex %",
})
vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*.tex",
  command = "silent !latexmk -c",
})
return {
  plugins = {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.colorscheme.catppuccin", enabled = true },
    { -- further customize the options set by the community
      "catppuccin",
      opts = {
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          sandwich = false,
          noice = true,
          mini = true,
          leap = true,
          markdown = true,
          neotest = true,
          cmp = true,
          overseer = true,
          lsp_trouble = true,
          ts_rainbow2 = true,
        }
      }
    },
    { import = "astrocommunity.colorscheme.tokyonight-nvim", enabled = true },
    {
      "folke/tokyonight.nvim",
      opts = {
        style = "night",
        transparent = true
      }
    }
    -- ... import any community contributed plugins here
  },
  colorscheme = "catppuccin",
  mappings = {
    n = {
      [";"] = {":"},

      ["ا"] = {"h"},
      ["ت"] = {"j"},
      ["ن"] = {"k"},
      ["م"] = {"l"},
      ["ع"] = {"u"},

      ["كك"] = {"ZZ"},
      ["كْ" ] = {"ZQ"},
      ["یی"] = {"dd"},
      ["یت"] = {"dj"},
      ["ین"] = {"dk"},
    }
  },
  options = {
    opt = {
      termbidi = true,
      tabstop = 4,
      shiftwidth = 4,
      colorcolumn = '80'
    },
    api = {

    }
  }
}
