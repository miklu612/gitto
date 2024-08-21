# Gitto

Gitto is a simple git integration plugin. Right now this is a work-in-progress
project, so it might be buggy, the documentation is non-existent, and
performance might be bad.

## Setup with lazy.nvim

```lua
{
    "miklu612/gitto",
    config = function()
        require("gitto").setup({})
    end
}
```
