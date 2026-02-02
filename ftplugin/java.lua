-- See `:help vim.lsp.start` for an overview of the supported `config` options.

local lombok_jar = vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/lombok.jar'

-- Set indent to match google-java-format (2 spaces)
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

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
  root_dir = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts', 'mvnw', 'gradlew', '.git' }),

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
    bundles = vim.list_extend(
      -- Add the java-debug-adapter bundle
      vim.split(vim.fn.glob(vim.fn.expand '~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/*.jar', true), '\n'),
      -- Add the java-test bundles
      vim.split(vim.fn.glob(vim.fn.expand '~/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', true), '\n')
    ),
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

    -- Set up DAP configurations for Java debugging
    -- This enables debugging support with nvim-dap
    require('jdtls').setup_dap { hotcodereplace = 'auto' }

    -- Also add a simple attach configuration for Quarkus
    -- This doesn't require jdtls to resolve anything
    require('jdtls.dap').setup_dap_main_class_configs()
  end,
}
require('jdtls').start_or_attach(config)

-- Add standalone DAP configuration for attaching to Quarkus
-- This works independently of jdtls being attached
local dap = require 'dap'
dap.configurations.java = dap.configurations.java or {}

-- Simple attach config for Quarkus (runs on port 5005 by default)
table.insert(dap.configurations.java, {
  type = 'java',
  request = 'attach',
  name = 'Attach to Quarkus (localhost:5005)',
  hostName = 'localhost',
  port = 5005,
})
