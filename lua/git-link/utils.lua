local M = {}

-- Returns current woring branch
---@return string? branch name if exists
function M.current_branch()
    local result = io.popen "git rev-parse --abbrev-ref HEAD"
    if not result then
        return nil
    end

    return result:read()
end

-- Resolves first remote using git remote.
---@return string?
function M.get_first_remote()
    local result_handle = io.popen "git remote"
    if result_handle == nil then
        return nil
    end

    local lines_iterator = result_handle:lines()
    local first_remote = lines_iterator()

    return first_remote
end

-- Resolves remote url using git.
---@param remote string? name of the remote to fetch url for.
---@return string? url of the remote server.
function M.get_remote_url(remote)
    remote = remote or M.get_first_remote()
    if remote == nil then
        return nil
    end

    local result_handle = io.popen("git remote get-url " .. remote)
    if result_handle == nil then
        return nil
    end

    return result_handle:read()
end

-- Check if str starts with prefix.
---@param str string string to have prefix.
---@param prefix string? prefix itself.
---@param plain boolean? default is false
---@return boolean
function M.string_has_prefix(str, prefix, plain)
    if plain == nil then
        plain = false
    end
    if prefix == nil then
        return false
    end

    local index = string.find(str, prefix, 1, plain)

    return index == 1
end

-- Check if str ends with prefix.
---@param str string
---@param suffix string?
---@param plain boolean? default is false
---@return boolean
function M.string_has_suffix(str, suffix, plain)
    if suffix == nil then
        return false
    end

    return M.string_has_prefix(
        string.reverse(str),
        string.reverse(suffix),
        plain
    )
end

-- Strips prefix if present.
-- Works on plain strings.
---@param target string
---@param prefix string
---@return string
function M.string_strip_prefix(target, prefix)
    if not M.string_has_prefix(target, prefix, true) then
        return target
    end

    return string.sub(target, #prefix + 1, #target)
end

-- Strips tail if present.
-- Works on plain strings.
---@param target string
---@param tail string
---@return string
function M.string_strip_suffix(target, tail)
    if not M.string_has_suffix(target, tail, true) then
        return target
    end

    return string.sub(target, 1, #target - #tail)
end

---Splits string using separator.
---@param target string to split
---@param separator string
---@return string[]
function M.string_split(target, separator)
    return vim.split(target, separator, { plain = true, trimempty = true })
end

-- Converts URL to link.
---@param url string? url to convert to link.
---@return string? url of the remote server.
function M.url_to_link(url)
    if not url then
        return nil
    end

    if M.string_has_prefix(url, "http") then
        return M.string_strip_suffix(url, ".git")
    end

    if M.string_has_prefix(url, "git@") then
        local ssh_url = url
        ssh_url = M.string_strip_suffix(ssh_url, ".git")
        ssh_url = M.string_strip_prefix(ssh_url, "git@")

        local split = M.string_split(ssh_url, ":")
        local server, repo = split[1], split[2]
        local server_url = "https://" .. server .. "/"
        return server_url .. repo
    end
end

-- Resolves link to current working file at remote location
---@param link string full link to the repository: `https://github.com/IlyasYOY/python-streamer`
---@param branch string
---@param filepath string
---@return string
function M.resolve_link_to_current_working_file(link, branch, filepath)
    return link .. "/blob/" .. branch .. "/" .. filepath
end

-- Resolves link to current working file at remote location
---@param link string full link to the repository: `https://github.com/IlyasYOY/python-streamer`
---@param branch string
---@param filepath string
---@param line number
---@return string
function M.resolve_link_to_current_line(link, branch, filepath, line)
    return M.resolve_link_to_current_working_file(link, branch, filepath)
        .. "#L"
        .. line
end

---returns repository url
---@return string?
function M.resolve_repo_url()
    local first_remote = M.get_first_remote()
    if not first_remote then
        vim.notify "Unable to find remote url"
        return nil
    end

    local url = M.get_remote_url(first_remote)
    if url == nil then
        vim.notify "Unable to find remote url"
        return nil
    end

    local link = M.url_to_link(url)
    if link == nil then
        vim.notify("Unable to parse " .. url .. " to link")
        return nil
    end

    return link
end

return M
