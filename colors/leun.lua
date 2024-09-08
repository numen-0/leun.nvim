-- require("leun").load()

vim.opt.background = 'dark'
vim.g.colors_name  = 'leun'

package.loaded['lush_theme.leun'] = nil
require('lush')(require('lush_theme.leun'))
