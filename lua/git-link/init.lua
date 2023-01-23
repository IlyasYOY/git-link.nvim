local core = require "coredor"
local utils = require "git-link.utils"

vim.api.nvim_create_user_command("GitRemoteCopyRepoLink", function()
    local link = utils.resolve_repo_url()
    if not link then
        return
    end

    vim.notify("Resolved link: " .. link)
    core.save_to_exchange_buffer(link)
end, {
    desc = "Copies a link to currently working repository into the clipboard",
})

vim.api.nvim_create_user_command("GitRemoteCopyRepoLinkToFile", function()
    local repo_link = utils.resolve_repo_url()
    if not repo_link then
        return
    end

    local branch = utils.current_branch()
    if not branch then
        vim.notify "Unable to find branch"
        return
    end

    local current_file = core.current_working_file()
    local file_link = utils.resolve_link_to_current_working_file(
        repo_link,
        branch,
        current_file
    )

    vim.notify("Resolved link: " .. file_link)
    core.save_to_exchange_buffer(file_link)
end, {
    desc = "Copies a link to currently working file into the clipboard",
})

vim.api.nvim_create_user_command("GitRemoteCopyRepoLinkToLine", function()
    local repo_link = utils.resolve_repo_url()
    if not repo_link then
        return
    end

    local branch = utils.current_branch()
    if not branch then
        vim.notify "Unable to find branch"
        return
    end

    local current_file = core.current_working_file()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local line_link = utils.resolve_link_to_current_line(
        repo_link,
        branch,
        current_file,
        current_line
    )

    vim.notify("Resolved link: " .. line_link)
    core.save_to_exchange_buffer(line_link)
end, {
    desc = "Copies a link to currently working line into the clipboard",
})
