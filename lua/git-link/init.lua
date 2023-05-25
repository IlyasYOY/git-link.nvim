local coredor = require "coredor"
local utils = require "git-link.utils"

local M = {}

local function finalize_link(link)
    local should_http = vim.fn.input {
        prompt = "Resolved link: "
            .. link
            .. "\nShould we make it http? (y — yes, no otherwise)\n",
        cancelreturn = "n",
    }
    if should_http == "y" then
        link = string.gsub(link, "^https", "http")
    end

    vim.notify("\nLink copied: " .. link)
    coredor.save_to_exchange_buffer(link)
end

---function copies a link to your origin remote repo.
function M.copy_repo_link()
    local link = utils.resolve_repo_url()
    if not link then
        return
    end

    finalize_link(link)
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
    local link = utils.resolve_link_to_current_working_file(
        repo_link,
        branch,
        current_file
    )

    finalize_link(link)
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
    local link = utils.resolve_link_to_current_line(
        repo_link,
        branch,
        current_file,
        current_line
    )

    finalize_link(link)
end

return M
