-- Set up lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

local uv = nil
if vim.uv ~= nil then
    uv = vim.uv
else
    uv = vim.loop
end

if not uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

Ice.lazy = {
    performance = {
        rtp = {
            disabled_plugins = {
                "editorconfig",
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "shada",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = {
        backdrop = 100,
    },
}
