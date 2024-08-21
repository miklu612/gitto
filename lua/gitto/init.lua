local gitto = {
    status = require("gitto.status").status,
    diff   = require("gitto.diff").diff,
    sign   = require("gitto.sign")
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
    gitto.sign.setup()
end

return gitto
