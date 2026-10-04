vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local notified = {}

require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },
  },
  formatters = {
    ruff_fix = { require_cwd = true },
    ruff_format = { require_cwd = true },
  },
  format_on_save = function(buf)
    if vim.g.format_on_save or vim.b[buf].format_on_save then
      return { timeout_ms = 2000, lsp_format = "never" }
    end
    local root = vim.fs.root(buf, { "ruff.toml", ".ruff.toml", "pyproject.toml" })
    if root and not notified[root] and vim.bo[buf].filetype == "python" then
      notified[root] = true
      vim.notify("format-on-save is off in " .. root .. " (opt in with a trusted .nvim.lua)")
    end
  end,
})
