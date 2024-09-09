local gitto = {
    status = require("gitto.status").status,
    diff   = require("gitto.diff").diff,
    sign   = require("gitto.sign"),
    util   = require("gitto.util")
}

local function gitto_command(args)
    if args.fargs[1] == "stage" then
        local files = vim.deepcopy(args.fargs)
        table.remove(files, 1)

        for _, file in pairs(files) do
            vim.fn.system({"git", "stage", file})
        end

        vim.print(args)
    end
end

local function gitto_complete(lead, cmd, cursor)
    local arg_iter = string.gmatch(cmd, "[%w/_%d-]+")

    -- This just consumes the 'Gitto' from the cmd, so we can check what
    -- command the user wants to use. Also for fun we will just check if it is
    -- equal to "Gitto", so on the off chance that it ever changes, it will
    -- notify about it.
    if arg_iter() ~= "Gitto" then
        error("Something has gone terribly wrong")
    end

    local command = arg_iter()
    if command == "stage" then
        local unstaged_files = gitto.util.get_unstaged()
        return unstaged_files
    else
        return {
            "stage"
        }
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
        nargs = "+",
        complete = gitto_complete
    })

    gitto.sign.setup()
end

return gitto
