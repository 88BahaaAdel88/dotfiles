return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()   
        local builtin = require("telescope.builtin")
	local options = {}

        vim.keymap.set('n', '<C-p>', ':Telescope find_files hidden=true<CR>', options)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, options)
    end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup ({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    },
}
