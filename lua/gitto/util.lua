local gitto_util = {}

-- Splits a string into a lines
-- @arg {string} text
-- @return {table}
function gitto_util.split_lines(text)
    local lines = {""}
    for i = 1,#text do
        local character = string.sub(text, i, i)
        if character ~= "\n" then
            lines[#lines] = lines[#lines] .. character
        else
            table.insert(lines, "")
        end
    end
    return lines
end

function gitto_util.get_unstaged()
    local unstaged_files = vim.fn.system({"git", "status", "-s"}).stdout
    local lines = gitto_util.split_lines(unstaged_files)
    local output = {}
    for _, line in pairs(lines) do
        if line ~= "" then
            if line:sub(1,1) ~= "M" then
                line = line:sub(4)
                table.insert(output, line)
            end
        end
    end
    return output
end

return gitto_util
