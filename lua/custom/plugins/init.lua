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
  -- test suite
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'mrcjkb/rustaceanvim', -- Rust testrunner
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'rustaceanvim.neotest',
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
}
