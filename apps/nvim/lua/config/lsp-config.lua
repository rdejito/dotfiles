-- Grab the default config from the lspconfig plugin frfr
local lua_cfg = vim.lsp.config.lua_ls

-- Modify it with your custom settings
lua_cfg.settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim' },
    },
    workspace = {
      library = vim.api.nvim_get_runtime_file("", true),
      checkThirdParty = false,
    },
  },
}

-- Enable it
vim.lsp.config('lua_ls', lua_cfg)
vim.lsp.enable('lua_ls')

-- Java things
vim.lsp.enable("jdtls")
