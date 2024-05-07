local g = vim.g
local opt = vim.opt

g.encoding = "UTF-8"
opt.fileencoding = "utf-8"

-- Smarter scrolloff with percentage
vim.api.nvim_create_autocmd({"VimEnter","VimResized"}, { callback = function ()
  opt.scrolloff = math.floor((vim.fn.winheight(0) - 1) / 6)
  opt.sidescrolloff = math.floor((vim.fn.winheight(0) - 1) / 6)
end})

opt.guicursor = ""
opt.number = true
opt.relativenumber = true

opt.cursorline = true

opt.signcolumn = "yes"

opt.colorcolumn = "80"

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true
opt.expandtab = true

opt.shiftwidth = 4

opt.autoindent = true
opt.smartindent = true

-- Case insensitive searching when no upper case character is present
opt.ignorecase = true
opt.smartcase = true

-- Disable the ugly highlight during searches
opt.hlsearch = false

-- Search when typing
opt.incsearch = true

opt.cmdheight = 2

-- Auto load the file when modified externally
opt.autoread = true

opt.wrap = false

-- Use left / right arrow to move to the previous / next line when at the start
-- or end of a line.
-- See doc (:help 'whichwrap')
opt.whichwrap = "<,>,[,]"

-- Allow hiding modified buffer
opt.hidden = true

-- Add mouse support for all modes
opt.mouse = "a"

opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Smaller updatetime
opt.updatetime = 300

-- Time to wait for a sequence of key combination
opt.timeoutlen = 500

-- Split window from below and right
opt.splitbelow = true
opt.splitright = true

opt.termguicolors = true

-- Avoid "hit-enter" prompts
-- Don't pass messages to |ins-completin menu|
opt.shortmess = vim.o.shortmess .. "c"

-- Maximum of 16 lines of prompt
opt.pumheight = 16

-- Always show tab line
opt.showtabline = 2

opt.showmode = false

opt.nrformats = "bin,hex,alpha"

if require("core.utils").is_windows() then
    opt.shellslash = true
end

vim.cmd [[
    autocmd TermOpen * setlocal nonumber norelativenumber
]]

opt.shadafile = "NONE"
vim.api.nvim_create_autocmd("CmdlineEnter", {
    once = true,
    callback = function()
        local shada = vim.fn.stdpath("state") .. "/shada/main.shada"
        vim.o.shadafile = shada
        vim.api.nvim_command("rshada! " .. shada)
    end,
})
