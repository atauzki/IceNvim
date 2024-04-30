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

