local gitto_sign = {
    current_index = 1,
    group_name = "gitto"
}
local gitto_util = require("gitto.util")

function gitto_sign.setup()
    vim.cmd.sign("define gitto_appended text=a texthl=DiffAdd")
    vim.api.nvim_create_autocmd("BufWritePost", {
        callback = gitto_sign.update
    })
    vim.api.nvim_create_autocmd("BufReadPost", {
        callback = gitto_sign.update
    })
end

local function place_sign_appended(line, file)
    local buffers = vim.api.nvim_list_bufs()
    local buffer_exists = false
    for _, buffer in pairs(buffers) do
        local buffer_name = vim.api.nvim_buf_get_name(buffer)
        local i = string.find(buffer_name, file, 1, true)
        if i ~= nil then
            buffer_exists = true
            break
        end
    end
    if buffer_exists == false then
        return
    end
    local cmd =
        "sign" ..
        " place " .. tostring(gitto_sign.current_index) ..
        " line=" .. tostring(line) ..
        " group=" .. gitto_sign.group_name ..
        " name=gitto_appended" ..
        " file=" .. file
    vim.cmd(cmd)
    gitto_sign.current_index = gitto_sign.current_index + 1
end

local function clear_signs()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    vim.cmd.sign("unplace * group=" .. gitto_sign.group_name .. " file=" .. buffer_name)
end

function gitto_sign.update()
    clear_signs()
    local raw_diff = vim.system({"git", "--no-pager", "diff"}):wait().stdout
    local lines = gitto_util.split_lines(raw_diff)
    local index = 1
    while index + 1 < #lines do

        local line = lines[index]
        if string.sub(line, 1, 4) ~= "diff" then
            error("Expected diff in line: " .. line)
        end

        -- Get the filename
        local full_path = string.match(line, "a/[%w/%.]*")
        local path_iter = string.gmatch(full_path, "/[%w%.]*")
        local file = ""
        for path in path_iter do
            file = file .. path
        end
        file = file.sub(file, 2)


        index = index + 1

        line = lines[index]
        if string.sub(line, 1, 5) ~= "index" then
            error("Expected index in line: " .. line)
        end
        index = index + 1

        line = lines[index]
        if string.sub(line, 1, 2) ~= "--" then
            error("Expected -- in line: " .. line)
        end
        index = index + 1

        line = lines[index]
        if string.sub(line, 1, 2) ~= "++" then
            error("Expected ++ in line: " .. line)
        end

        local getting_diffs = true
        while getting_diffs do
            index = index + 1
            line = lines[index]
            if line == nil then
                break
            end
            if string.sub(line, 1, 2) ~= "@@" then
                break
            end
            index = index + 1

            -- Get the ranges
            local start = string.gmatch(line, "%+%d+,%d+")()
            local amount = tonumber(string.sub(string.gmatch(start, ",%d+")(), 2))
            local offset = tonumber(string.gmatch(start, "%+%d+")())
            local child_index = 0

            while child_index < amount do
                line = lines[index]
                if string.sub(line, 1, 1) == "+" then
                    place_sign_appended(child_index + offset, file)
                elseif string.sub(line, 1, 1) == "-" then
                    child_index = child_index - 1
                end
                child_index = child_index + 1
                index = index + 1
            end
            index = index - 1
        end
    end
end

return gitto_sign
