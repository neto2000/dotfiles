
-- NeoVim Config by neto2000 --


-- set space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.wo.relativenumber = true

vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.o.breakindent = true

vim.o.hlsearch = false

vim.o.mouse = 'a'

-- sync clipboard
vim.o.clipboard = 'unnamedplus'

-- save undo history
vim.o.undofile = true

-- Case-insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.o.completeopt = 'menuone,noselect'


url = 'https://github.com/'


vim.pack.add({
    
    -- git commands
    url .. 'tpope/vim-fugitive',
    
    -- detect tabstop and shiftwidth
    url .. 'tpope/vim-sleuth',

    -- show pending key binds
    url .. 'folke/which-key.nvim',

    -- "gc" to comment selection
    url .. 'numToStr/Comment.nvim',

    
    url .. 'windwp/nvim-autopairs',
      
    url .. 'nvim-tree/nvim-web-devicons',

    url .. 'catgoose/nvim-colorizer.lua',

    url .. 'rebelot/kanagawa.nvim'
})


require("kanagawa").setup({

    colors = {

        palette = {

            sumiInk0 = "#0d0c0c",
            sumiInk1 = "#12120f",
            sumiInk2 = "#1D1C19",
            sumiInk3 = "#181616",
            sumiInk4 = "#282727",
            sumiInk5 = "#393836",
            sumiInk6 = "#625e5a",
        },
        theme = {

            wave = {

                syn = {

                    operator = "#E46876"
                }
            }
        }
    }
})

require("kanagawa").load()



vim.api.nvim_create_autocmd("FileType", {
  pattern = {"typescript", "typescriptreact", "svelte"},
  callback = function ()
    vim.b.sleuth_automatic = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

require("nvim-autopairs").setup({})

require("colorizer").setup({})


-- treesitter
vim.pack.add({ url .. "nvim-treesitter/nvim-treesitter" })

-- equivalent to :TSUpdate
require("nvim-treesitter.install").update("all")



-- autocompletion
vim.pack.add({
    
    url .. 'saghen/blink.lib',
    url .. 'saghen/blink.cmp'
})

require("blink.cmp").setup({

    completion = {
        documentation = {

            auto_show = true
        },
        accept = {auto_brackets = {enabled = true}}
    },

    keymap = {
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

        --['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    fuzzy = {
        implementation = "lua"
    }
})


vim.pack.add({
  
    url .. 'neovim/nvim-lspconfig',

    url .. 'mason-org/mason.nvim',
    url .. 'mason-org/mason-lspconfig.nvim'
})

local servers = {
    
    rust_analyzer = {},

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    }
}

require("mason").setup()
require("mason-lspconfig").setup({
    
    ensure_installed = vim.tbl_keys(servers)
})





for server, config in pairs(servers) do
  vim.lsp.config(server, {
    settings = config,

    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "grd", vim.lsp.buf.definition,
        { buffer = bufnr, desc = "vim.lsp.buf.definition()", })

      vim.keymap.set("n", "grf", vim.lsp.buf.format,
        { buffer = bufnr, desc = "vim.lsp.buf.format()", })
    end,
  })
end



vim.pack.add({

    url .. 'lewis6991/gitsigns.nvim'
})

require("gitsigns").setup({

    signs = {

        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    }
})


vim.pack.add({
    
    url .. 'lukas-reineke/indent-blankline.nvim'
})

require("ibl").setup {
  indent = {char = '┊'},

  exclude = {
    filetypes = {'dashboard'}
  }
}

vim.pack.add({ url .. "akinsho/toggleterm.nvim" })

require("toggleterm").setup({

    start_in_insert = true,
    terminal_mappings = true,
})


-- fuzzy finder
vim.pack.add({
    
    url .. 'nvim-lua/plenary.nvim',
    url .. 'nvim-telescope/telescope.nvim',

    url .. 'ThePrimeagen/harpoon'
})

require("telescope").setup({})



-- Keymaps --

-- do nothing on space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- telescope keymaps

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>g', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>se', vim.cmd.Ex, { desc = 'Open netrw' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Harpoon keymaps

vim.keymap.set('n', '<leader>n', require("harpoon.mark").add_file)

vim.keymap.set('n', '<leader>m', require("harpoon.ui").toggle_quick_menu)

vim.keymap.set('n', '<leader>1', function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set('n', '<leader>2', function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set('n', '<leader>3', function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set('n', '<leader>4', function() require("harpoon.ui").nav_file(4) end)
vim.keymap.set('n', '<leader>5', function() require("harpoon.ui").nav_file(5) end)

-- toggle term

vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm direction=float<cr>', {desc = "Toggle Floating Terminal"})
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], {desc = "Exit Terminal Mode"})


vim.pack.add({ url .. "nvimdev/dashboard-nvim"})

function construct_header()
    
    local logo = [[
    ███╗  ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗ ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚████║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚███║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    - Neto -
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"
    
    local head = vim.split(logo, "\n")


    return  head

end

function space_between_button(desc)
    
    return desc .. string.rep(" ", 33 - #desc)
end

require('dashboard').setup({

    
    
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = construct_header(),
        center = {
          { action = "Telescope find_files", desc = space_between_button(" Find file"), icon = " ", key = "f" },
          { action = "Telescope git_files", desc = space_between_button(" Find git files"), icon = "󰊢 ", key = "g" },
          { action = "ene | startinsert", desc = space_between_button(" New file"), icon = " ", key = "n" },
          { action = "Telescope oldfiles", desc = space_between_button(" Recent files"), icon = " ", key = "r" },
          { action = "e $MYVIMRC", desc = space_between_button(" Config"), icon = " ", key = "c" },
          { action = 'lua require("persistence").load()', desc = space_between_button(" Restore Session"), icon = " ", key = "s" },
          { action = "qa", desc = space_between_button(" Quit"), icon = " ", key = "q" },
        },
        footer = { " " }
    },
    
    
})


vim.pack.add({ url .. 'nvim-lualine/lualine.nvim' })

require('lualine').setup {

  options = {
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
  },
    sections = {
      lualine_a = {
        {
          "mode",
          icon = '',
          separator = { left = "", right = "" },
          color = {
            -- fg = "#1c1d21",
          },
        },
      },
      lualine_b = {
        {
          "branch",
          icon = "",
          separator = { left = "", right = "" },
          color = {
            -- bg = "#313244"
          },
        },
        {
          "diff",
          separator = { left = "", right = "" },
          color = {
            -- fg = "#1c1d21",
            -- bg = "#313244",
          },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          separator = { left = "", right = "" },
          color = {
            -- bg = "#45475a",
          },
        },
        {
          "filename",
        },
      },
      lualine_x = { "filesize" },
      lualine_y = {
        {
          "filetype",
          icons_enabled = true,
          color = {
            -- fg = "#cdd6f4",
            -- bg = "#313244",
          },
        },
      },
      lualine_z = {
        {
          "location",
          icon = "",
          color = {
            -- fg = "#1c1d21",
            -- bg = "#b4befe",
          },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "neo-tree", "lazy" },
}
