local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- Gruvbox
    { 'ellisonleao/gruvbox.nvim', priority = 1000 },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = {':TSUpdate'},
        opts = {
            highlight = { enable = true },
            indent = { enable = true},
            ensure_installed = {
                "bash",
                "c",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "vim",
                "vimdoc",
            }
        }
    },

    -- Harpoon
    { 'theprimeagen/harpoon' },

    -- Undotree
    { 'mbbill/undotree' },

    -- Git - interface
    { 'tpope/vim-fugitive' },

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {
                'hrsh7th/nvim-cmp',
            },     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        },
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            --on_attach = function(buffer)
            --local gs = package.loaded.gitsigns

            --local function map(mode, l, r, desc)
            --  vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            --end

            -- stylua: ignore start
            --map("n", "]h", gs.next_hunk, "Next Hunk")
            --map("n", "[h", gs.prev_hunk, "Prev Hunk")
            --map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            --map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
            --map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
            --map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
            --map("n", "<leader>ghd", gs.diffthis, "Diff This")
            --map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            --end,
        },
    },

    -- Illuminate
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>tt", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
            { "<leader>ttw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
            { "<leader>tll", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
            { "<leader>tql", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
            { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "get references"},
        },
    },

    -- Dressing ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- Lualine
    {
        'nvim-lualine/lualine.nvim', opts = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Webdec-icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Nui - components
    { "MunifTanjim/nui.nvim", lazy = true },

    -- indent guides
    { "lukas-reineke/indent-blankline.nvim" },

    -- Copilot
    { 'github/copilot.vim' },

    -- Autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },

    -- Commenter
    { 'echasnovski/mini.comment', version = '*' },
})
