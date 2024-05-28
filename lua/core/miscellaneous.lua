local utils = require "core.utils"

local config_path = string.gsub(vim.fn.stdpath "config", "\\", "/")

-- Yanking on windows / wsl
-- makes WSL clip broken, commented out.
-- local clip_path = config_path .. "/bin/uclip.exe"
-- if not require("core.utils").file_exists(clip_path) then
--     local root
--     if utils.is_windows() then
--         root = "C:"
--     else
--         root = "/mnt/c"
--     end
--     clip_path = root .. "/Windows/System32/clip.exe"
-- end
--
-- if utils.is_windows() or utils.is_wsl() then
--     vim.cmd(string.format(
--         [[
--         augroup fix_yank
--             autocmd!
--             autocmd TextYankPost * if v:event.operator ==# 'y' | call system('%s', @0) | endif
--         augroup END
--         ]],
--         clip_path
--     ))
-- elseif utils.is_linux() then
--     vim.cmd "set clipboard+=unnamedplus"
-- end

-- IME switching on windows / wsl
if utils.is_windows() or utils.is_wsl() then
    local im_select_path = config_path .. "/bin/im-select-mspy.exe"

    if require("core.utils").file_exists(im_select_path) then
        local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoGroup", { clear = true })

        local function autocmd(event, code)
            vim.api.nvim_create_autocmd(event, {
                group = ime_autogroup,
                callback = function()
                    vim.cmd(":silent :!" .. im_select_path .. " " .. code)
                end,
            })
        end

        -- autocmd("VimEnter", "英语模式")
        autocmd("InsertLeave", "英语模式")
        -- autocmd("InsertEnter", "中文模式")
        autocmd("VimLeavePre", "英语模式")
    end
elseif utils.is_linux() then
    vim.cmd [[
        let fcitx5state=system("fcitx5-remote")
        autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c
        autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif
    ]]
end

-- Automatic switch to root directory
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("AutoChdir", { clear = true }),
    callback = function()
        if not (Ice.auto_chdir or Ice.auto_chdir == nil) then
            return
        end

        local default_exclude_filetype = { "NvimTree", "help" }
        local default_exclude_buftype = { "terminal", "nofile" }

        local exclude_filetype = Ice.chdir_exclude_filetype
        if exclude_filetype == nil or type(exclude_filetype) ~= "table" then
            exclude_filetype = default_exclude_filetype
        end

        local exclude_buftype = Ice.chdir_exclude_buftype
        if exclude_buftype == nil or type(exclude_buftype) ~= "table" then
            exclude_buftype = default_exclude_buftype
        end

        if table.find(exclude_filetype, vim.bo.filetype) or table.find(exclude_buftype, vim.bo.buftype) then
            return
        end

        vim.api.nvim_set_current_dir(require("core.utils").get_root())
    end,
})
