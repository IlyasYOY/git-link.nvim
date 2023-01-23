local coredor = require "coredor"
local utils = require "git-link.utils"

local M = {}

---function copies a link to your origin remote repo.
function M.copy_repo_link()
    local link = utils.resolve_repo_url()
    if not link then
        return
    end

    vim.notify("Resolved link: " .. link)
    coredor.save_to_exchange_buffer(link)
end

---function copies a link to a file of your origin remote repo.
function M.copy_repo_link_to_file()
    local repo_link = utils.resolve_repo_url()
    if not repo_link then
        return
    end

    local branch = utils.current_branch()
    if not branch then
        vim.notify "Unable to find branch"
        return
    end

    local current_file = coredor.current_working_file()
    local file_link = utils.resolve_link_to_current_working_file(
        repo_link,
        branch,
        current_file
    )

    vim.notify("Resolved link: " .. file_link)
    coredor.save_to_exchange_buffer(file_link)
end

---function copies a link to a line of your origin remote repo.
function M.copy_repo_link_to_line()
    local repo_link = utils.resolve_repo_url()
    if not repo_link then
        return
    end

    local branch = utils.current_branch()
    if not branch then
        vim.notify "Unable to find branch"
        return
    end

    local current_file = coredor.current_working_file()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local line_link = utils.resolve_link_to_current_line(
        repo_link,
        branch,
        current_file,
        current_line
    )

    vim.notify("Resolved link: " .. line_link)
    coredor.save_to_exchange_buffer(line_link)
end

return M
