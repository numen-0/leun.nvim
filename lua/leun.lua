-- NOTE: idea(s):
--        - light mode
--        - color gen tools
--        - change flav when event (change mode, read only, file type...)
-- NOTE: cool colors #77f595 #fda06d #fb4151
-- NOTE: maybe reserving some flav "" (empty string) to point to active flav.
--       would be a better idea when we want to access the active flav. Now we
--       use M.config.flavours[M.config.flavour], it's "ugly" -_(0_0)_-
-- NOTE: some config public stuff put it in local or gave some public set/get
--       functs.
-- NOTE: add the CursorLine highlight stuff used in the lazy.nvim example here?
-- NOTE: if user passes bad input what do we do?

local M = {}
M.__index = M
M.config  = {}

local default = {
    flavour    = "lime",
    -- 1 - set dont have diagnostics_colors
    -- 2 - use some diagnostics_colors
    -- 3 - use all diagnostics_colors
    mode       = 2, -- default mode if not specified in the flavour.mode
    queue_size = 4, -- random flavours queue size
    -- colors
    base_colors = {
        white1 = "#bcbcbc",
        white2 = "#eeeeee",
        gray1  = "#585858",
        gray2  = "#8a8a8a",
        black1 = "#121212",
        black2 = "#303030",
    },
    diagnostics_colors = {
        error   = "#fe4a49",
        warning = "#fed766",
        info    = "#549fff",
        hint    = "#2ceaa3",
    },
    -- name = {args},
    -- {args}
    --   basic colors:
    --     color1, color2
    --   optional colors:
    --     white1, white2, gray1, gray2, black1, black2, error, warning, info, hint
    --   optional params:
    --      mode (int)
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

        -- random = {}, -- reserved flav. for .random() (dont use this name)
    },
    -- add your own flavours here (recomended). If you don't want to have the
    -- base flavours you can use the table abobe.
    -- user_flavours = { beef = { color1 = "#bada55", color2 = "#caffee" }, },
    -- add your favorite flavour names here
    -- mark_list = { "red", "beetroot", },
}

local mmode = {
    monomono = 1,
    somemono = 2,
    nonemono = 3,
}

local flavour_list  = {}    -- sorted list
local indx          = 1
local mark_list     = {}    -- "sorted" list (don't mess with the ordering)
local rand_queue    = {}
local fyt_active    = false
local mappings      = {}


---@param tag  string
---@param bool boolean
local function print_tag_bool(tag, bool)
    local str
    if bool then str = string.format("  %-13s true", tag .. ":")
    else         str = string.format("  %-13s false", tag .. ":") end
    vim.cmd('echon "' .. str .. '" | echo ""')
end
---@param tag  string
---@param n    integer
local function print_tag_int(tag, n)
    local str = string.format("  %-13s %d", tag .. ":", n)
    vim.cmd('echon "' .. str .. '" | echo ""')
end
---@param tag  string
---@param str  string
local function print_tag_string(tag, str)
    str = string.format("  %-13s %s", tag .. ":", str)
    vim.cmd('echon "' .. str .. '" | echo ""')
end
---@param tag  string
---@param c1   string
---@param c2   string
---@param rgb  boolean|nil
---@param bold boolean|nil
local function print_tag_colors(tag, c1, c2, rgb, bold)
    tag = string.format("  %-12s ", tag .. ":")

    local a1, a2
    if rgb then a1 = c1; a2 = c2;
    else a1 = "       "; a2 = a1; end

    vim.api.nvim_set_hl(0, 'LeunTemp1', { fg = "black", bg = c1 })
    vim.api.nvim_set_hl(0, 'LeunTemp2', { fg = "black", bg = c2 })

    if bold then
        vim.cmd('echohl LeunBold | echon "' .. tag .. '" | echohl None | echon " "')
    else
        vim.cmd('echon "' .. tag .. ' "')
    end
    vim.cmd('echohl LeunTemp1 | echon "' .. a1 .. '"' ..
        ' | echohl LeunTemp2 | echon "' .. a2 .. '" | echohl None | echo ""')
end
---@param tag  string
---@param carr table color array
---@param rgb  boolean|nil
---@param bold boolean|nil
local function print_tag_colors_arr(tag, carr, rgb, bold)
    tag = string.format("  %-12s ", tag .. ":")

    if bold then
        vim.cmd('echohl LeunBold | echon "' .. tag .. '" | echohl None | echon " "')
    else
        vim.cmd('echon "' .. tag .. ' "')
    end

    local a = "       "
    for _, c in ipairs(carr) do
        vim.api.nvim_set_hl(0, 'LeunTemp1', { fg = "black", bg = c })

        if rgb then a = c end

        vim.cmd('echohl LeunTemp1 | echon "' .. a .. '"')
    end
    vim.cmd('echohl None | echo ""')
end
-- print info about palette, flavours, queues, marks and config This function is 
-- mapped to the user command 'LeunPrint'.
---@param write_rgb boolean|nil
function M.print(write_rgb)
    vim.api.nvim_set_hl(0, 'LeunBold', { bold = true, reverse = true })

    vim.cmd("echon 'palette:' | echo ''")           -- palette
    local p = M.config.palette
    print_tag_string("flavour", M.config.flavour)
    print_tag_colors("color", p.color1, p.color2, write_rgb, false)
    print_tag_colors("black", p.black1, p.black2, write_rgb, false)
    print_tag_colors("gray",  p.gray1,  p.gray2,  write_rgb, false)
    print_tag_colors("white", p.white1, p.white2, write_rgb, false)
    local carr = { p.info, p.hint, p.warning, p.error }
    print_tag_colors_arr("diagnostics", carr, write_rgb, false)
    print_tag_int("mode", p.mode)

    vim.cmd("echo 'flavours:' | echo ''")           -- flavours
    for _, flav in ipairs(flavour_list) do
        local colors = M.config.flavours[flav]
        print_tag_colors(flav, colors.color1, colors.color2,
                         write_rgb, flav == M.config.flavour)
    end

    vim.cmd("echo 'marked:' | echo ''")             -- marked
    for _, flav in ipairs(mark_list) do
        local colors = M.config.flavours[flav]
        print_tag_colors(flav, colors.color1, colors.color2,
                         write_rgb, flav == M.config.flavour)
    end

    vim.cmd("echo 'rand_queue:' | echo ''")         -- rand_queue
    for i, colors in ipairs(rand_queue) do
        print_tag_colors(string.format("%02d", i), colors.color1, colors.color2,
                         write_rgb, false)
    end

    vim.cmd("echo 'config:' | echo ''")             -- config
    p = M.config.base_colors
    print_tag_colors("black", p.black1, p.black2, write_rgb, false)
    print_tag_colors("gray",  p.gray1,  p.gray2,  write_rgb, false)
    print_tag_colors("white", p.white1, p.white2, write_rgb, false)
    p = M.config.diagnostics_colors
    carr = { p.info, p.hint, p.warning, p.error }
    print_tag_colors_arr("diagnostics", carr, write_rgb, false)
    print_tag_int("mode", M.config.mode)

    vim.api.nvim_set_hl(0, 'LeunBold',  {})         -- clear
    vim.api.nvim_set_hl(0, 'LeunTemp1', {})
    vim.api.nvim_set_hl(0, 'LeunTemp2', {})
end

-- writtes the code you need to generate for "flavour" to the buffer
---@param flavour string
---@param tab     boolean false|nil: raw table, true:  .add() call
function M.get_palette(flavour, tab)
    if not flavour then
        flavour = M.config.flavour
    elseif not M.config.flavours[flavour] then
        print("leun: unkwon flavour '" .. flavour .. "'")
        print("      do ':lua require(\"leun\").print()' to get flavour names")
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local params = ""

    for k, v in pairs(M.config.flavours[flavour]) do
        if type(v) == "string" then
            v = '"' .. v .. '"'
        elseif type(v) == "boolean" then
            if v then v = "true" else v = "false" end
        end
        params = params .. k .. ' = ' .. v .. ', '
    end

    local line
    if tab then
        line = 'require("leun").add("' .. flavour .. '", { ' .. params .. '})'
    else
        if string.find(flavour, " ") then
            flavour = '["' .. flavour .. '"]'
        end
        line = flavour .. ' = { ' .. params .. '},'
    end
    vim.api.nvim_buf_set_lines(buf, row, row, false, { line })
end

-- writtes the code you need to generate for all marked flavours to the buffer
---@param tab boolean false|nil: raw table, true:  .add() call
function M.get_marked(tab)
    for _, flav in ipairs(mark_list) do
        M.get_palette(flav, tab)
    end
end

---@param  flavour string
---@return boolean
local function gen_palette(flavour)
    if not flavour then return false end

    if not M.config.flavours[flavour] then
        print("leun: unkwon flavour '" .. flavour .. "'")
        print("      do ':lua require(\"leun\").print()' to get flavour names")
        return false
    end

    local palette
    palette = vim.tbl_extend("keep",
        M.config.base_colors, M.config.diagnostics_colors)
    palette = vim.tbl_extend("force", palette, M.config.flavours[flavour])

    palette.mode = palette.mode or M.config.mode

    if palette.mode == mmode.monomono then
        palette.info    = palette.color2
        palette.hint    = palette.info
        palette.error   = palette.info
        palette.warning = palette.info
    elseif palette.mode == mmode.somemono then
        palette.info = palette.color2
        palette.hint = palette.info
    elseif palette.mode == mmode.nonemono then
        -- skip
    end

    M.config.palette = palette
    M.config.flavour = flavour
    return true
end

---@param  mode string
---@param  lhs  string
---@return table table map (map info) and buff_local, or empty table if nil
local function get_keymap(mode, lhs)
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return { map = map, buff_local = false }
        end
    end
    maps = vim.api.nvim_buf_get_keymap(0, mode)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return { map = map, buff_local = true }
        end
    end
    return {}
end
local function set_map(mode, lhs, rhs, opts)
    local km
    if not mappings[mode] then mappings[mode] = {} end
    if mappings[mode][lhs] then goto set_map end       -- skip saving overwrite

    km = get_keymap(mode, lhs)
    mappings[mode][lhs] = { map = km.map, buff_local = km.buff_local, opts = opts }
::set_map::
    vim.keymap.set(mode, lhs, rhs, opts)
end
local function reset_map(mode, lhs)
    local info = mappings[mode][lhs]

    if info.buff_local == nil then  -- Unmap if there was no original mapping
        vim.api.nvim_del_keymap(mode, lhs)
        return
    end

    local map = info.map
    if info.buff_local then
        vim.api.nvim_buf_set_keymap(0, mode, lhs, map.rhs or "", {
            noremap  = map.noremap,
            silent   = map.silent,
            expr     = map.expr,
            nowait   = map.nowait,
            desc     = map.desc,
            callback = map.callback,
        })
    else
        vim.api.nvim_set_keymap(mode, lhs, map.rhs or "", {
            noremap  = map.noremap,
            silent   = map.silent,
            expr     = map.expr,
            nowait   = map.nowait,
            desc     = map.desc,
            callback = map.callback,
        })
    end
end

-- toggles FYT mode, remaps some keys to some usefull functions, use <esc> to
-- exit the mode. This function is mapped to the user command 'LeunFYT'.
-- mappings (normal mode):
--      <esc>   .find_your_taste()
--      r       .random()
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
function M.find_your_taste(_)
    if not fyt_active then
        local opts = {}
        set_map("n", "<esc>", ":LeunFYT<cr>", opts)
        set_map("n", "r",     M.random,       opts)
        set_map("n", "s",     M.switch,       opts)
        set_map("n", "m",     M.mark,         opts)

        set_map("n", "k", M.next,       opts)
        set_map("n", "j", M.prev,       opts)
        set_map("n", "K", M.next_mark,  opts)
        set_map("n", "J", M.next_mark,  opts)
        set_map("n", "h", M.rand_rolll, opts)
        set_map("n", "l", M.rand_rollr, opts)

        set_map("n", "i", ":LeunPrint<cr>", opts)
        set_map("n", "I", M.get_palette,    opts)
        set_map("n", "M", M.get_marked,     opts)

        fyt_active = true
    else
        for mode, maps in pairs(mappings) do
            for lhs, _ in pairs(maps) do
                reset_map(mode, lhs)
            end
        end
        fyt_active = false
    end
end

-- load flavour
---@param flavour string|nil flavour name or nil for reload
function M.load(flavour)
    if not flavour then
        flavour = M.config.flavour
    end

    if not gen_palette(flavour) then return end

    vim.opt.background = 'dark'
    vim.g.colors_name  = 'leun'

    package.loaded['lush_theme.leun'] = nil
    require('lush')(require('lush_theme.leun'))
end

-- flavour = { [link = {flav}], [color1|color2|black1|... = "..."] }
-- flavour.link = flavour for unused params
-- flavour.mode = int set the mode
--
-- All params in flavour are optional, if link is not set it will link with the
-- flavour is being used. Link "clones" the flavour to 'name' and overwrites the
-- cloned flavour with the values defined in the table. The rest of the values
-- (colors or config values) are taken from the config.
--
---@param name    string      flavour name to overwrite or create a new one
---@param flavour table|nil   if nil, clone the active flav. to "name"
---@param load    boolean|nil true: load after add
function M.add(name, flavour, load)
    local link
    if not flavour then
        link = M.config.flavour
        flavour = {}
    elseif not flavour.link then
        if M.config.flavours[name] then
            link = name
        else
            -- NOTE: I think this is unnecessary
            if M.config.flavours[M.config.flavour] then
                link = M.config.flavour
            else
                link = "random"
            end
        end
    elseif not M.config.flavours[flavour.link] then
        print("leun: unkwon flavour '" .. flavour.link .. "'")
        print("      do ':lua require(\"leun\").print()' to get flavour names")
        return
    else
        link = flavour.link
    end
    flavour.link = nil

    if not M.config.flavours[name] then
        local inserted = false
        for i = #flavour_list, 1, -1 do    -- sorted list (.setup())
            if flavour_list[i] < name then -- backwards insert
                flavour_list[i+1] = name
                inserted = true
                break
            end
            flavour_list[i+1] = flavour_list[i]
        end
        if not inserted then
            flavour_list[1] = name
        end
    end

    M.config.flavours[name] = vim.tbl_extend("force", M.config.flavours[link], flavour)

    if load then M.load(name) end
end

-- backwards delete to preserve the order of the list
---@param list  table
---@param value any   value *must* be in the list, or this code will break :(
local function list_back_del(list, value)
    local temp, helper
    for i = #list, 1, -1 do
        if list[i] == value then
            list[i] = temp
            break
        end
        helper = temp
        temp = list[i]
        list[i] = helper
    end
end
-- remove flavour, you can't remove the active flavour
---@param flavour string
function M.remove(flavour)
    if not M.config.flavours[flavour] then
        print("leun: unkwon flavour '" .. flavour .. "'")
        print("      do ':lua require(\"leun\").print()' to get flavour names")
        return
    elseif M.config.flavour == flavour then
        print("leun: you can't remove the active flavour '" .. flavour .. "'")
        return
    end

    M.config.flavours[flavour] = nil
    list_back_del(flavour_list, flavour) -- sorted in .setup()
    list_back_del(mark_list, flavour)    -- backwards delete to preserve the order
end

-- toggle mark
---@param flavour string|nil  flavour name or nil for active flavour
---@param action  boolean|nil true: add, false: del, nil: toggle
function M.mark(flavour, action)
    if not flavour then
        flavour = M.config.flavour
    elseif not M.config.flavours[flavour] then
        print("leun: unkwon flavour '" .. flavour .. "'")
        print("      do ':lua require(\"leun\").print()' to get flavour names")
        return
    end

    local found = false
    local i = 1
    while i <= #mark_list do            -- forward find delete flavour can or
        if mark_list[i] == flavour then -- can not be in the list
            found = true
            break
        end
        i = i + 1
    end

    if not found then   -- add
        if action == nil or action then
            mark_list[#mark_list+1] = flavour
        end
        return
    end

    if not action then  -- remove
        for j = i, #mark_list-1, 1 do       -- backwards delete to preserve the
            mark_list[j] = mark_list[j+1]   -- order of the marks
        end
        mark_list[#mark_list] = nil
    end
end

-- gen a random color "#??????"
---@return string
function M.random_color()
    local hex = "0123456789abcdef"
    local color = "#"
    for _ = 1, 6, 1 do
        local i = math.random(1, 16)
        color = color .. hex:sub(i, i)
    end
    return color
end
---@return table
local function random_flav()
   return {
        color1 = M.random_color(),
        color2 = M.random_color(),
    }
end
-- gen random flavour and load it
function M.random()
    local flavour = random_flav()

    if M.config.queue_size >= 1 then
        for i = M.config.queue_size - 1, 1, -1 do
            rand_queue[i + 1] = rand_queue[i]
        end
        rand_queue[1] = M.config.flavours["random"]
    end

    M.add("random", flavour, true)
end

---@param opts table|nil
function M.setup(opts)
    if default.user_flavours then           -- default flavs
        default.flavours = vim.tbl_extend("force",
            default.flavours, default.user_flavours)
        default.user_flavours = nil
    end
    M.config = vim.tbl_deep_extend("force", M.config, default)

    if opts and type(opts) == "table" then
        if opts.mark_list then                          -- user marks
            if type(opts.mark_list) == "table" then
                mark_list = opts.mark_list
            end
            opts.mark_list = nil
        end
        if opts.user_flavours then                      -- user flavs
            opts.flavours = vim.tbl_extend("force",
                opts.flavours or {}, opts.user_flavours)
            opts.user_flavours = nil
        end

        M.config = vim.tbl_deep_extend("force", M.config, opts)
    end

    if not M.config.flavours["random"] then
        M.add("random", random_flav())
    end

    local i = 1
    for color, _ in pairs(M.config.flavours) do
        flavour_list[i] = color
        i = i + 1
    end
    table.sort(flavour_list, function(a, b) return a < b end) -- sort ascending

    vim.api.nvim_create_user_command('LeunFYT',   M.find_your_taste, {})
    vim.api.nvim_create_user_command('LeunPrint', M.print, {})
end

-- switch flavour colors
function M.switch()
    local flavour = M.config.flavours[M.config.flavour]

    local temp = flavour.color1
    flavour.color1 = flavour.color2
    flavour.color2 = temp

    M.load(M.config.flavour)
end

---@param  value any
---@param  list  table
---@return integer|nil - ret nil if not in the list
local function list_get_indx(list, value)
    for i, flav in ipairs(list) do
        if value == flav then return i end
    end return nil
end

-- iterate throgh the flavour list (forward)
function M.next()
    if flavour_list[indx] == M.config.flavour then
        indx = indx + 1
    else
        indx = list_get_indx(flavour_list, M.config.flavour) + 1
    end
    if indx > #flavour_list then
        indx = 1
    end

    M.load(flavour_list[indx])
end

-- iterate throgh the flavour list (backwards)
function M.prev()
    if flavour_list[indx] == M.config.flavour then
        indx = indx - 1
    else
        indx = list_get_indx(flavour_list, M.config.flavour) - 1
    end
    if indx < 1 then
        indx = #flavour_list
    end

    M.load(flavour_list[indx])
end

-- iterate throgh the mark list (forward)
function M.next_mark()
    -- if #mark_list == 0 then return end -- M.load(nil): reloads, no need for this
    local i = list_get_indx(mark_list, M.config.flavour)
    if i == nil or i == #mark_list then
        M.load(mark_list[1])
    else
        M.load(mark_list[i+1])
    end
end
-- iterate throgh the mark list (backwards)
function M.prev_mark()
    -- if #mark_list == 0 then return end
    local i = list_get_indx(mark_list, M.config.flavour)
    if i == nil or i == 1 then
        M.load(mark_list[#mark_list])
    else
        M.load(mark_list[i-1])
    end
end

-- iterate throgh the random list (roll right)
function M.rand_rollr()
    if #rand_queue == 0 then return end

    local last
    if #rand_queue >= M.config.queue_size then
        last = rand_queue[M.config.queue_size]
    else
        last = rand_queue[#rand_queue + 1]
    end
    for i = M.config.queue_size - 1, 1, -1 do
        rand_queue[i + 1] = rand_queue[i]
    end
    rand_queue[1] = M.config.flavours["random"]

    M.add("random", last, true)
end

-- iterate throgh the random list (roll left)
function M.rand_rolll()
    if #rand_queue == 0 then return end

    local first = rand_queue[1]
    for i = 2, M.config.queue_size, 1 do
        rand_queue[i - 1] = rand_queue[i]
    end
    if #rand_queue >= M.config.queue_size then
        rand_queue[M.config.queue_size] = M.config.flavours["random"]
    else
        rand_queue[#rand_queue + 1] = M.config.flavours["random"]
    end

    M.add("random", first, true)
end

return M
