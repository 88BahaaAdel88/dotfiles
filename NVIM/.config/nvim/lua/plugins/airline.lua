return {
  {
    "dense-analysis/ale",
  },
  {
    "vim-airline/vim-airline",
    dependencies = {
      "vim-airline/vim-airline-themes",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local devicon = require("nvim-web-devicons")

      vim.g.airline_extensions = { "ale", "branch", "vimtex" }
      vim.g.airline_theme = "onedark"
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_right_sep = ""
      vim.g.airline_left_sep = ""

      vim.g.airline_section_a = vim.fn["airline#section#create"]({ "mode", "crypt", "paste", "iminsert" })
      vim.g.airline_section_y = vim.fn["airline#section#create"]({ " " })
      vim.g.airline_section_z = vim.fn["airline#section#create"]({ "linenr", "maxlinenr", "colnr" })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
        callback = function()
          local fileNameIcon = devicon.get_icon(vim.fn.expand("%:p")) or ""
          fileNameIcon = fileNameIcon .. " " .. vim.bo.filetype
          vim.g.airline_section_x = vim.fn["airline#section#create"]({ fileNameIcon })
        end,
      })

      vim.g["airline#extensions#branch#enabled"] = 1
      vim.g["airline#extensions#ale#enabled"] = 1

      -- Note: Ensure bufferline.nvim is installed separately if you use it here
      local status_ok, bufferline = pcall(require, "bufferline")
      if status_ok then
        bufferline.setup({
          options = {},
        })
      end
    end,
  },
}
