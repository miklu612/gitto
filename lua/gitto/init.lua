local gitto = {
    status = require("gitto.status").status,
    diff   = require("gitto.diff").diff,
    sign   = require("gitto.sign")
}

local function gitto_command(args)
    if args.fargs[1] == "stage" then
        local files = vim.deepcopy(args.fargs)
        table.remove(files, 1)

        for _, file in pairs(files) do
            vim.system({"git", "stage", file}):wait()
        end

        vim.print(args)
    end
end


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

    vim.api.nvim_create_user_command("Gitto", gitto_command, {
        nargs = "+"
    })

    gitto.sign.setup()
end

return gitto
