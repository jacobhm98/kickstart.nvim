-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- provides an lsp and debug capabilities for rust code
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    'mfussenegger/nvim-jdtls',
    lazy = false,
  },
  -- test suite
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'mrcjkb/rustaceanvim', -- Rust testrunner
      'rcasia/neotest-java', -- Java testrunner
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'rustaceanvim.neotest',
          require 'neotest-java' {
            -- If you want to customize the Java test runner, you can do so here
            -- ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
          },
        },
      }
    end,
    keys = {
      { '<leader>T', name = '[T]est' },
      {
        '<leader>Tn',
        function()
          require('neotest').run.run()
        end,
        desc = '[T]est [N]earest',
      },
      {
        '<leader>Tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[T]est [F]ile',
      },
      {
        '<leader>To',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[T]est [O]utput Panel',
      },
      {
        '<leader>Ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[T]est [S]ummary Panel',
      },
      {
        '<leader>Td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = '[T]est [D]ebug Nearest',
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
