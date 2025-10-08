-- See `:help vim.lsp.start` for an overview of the supported `config` options.

local lombok_jar = vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/lombok.jar'

local config = {
  name = 'jdtls',

  -- `cmd` defines the executable to launch eclipse.jdt.ls.
  -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
  --
  -- As alternative you could also avoid the `jdtls` wrapper and launch
  -- eclipse.jdt.ls via the `java` executable
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = { 'jdtls', '--jvm-arg=-javaagent:' .. lombok_jar },

  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {},
  },

  -- This sets the `initializationOptions` sent to the language server
  -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
  -- you'll need to set the `bundles`
  --
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },

  -- Set up Java-specific keymaps after jdtls attaches
  on_attach = function(client, bufnr)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    -- Java-specific commands
    map('<leader>jo', require('jdtls').organize_imports, '[J]ava [O]rganize imports')
    map('<leader>ju', require('jdtls').update_project_config, '[J]ava [U]pdate project config')
    map('<leader>jv', require('jdtls').extract_variable, '[J]ava Extract [V]ariable')
    map('<leader>jc', require('jdtls').extract_constant, '[J]ava Extract [C]onstant')
    map('<leader>jm', require('jdtls').extract_method, '[J]ava Extract [M]ethod')
  end,
}
require('jdtls').start_or_attach(config)
