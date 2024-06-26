require("tokyonight").setup({
    style = "storm",     -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    transparent = true,  -- Enable this to disable setting the background color
    transparent_sidebar = true,
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
    },
    sidebars = { "qf", "help" },    -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3,           -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false,           -- dims inactive windows
    lualine_bold = false,           -- When `true`, section headers in the lualine theme will be bold
    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,
})
require('lualine').setup({
    options = {
        theme = 'tokyonight',
    }
})
vim.cmd 'colorscheme tokyonight'

vim.cmd 'hi LineNr guifg=#9aa5ce'
vim.cmd 'hi CursorLineNr guifg=#ff9e64'
vim.cmd 'hi Folded guibg=none'
