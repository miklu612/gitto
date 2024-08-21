local gitto = {
    status = require("gitto.status").status,
    diff   = require("gitto.diff").diff
}


function gitto.setup(opts)
    vim.api.nvim_create_user_command(
        "GittoStatus",
        gitto.status,
        {}
    )
    vim.api.nvim_create_user_command(
        "GittoDiff",
        gitto.diff,
	{}
    )
end

return gitto
