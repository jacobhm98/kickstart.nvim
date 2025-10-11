-- Manually start vtsls for Vue files with Vue TypeScript plugin
-- vue_ls requires vtsls (or ts_ls) to be running for TypeScript support in .vue files

local vtsls_attached = false
for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
  if client.name == 'vtsls' then
    vtsls_attached = true
    break
  end
end

if not vtsls_attached then
  -- Start vtsls with Vue support using vim.lsp.start (Neovim 0.11+)
  -- Defer to ensure buffer is ready
  vim.schedule(function()
    vim.lsp.start({
      name = 'vtsls',
      cmd = { 'vtsls', '--stdio' },
      root_dir = vim.fs.root(0, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }),
      init_options = { hostInfo = 'neovim' },
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                languages = { 'vue' },
              },
            },
          },
        },
      },
    })
  end)
end
