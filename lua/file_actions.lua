function FormatXml()
    if vim.bo.filetype == 'xml' then
        vim.api.nvim_command('%!xmllint --format --encode utf-8 -')
        vim.api.nvim_command('%s/  /    /g')
    else
        vim.api.nvim_echo({ { "The current buffer is not an XML file", "WarningMsg" } }, true, {})
    end
end

vim.cmd('command! FXML lua FormatXml()')

--automaticly add debuger shortkey if file is rust file
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.rs",
    callback = function()
        vim.keymap.set("n", '<F5>', '<cmd>RustDebuggables<CR>')
    end,
})
--automaticly add debuger shortkey if file is python file
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.py",
    callback = function()
        vim.keymap.set("n", '<F5>', function() require('dap').continue() end)
    end,
})
--automaticly format file using ClangFormat if it's C file
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.c",
    callback = function()
        vim.api.nvim_command("ClangFormat")
    end,
})

--automaticly disable indent_blankline if .org
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.org",
    callback = function()
        vim.api.nvim_command("IndentBlanklineDisable")
    end,
})
