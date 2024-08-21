local gitto_diff = {}

-- Splits the given text into its lines
-- @arg {string} text
-- @return {string[]}
function split_lines(text)
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

-- Replaces the current window's buffer with a diff page.
-- @return {void}
function gitto_diff.diff()
    local output = vim.system({"git", "--no-pager", "diff"}):wait()
    local lines = split_lines(output.stdout)
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, true, lines)
    vim.api.nvim_win_set_buf(0, buffer)
    vim.api.nvim_set_option_value("filetype", "diff", { buf = buffer })
end

return gitto_diff
