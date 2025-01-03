local utils = require "git-link.utils"

local M = {}

-- Saves string to + buffer
---@param string string
function M.save_to_exchange_buffer(string)
    vim.fn.setreg("+", string)
end

---Returns path to current file
---@return string
function M.current_working_file()
    return vim.fn.expand "%:."
end

local function finalize_link(link)
    vim.ui.select({ "http", "https" }, {
        prompt = "Protocol for resolved link",
        format_item = function(item)
            return "Use " .. item .. " protocol."
        end,
    }, function(choice)
        if choice == "http" then
            link = string.gsub(link, "^https", "http")
        end
        vim.notify("\nLink copied: " .. link)
        M.save_to_exchange_buffer(link)
    end)
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

    local current_file = M.current_working_file()
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

    local current_file = M.current_working_file()
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
