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

return gitto_util
