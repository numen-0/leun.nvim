# leun.nvim

A minimal nvim colorscheme

Inspired by and based off [film-noir](https://github.com/judah-caruso/film-noir)

## Installation
bare bones installation using `lazy.nvim`:
```lua
{
    "numen-0/leun.nvim",
    name = "leun",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
        require("leun").setup({})
    end,
}
```

example installation:
```lua
{
    "numen-0/leun.nvim",
    name = "leun",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
        local leun = require("leun")
        
        leun.setup({
            flavour = "beef",
            user_flavours = {
                beef  = { color1 = "#bada55", color2 = "#caffee" },
                magic = { color1 = "#abada0", color2 = "#cadaba" },
            },
            mark_list = {
                "beef", "lime", "beetroot", "red"
            },
        })

        -- change flav. using the mark list
        vim.keymap.set("n", "<leader><up>",   leun.prev_mark, {})
        vim.keymap.set("n", "<leader><down>", leun.next_mark, {})

        -- extra highlight for the CursorLine
        vim.cmd("autocmd InsertEnter * highlight CursorLine guibg=#181818")
        vim.cmd("autocmd InsertLeave * highlight CursorLine guibg=#121212")
    end,
}
```

## config
defaul config:

```lua
{
    flavour    = "lime",
    -- 1 - set dont have diagnostics_colors
    -- 2 - use some diagnostics_colors
    -- 3 - use all diagnostics_colors
    mode       = 2, -- default mode if not specified in the flavour.mode
    queue_size = 4, -- random flavours queue size
    -- colors
    base_colors = {
        white1 = "#bcbcbc", white2 = "#eeeeee",
        gray1  = "#585858", gray2  = "#8a8a8a",
        black1 = "#121212", black2 = "#303030",
    },
    diagnostics_colors = {
        info    = "#549fff",
        hint    = "#2ceaa3",
        warning = "#fed766",
        error   = "#fe4a49",
    },
    base16_colors = {
        white1  = "Gray",       white2  = "White",
        gray1   = "DarkGray",   gray2   = "Gray",
        black1  = "Black",      black2  = "DarkGray",
        info    = "Blue",       hint    = "Cyan",
        warning = "Yellow",     error   = "Red",
    },
    -- name = {args},
    -- {args}
    --   basic colors:
    --     color1, color2
    --   optional colors:
    --     white1, white2, gray1, gray2, black1, black2, error, warning, info, hint
    --   optional params:
    --      mode (int), base16 (bool)
    flavours = {
        green     = { color1 = "#669d33", color2 = "#9fff54", },
        rose      = { color1 = "#830457", color2 = "#ff549f", },
        blue      = { color1 = "#33669d", color2 = "#549fff", },
        red       = { color1 = "#9e1929", color2 = "#fe4a49", },
        yellow    = { color1 = "#f3d34a", color2 = "#f3e37c", },
        orange    = { color1 = "#7c3626", color2 = "#ff5714", },
        lime      = { color1 = "#28965a", color2 = "#2ceaa3", },
        purple    = { color1 = "#9040a0", color2 = "#bf7ccb", },
        indigo    = { color1 = "#423a9a", color2 = "#0f52a9", },
        white     = { color1 = "#808080", color2 = "#fefefe", },

        hotdog    = { color1 = "#fed766", color2 = "#fe4a49", },
        doghot    = { color1 = "#fe4a49", color2 = "#fed766", },
        militar   = { color1 = "#3a5a40", color2 = "#588157", },
        emerald   = { color1 = "#254441", color2 = "#43aa8b", },
        beetroot  = { color1 = "#734b5e", color2 = "#ebad98", },
        crimson   = { color1 = "#c652f9", color2 = "#d5174d", },
        cactus    = { color1 = "#31c30e", color2 = "#1f8532", },

        red16     = { color1 = "DarkRed",     color2 = "Red",     base16 = true, },
        purple16  = { color1 = "DarkMagenta", color2 = "Magenta", base16 = true, },

        -- random = {}, -- reserved flav. for .random() (dont use this name)
    },
    -- add your own flavours here (recomended). If you don't want to have the
    -- base flavours you can use the table abobe.
    -- user_flavours = {},
    -- add your favorite flavour names here
    -- mark_list = {},
}
```

## Screenshots
Font: [maple](https://github.com/subframe7536/Maple-font)

Full-setup: [.dotfiles/nvim](https://github.com/numen-0/.dotfiles/tree/main/nvim)

```lua
require("leun").load("lime")
```
![](img/lime.png)

```lua
require("leun").load("purple")
```
![](img/purple.png)

```lua
require("leun").load("hotdog")
```
![](img/hotdog.png)

```lua
require("leun").load("white")
```
![](img/white.png)

## Usage
### load scheme

```lua
require("leun").load() -- you can pass the flavour name or nil to reload
```
or
```lua
vim.cmd.colorscheme("leun")
```

### find your taste
the mapped functions are explained in [this](###other-functions) section
```lua
local leun = require("leun")

-- toggles FYT mode, remaps some keys to some usefull functions, use <esc> to
-- exit the mode. This function is mapped to the user command 'LeunFYT'.
-- mappings (normal mode):
--      <esc>   .find_your_taste()
--      r       .random()
--      R       .random(true) -- base16
--      s       .switch()
--      m       .mark()
--
--      k       .next()
--      j       .prev()
--      K       .next_mark()
--      J       .next_mark()
--      h       .rand_rolll()
--      l       .rand_rollr()
--
--      i       .print()
--      I       .get_palette()
--      M       .get_marked()
leun.find_your_taste(_)

-- [add your own]
leun.add("p1", { color1 = "red", color2 = "#012345" })
leun.add("p2", { color1 = "#777777", black1 = "#000000" })
leun.add("p3", { color1 = "blue", link = "lime" })

-- [save active flavour]
leun.add("my_flav")
...
```
After you found the one you like, you need to save the changes by, editing the
source code (not recomended), adding the table(s) to the `.setup()` inside the
`flavours` table or using `.add()` in your local config. Use `.get_palette()`
to get the line you need to add to your config for the active flavour.

### other functions
```lua
local leun = require("leun")

-- print info about palette, flavours, queues, marks and config
---@param write_rgb boolean|nil
leun.print(write_rgb)

-- load flavour
---@param flavour string|nil flavour name or nil for reload
leun.load(flavour)

-- flavour = { [link = {flav}], [color1|color2|black1|... = "..."] }
-- flavour.link = flavour for unused params
-- flavour.mode = int set the mode
--
-- All params in flavour are optional, if link is not set it will link with the
-- flavour is being used. Link "clones" the flavour to 'name' and overwrites the
-- cloned flavour with the values defined in the table. The rest of the values
-- (colors or config values) are taken from the config.
--
---@param name    string flavour name to overwrite or create a new one
---@param flavour table|nil   if nil, clone the active flav. to "name"
---@param load    boolean|nil true: load after add
leun.add(name, flavour, load)

-- remove flavour, you can't remove the active flavour
---@param flavour string
leun.remove(flavour)

-- toggle mark
---@param flavour string|nil  flavour name or nil for active flavour
---@param action  boolean|nil true: add, false: del, nil: toggle
leun.mark(flavour, action)

-- switch flavour colors
leun.switch()

-- gen a random color "#??????" or base16 color
---@param  base16 boolean?
---@return string
leun.random_color(base16)

-- gen random flavour and load it
---@param base16 boolean?
leun.random(base16)


-- iterate throgh the flavour list
leun.next()
leun.prev()

-- iterate throgh the random list (roll right & roll left)
leun.rand_rollr()
leun.rand_rolll()

-- iterate throgh the mark list
leun.next_mark()
leun.prev_mark()


-- writtes the code you need to generate for "flavour" to the buffer
---@param flavour string
---@param tab     boolean false|nil: raw table, true:  .add() call
leun.get_palette(flavour, tab)

-- writtes the code you need to generate for all marked flavours to the buffer
---@param tab boolean false|nil: raw table, true:  .add() call
leun.get_marked(tab)
```

### party trick
```
vim.on_key(leun.random, 0)
```

## Credits
This colorscheme is built with [lush.nvim](http://git.io/lush.nvim)

Inspired by and based off [film-noir](https://github.com/judah-caruso/film-noir)
