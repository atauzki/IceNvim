-- disable transparency
Ice.plugins["nvim-transparent"].enabled = false

-- hide column hints
vim.opt.colorcolumn = ""

vim.opt.undofile = true

-- limit to 1 line
vim.opt.cmdheight = 1

vim.opt.mousemodel = "extend"

Ice.lsp.ensure_installed = {
    "autopep8",
    "black",
    "clangd",
    "codelldb",
    "css-lsp",
    "emmet-ls",
    "fixjson",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "prettier",
    "shfmt",
    "stylua",
    "typescript-language-server",
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
-- Ice.plugins.suda = {
--     "lambdalisue/suda.vim",
--     cmd = { "SudaRead", "SudaWrite" },
-- }

-- Debugger.
Ice.plugins.dap = {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
    },
    event = "VeryLazy",
    config = function()
        local dap = require "dap"
        dap.adapters.codelldb = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
                command = "codelldb",
                args = { "--port", "${port}" },
            },
        }
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
        dap.adapters.python = function(cb, config)
            if config.request == "attach" then
                ---@diagnostic disable-next-line: undefined-field
                local port = (config.connect or config).port
                ---@diagnostic disable-next-line: undefined-field
                local host = (config.connect or config).host or "127.0.0.1"
                cb {
                    type = "server",
                    port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                    host = host,
                    options = {
                        source_filetype = "python",
                    },
                }
            else
                cb {
                    type = "executable",
                    command = "python",
                    args = { "-m", "debugpy.adapter" },
                    options = {
                        source_filetype = "python",
                    },
                }
            end
        end
        dap.configurations.python = {
            {
                -- The first three options are required by nvim-dap
                type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = "launch",
                name = "Launch file",
                -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
                program = "${file}", -- This configuration will launch the current file if used.
                pythonPath = function()
                    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                        return cwd .. "/venv/bin/python"
                    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                        return cwd .. "/.venv/bin/python"
                    else
                        return "/usr/bin/python"
                    end
                end,
            },
        }
        require("dapui").setup()
    end,
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
        "bash",
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
        "markdown",
        "markdown_inline",
        "perl",
        "php",
        "python",
        "query",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
    },
}

-- Enhanced terminal operation settings.
Ice.keymap.prefix["<leader>s"] = { name = "terminal" }
Ice.keymap.prefix["<leader>z"] = { name = "DAP" }
if require("core.utils").is_windows() then
    Ice.keymap.general.open_cmd = { "n", "<leader>sc", "<Cmd>split term://cmd<CR>" }
    Ice.keymap.general.open_powershell = { "n", "<leader>sp", "<Cmd>split term://pwsh<CR>" }
    -- TODO a way to launch vs devshell?
else
    Ice.keymap.general.open_bash = { "n", "<leader>ss", "<Cmd>split term://bash<CR>" }
    Ice.keymap.general.open_zsh = { "n", "<leader>sz", "<Cmd>split term://zsh<CR>" }
    -- Ice.keymap.general.open_fish = { "n", "<leader>sf", "<Cmd>split term://fish<CR>" }
end
Ice.keymap.general.toggle_debugger = {
    "n",
    "<leader>zz",
    function()
        require("dapui").toggle()
    end,
}
Ice.keymap.general.toggle_breakpoint = {
    "n",
    "<leader>zb",
    function()
        require("dap").toggle_breakpoint()
    end,
}
Ice.keymap.general.continue = {
    "n",
    "<leader>zn",
    function()
        require("dap").continue()
    end,
}
Ice.keymap.general.step_into = {
    "n",
    "<leader>zi",
    function()
        require("dap").step_into()
    end,
}
Ice.keymap.general.step_over = {
    "n",
    "<leader>zo",
    function()
        require("dap").step_over()
    end,
}
Ice.keymap.general.step_out = {
    "n",
    "<leader>zO",
    function()
        require("dap").step_out()
    end,
}
Ice.keymap.general.terminate = {
    "n",
    "<leader>zt",
    function()
        require("dap").terminate()
    end,
}
Ice.keymap.general.restart = {
    "n",
    "<leader>zr",
    function()
        require("dap").restart()
    end,
}

vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#993939" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

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
