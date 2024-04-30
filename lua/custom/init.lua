-- disable transparency
Ice.plugins["nvim-transparent"].enabled = false

-- hide column hints
vim.opt.colorcolumn = ""

-- limit to 1 line
vim.opt.cmdheight = 1

Ice.lsp.ensure_installed = {
    "clangd",
    "css-lsp",
    "emmet-ls",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "black",
    "typescript-language-server",
    "autopep8",
    "fixjson",
    "prettier",
    "shfmt",
    "stylua",
}

Ice.lsp.servers = {
    "clangd",
    "cssls",
    "emmet_ls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "tsserver",
}

-- Custom plugin: suda.vim for root/admin read and write.
Ice.plugins.suda = {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
}

-- ignore catkin/colcon files
Ice.plugins.telescope.opts = {
    defaults = {
        file_ignore_patterns = {
            "build",
            "install",
            "devel",
            "log",
        },
    },
}

Ice.plugins.lualine.opts = {
    options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(str)
                    return str:sub(1, 1)
                end,
            },
        },
    },
}

Ice.plugins["nvim-treesitter"].opts = {
    ensure_installed = {
        "bibtex",
        "c",
        "c_sharp",
        "cmake",
        "cpp",
        "css",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "perl",
        "php",
        "python",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
    },
}

-- Enhanced terminal operation settings.
Ice.keymap.prefix["<leader>s"] = { name = "terminal" }
if require("core.utils").is_windows() then
    Ice.keymap.general.open_cmd = { "n", "<leader>sc", "<Cmd>split term://cmd<CR>" }
    Ice.keymap.general.open_powershell = { "n", "<leader>sp", "<Cmd>split term://pwsh<CR>" }
    -- TODO a way to launch vs devshell?
else
    Ice.keymap.general.open_bash = { "n", "<leader>ss", "<Cmd>split term://bash<CR>" }
    Ice.keymap.general.open_zsh = { "n", "<leader>sz", "<Cmd>split term://zsh<CR>" }
    -- Ice.keymap.general.open_fish = { "n", "<leader>sf", "<Cmd>split term://fish<CR>" }
end
Ice.keymap.general.open_lazygit = { "n", "<leader>gl", "<Cmd>split term://lazygit<CR>" }

-- auto insert mode in terminal buffer.
local term_operations = vim.api.nvim_create_augroup("TermOperations", { clear = true })
vim.api.nvim_create_autocmd(
    { "TermOpen", "WinEnter" },
    { pattern = "term://*", group = term_operations, command = "startinsert" }
)
vim.api.nvim_create_autocmd({ "BufLeave" }, { pattern = "term://*", group = term_operations, command = "stopinsert" })

-- auto close terminal buffer after program exits.
vim.api.nvim_create_autocmd("TermClose", {
    group = term_operations,
    callback = function()
        vim.cmd "close"
    end,
})
