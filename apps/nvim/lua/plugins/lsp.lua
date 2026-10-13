-- Language server / formatter / linter configuration that is not already
-- covered by a LazyVim extra. The language extras themselves are enabled in
-- `lazyvim.json` (manage them with `<leader>xe`).

return {
  -- Shell / Bash: LSP server. There is no dedicated LazyVim extra for bash,
  -- so wire up the server + formatter + linter manually.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        -- kotlin-language-server crashes on initialize when no Gradle project
        -- root is detected (fwcd/kotlin-language-server#648). Give it an
        -- absolute storage path like nvim-lspconfig#3239 suggests.
        kotlin_language_server = {
          init_options = {
            storagePath = vim.fn.stdpath("cache") .. "/kotlin-language-server",
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "shellcheck", "bash-language-server" })
      return opts
    end,
  },
  -- Format shell scripts with shfmt (Mason core already installs shfmt).
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
  -- Lint shell scripts with shellcheck.
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}