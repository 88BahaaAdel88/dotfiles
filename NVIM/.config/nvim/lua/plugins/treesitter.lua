return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    
    -- Install your preferred parsers
    ts.install({ "bash", "c", "lua", "vim", "vimdoc", "query", "python", "markdown" })

    -- Enable highlighting automatically on FileType
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
