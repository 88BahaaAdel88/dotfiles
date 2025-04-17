return {
    "andweeb/presence.nvim",
    -- enabled = true,

    config = function()
        require("presence").setup({
            main_image = "file",
            neovim_image_text = "I use arch btw",
            auto_update = true,
            plugin_manager_text = "Managing plugins",
            -- blacklist = {'c', 'h'}
        })
    end,
}
