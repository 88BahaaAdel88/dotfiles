return {
    "EdenEast/nightfox.nvim",
	config = function()
		vim.cmd.colorscheme("carbonfox")
	end,
    opts = {
        -- Compiled file's destination location
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = false,     -- Disable setting background
        terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false,    -- Non focused panes set to alternative background
        module_default = true,   -- Default enable value for modules
        colorblind = {
          enable = false,        -- Enable colorblind support
          simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
          severity = {
            protan = 0,          -- Severity [0,1] for protan (red)
            deutan = 0,          -- Severity [0,1] for deutan (green)
            tritan = 0,          -- Severity [0,1] for tritan (blue)
          },
        },
},
}
