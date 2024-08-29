---@diagnostic disable: undefined-global
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

-- This is a starter colorscheme for use with Lush,
-- for usage guides, see :h lush or :LushRunTutorial

--  :Lushify

local lush = require('lush')
local hsl  = lush.hsl

local palette = require("leun").config.palette

-- test
if false then
    local test = {
        -- white1  = "#bcbcbc",
        -- white2  = "#eeeeee",
        -- gray1   = "#585858",
        -- gray2   = "#8a8a8a",
        -- black1  = "#121212",
        -- black2  = "#303030",
        -- error   = "#fe4a49",
        -- warning = "#fed766",
        -- info    = "#549fff",
        -- hint    = "#2ceaa3",
        color1  = "#f3d34a",
        color2  = "#f3e37c",
    }
    palette = vim.tbl_extend("force", palette, test)
end

---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
    local sym = injected_functions.sym
    return {
        -- UI elements.
        -- See :h highlight-groups
        Normal         { fg = palette.white1 },                  -- Normal text
        NormalNC       { Normal },                               -- normal text in non-current windows
        Visual         { fg = palette.white1, gui = "reverse" }, -- Visual mode selection
        VisualNOS      { Visual },                               -- Visual mode selection when vim is "Not Owning the Selection".

        MatchParen     { fg = palette.black1, bg = palette.color2, gui = "reverse" }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
        Search         { bg = palette.gray1, gui = "reverse" },                       -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
        CurSearch      { Search },                                                    -- Highlighting a search pattern under the cursor (see 'hlsearch')
        QuickFixLine   { Search },                                                    -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
        IncSearch      { Search },                                                    -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
        Substitute     { Search },                                                    -- |:substitute| replacement text highlighting

        Cursor         { fg = "None", bg = "None", gui = "reverse" }, -- Character under the cursor
        lCursor        { Cursor },                                    -- Character under the cursor when |language-mapping| is used (see 'guicursor')
        TermCursor     { Cursor },                                    -- Cursor in a focused terminal
        -- TermCursorNC   { }, -- Cursor in an unfocused terminal

        NonText        { fg = palette.color1 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
        Conceal        { NonText },                                  -- Placeholder characters substituted for concealed text (see 'conceallevel')
        EndOfBuffer    { NonText },                                  -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
        Whitespace     { NonText },                                  -- "nbsp", "space", "tab" and "trail" in 'listchars'   
        SpecialKey     { fg = palette.black1, bg = palette.white2 }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|

        CursorLine     { bg = palette.black1 },               -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
        CursorColumn   { CursorLine },                        -- Screen-column at the cursor, when 'cursorcolumn' is set.
        ColorColumn    { NonText },                           -- Columns set with 'colorcolumn'
        SignColumn     { NonText },                           -- Column where |signs| are displayed
        CursorLineSign { SignColumn },                        -- Like SignColumn when 'cursorline' is set for the cursor line
        LineNr         { fg = palette.color1 },               -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
        LineNrAbove    { LineNr },                            -- Line number for when the 'relativenumber' option is set, above the cursor line
        LineNrBelow    { LineNr },                            -- Line number for when the 'relativenumber' option is set, below the cursor line
        CursorLineNr   { fg = palette.color2, gui = "bold" }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.

        VertSplit      { fg = palette.white2 },                     -- Column separating vertically split windows
        Winseparator   { VertSplit },                               -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
        FloatBorder    { VertSplit },                               -- Border of floating windows.
        Title          { fg = palette.color2, gui = "bold" },       -- Titles for output from ":set all", ":autocmd" etc.
        FloatTitle     { Title },                                   -- Title of floating windows.
        WildMenu       { fg = palette.white2, bg = palette.gray1 }, -- Current match in 'wildmenu' completion
        WinBar         { WildMenu },                                -- Window bar of current window
        WinBarNC       { WinBar },                                  -- Window bar of not-current windows
        TabLine        { WinBar },                                  -- Tab pages line, not active tab page label
        TabLineFill    { WinBar },                                  -- Tab pages line, where there are no labels
        TabLineSel     { WinBar, bg = palette.gray2 },              -- Tab pages line, active tab page label
        StatusLine     { fg = palette.color2 },                     -- Status line of current window
        StatusLineNC   { fg = "None", bg = "None" },                -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.

        Pmenu          { fg = palette.white2, bg = palette.gray1 }, -- Popup menu: Normal item.
        PmenuKind      { Pmenu },                                   -- Popup menu: Normal item "kind"
        PmenuExtra     { Pmenu },                                   -- Popup menu: Normal item "extra text"
        NormalFloat    { Pmenu },                                   -- Normal text in floating windows.
        PmenuSel       { fg = palette.gray1, bg = palette.white2 }, -- Popup menu: Selected item.
        PmenuKindSel   { PmenuSel },                                -- Popup menu: Selected item "kind"
        PmenuExtraSel  { PmenuSel },                                -- Popup menu: Selected item "extra text"
        PmenuSbar      { bg = palette.gray2 },                      -- Popup menu: Scrollbar.
        PmenuThumb     { bg = palette.gray1 },                      -- Popup menu: Thumb of the scrollbar.

        Directory      { fg = palette.color2, gui = "bold" }, -- Directory names (and other special names in listings)

        -- DiffAdd        { }, -- Diff mode: Added line |diff.txt|
        -- DiffChange     { }, -- Diff mode: Changed line |diff.txt|
        -- DiffDelete     { }, -- Diff mode: Deleted line |diff.txt|
        -- DiffText       { }, -- Diff mode: Changed text within a changed line |diff.txt|

        -- Folded         { }, -- Line used for closed folds
        -- FoldColumn     { }, -- 'foldcolumn'
        -- CursorLineFold { }, -- Like FoldColumn when 'cursorline' is set for the cursor line

        ModeMsg        { fg = palette.color1, gui = "bold" }, -- 'showmode' message (e.g., "-- INSERT -- ")
        MsgArea        { fg = palette.color1 },               -- Area for messages and cmdline
        -- MsgSeparator   { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
        -- MoreMsg        { }, -- |more-prompt|
        ErrorMsg       { fg = palette.color2, gui = "bold" }, -- Error messages on the command line
        WarningMsg     { fg = palette.color1, gui = "bold" }, -- Warning messages
        Question       { fg = palette.color2, gui = "bold" }, -- |hit-enter| prompt and yes/no questions

        -- SpellBad       { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
        -- SpellCap       { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
        -- SpellLocal     { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
        -- SpellRare      { }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.

        -- CursorIM       { }, -- Like Cursor, but used when in IME mode |CursorIM|


        -- syntax groups of code and markup
        -- See :h group-name
        Comment   { fg = palette.color1, gui = "italic" }, -- Any comment

        Constant  { fg = palette.color2, gui = "bold" },   -- (*) Any constant
        String    { fg = palette.color2 },                 --   A string constant: "this is a string"
        Boolean   { Constant },                            --   A boolean constant: TRUE, false
        Character { String },                              --   A character constant: 'c', '\n'
        Float     { String },                              --   A floating point constant: 2.3e10
        Number    { String },                              --   A number constant: 234, 0xff

        Identifier { Normal },                             -- (*) Any variable name
        Function   { Normal },                             --   Function name (also: methods for classes)

        Statement      { fg = palette.white2, gui = "bold" },  -- (*) Any statement
        -- Conditional    { }, --   if, then, else, endif, switch, etc.
        -- Exception      { }, --   try, catch, throw
        -- Keyword        { }, --   any other keyword
        -- Label          { }, --   case, default, etc.
        -- Operator       { }, --   "sizeof", "+", "*", etc.
        -- Repeat         { }, --   for, do, while, etc.

        PreProc        { Statement }, -- (*) Generic Preprocessor
        -- Include        { }, --   Preprocessor #include
        -- Define         { }, --   Preprocessor #define
        -- Macro          { }, --   Same as Define
        -- PreCondit      { }, --   Preprocessor #if, #else, #endif, etc.

        Type           { Statement }, -- (*) int, long, char, etc.
        -- StorageClass   { }, --   static, register, volatile, etc.
        -- Structure      { }, --   struct, union, enum, etc.
        -- Typedef        { }, --   A typedef

        Special        { Statement }, -- (*) Any special symbol
        -- SpecialChar    { }, --   Special character in a constant
        -- Tag            { }, --   You can use CTRL-] on this
        -- Delimiter      { }, --   Character that needs attention
        -- SpecialComment { }, --   Special things inside a comment (e.g. '\n')
        -- Debug          { }, --   Debugging statements

        Underlined     { fg = palette.white1, gui = "underline" }, -- Text that stands out, HTML links
        -- Ignore         { }, -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
        -- Error          { }, -- Any erroneous construct
        Todo           { fg = palette.black1, bg = palette.color2 }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX


        -- native LSP client and diagnostic system
        -- See :h lsp-highlight
        -- LspReferenceText            { } , -- Used for highlighting "text" references
        -- LspReferenceRead            { } , -- Used for highlighting "read" references
        -- LspReferenceWrite           { } , -- Used for highlighting "write" references
        -- LspCodeLens                 { } , -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
        -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
        -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

        -- See :h diagnostic-highlights
        DiagnosticError            { fg = palette.error, gui = "bold" },   -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        DiagnosticWarn             { fg = palette.warning, gui = "bold" }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        DiagnosticInfo             { fg = palette.info, gui = "bold" },    -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        DiagnosticHint             { fg = palette.hint, gui = "bold" },    -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        DiagnosticOk               { DiagnosticHint } ,                    -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticVirtualTextError { } , -- Used for "Error" diagnostic virtual text.
        -- DiagnosticVirtualTextWarn  { } , -- Used for "Warn" diagnostic virtual text.
        -- DiagnosticVirtualTextInfo  { } , -- Used for "Info" diagnostic virtual text.
        -- DiagnosticVirtualTextHint  { } , -- Used for "Hint" diagnostic virtual text.
        -- DiagnosticVirtualTextOk    { } , -- Used for "Ok" diagnostic virtual text.
        -- DiagnosticUnderlineError   { } , -- Used to underline "Error" diagnostics.
        -- DiagnosticUnderlineWarn    { } , -- Used to underline "Warn" diagnostics.
        -- DiagnosticUnderlineInfo    { } , -- Used to underline "Info" diagnostics.
        -- DiagnosticUnderlineHint    { } , -- Used to underline "Hint" diagnostics.
        -- DiagnosticUnderlineOk      { } , -- Used to underline "Ok" diagnostics.
        -- DiagnosticFloatingError    { } , -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
        -- DiagnosticFloatingWarn     { } , -- Used to color "Warn" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingInfo     { } , -- Used to color "Info" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingHint     { } , -- Used to color "Hint" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingOk       { } , -- Used to color "Ok" diagnostic messages in diagnostics float.
        -- DiagnosticSignError        { } , -- Used for "Error" signs in sign column.
        -- DiagnosticSignWarn         { } , -- Used for "Warn" signs in sign column.
        -- DiagnosticSignInfo         { } , -- Used for "Info" signs in sign column.
        -- DiagnosticSignHint         { } , -- Used for "Hint" signs in sign column.
        -- DiagnosticSignOk           { } , -- Used for "Ok" signs in sign column.

        -- Tree-Sitter syntax groups.
        -- See :h treesitter-highlight-groups,
        -- sym"@text.literal"      { }, -- Comment
        -- sym"@text.reference"    { }, -- Identifier
        -- sym"@text.title"        { }, -- Title
        -- sym"@text.uri"          { }, -- Underlined
        -- sym"@text.underline"    { }, -- Underlined
        -- sym"@text.todo"         { }, -- Todo
        -- sym"@comment"           { }, -- Comment
        -- sym"@punctuation"       { }, -- Delimiter
        -- sym"@constant"          { }, -- Constant
        -- sym"@constant.builtin"  { }, -- Special
        -- sym"@constant.macro"    { }, -- Define
        -- sym"@define"            { }, -- Define
        -- sym"@macro"             { }, -- Macro
        -- sym"@string"            { }, -- String
        -- sym"@string.escape"     { }, -- SpecialChar
        -- sym"@string.special"    { }, -- SpecialChar
        -- sym"@character"         { }, -- Character
        -- sym"@character.special" { }, -- SpecialChar
        -- sym"@number"            { }, -- Number
        -- sym"@boolean"           { }, -- Boolean
        -- sym"@float"             { }, -- Float
        -- sym"@function"          { }, -- Function
        -- sym"@function.builtin"  { }, -- Special
        -- sym"@function.macro"    { }, -- Macro
        -- sym"@parameter"         { }, -- Identifier
        -- sym"@method"            { }, -- Function
        -- sym"@field"             { }, -- Identifier
        -- sym"@property"          { }, -- Identifier
        -- sym"@constructor"       { }, -- Special
        -- sym"@conditional"       { }, -- Conditional
        -- sym"@repeat"            { }, -- Repeat
        -- sym"@label"             { }, -- Label
        -- sym"@operator"          { }, -- Operator
        -- sym"@keyword"           { }, -- Keyword
        -- sym"@exception"         { }, -- Exception
        -- sym"@variable"          { }, -- Identifier
        -- sym"@type"              { }, -- Type
        -- sym"@type.definition"   { }, -- Typedef
        -- sym"@storageclass"      { }, -- StorageClass
        -- sym"@structure"         { }, -- Structure
        -- sym"@namespace"         { }, -- Identifier
        -- sym"@include"           { }, -- Include
        -- sym"@preproc"           { }, -- PreProc
        -- sym"@debug"             { }, -- Debug
        -- sym"@tag"               { }, -- Tag
    }
end)

return theme
