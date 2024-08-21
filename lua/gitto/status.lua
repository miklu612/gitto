
local gitto_status = {}

-- Parses status message into a table
-- @arg {string} message
-- @return {(modified_files:string[], untracked_files:string[])}
function parse_status_message(message)

    local status = {
        modified_files = {},
        untracked_files = {},
    }

    for line in message:gmatch("[^r\r\n]+") do
        if line:sub(1, 2) == " M" then
            table.insert(status.modified_files, line:sub(4))
        elseif line:sub(1, 2) == "??" then
            table.insert(status.untracked_files, line:sub(4))
        end
    end

    return status

end


-- Parses and returns status as a printable string.
-- @arg {string} status_str
-- @return {string}
function form_message(status_str)
    local status = parse_status_message(status_str)
    local output = ""
    for _, value in pairs(status.modified_files) do
        output = output .. "M: " .. value .. "\n"
    end
    output = output .. "\n"
    for _, value in pairs(status.untracked_files) do
        output = output .. "U: " .. value .. "\n"
    end
    return output
end

-- Gets the current git status and prints it as a notification using `vim.notify`
-- @return {void}
function gitto_status.status()
    local output = vim.system({"git","status","--short"}):wait()
    local stdout = output.stdout
    local status = form_message(stdout)
    vim.notify(status)
end

return gitto_status

