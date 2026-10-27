vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local notified = {}

local projects = {
  lua = { auto = { ".stylua.toml", "stylua.toml" } },
  python = { auto = { "ruff.toml", ".ruff.toml" }, ask = { "pyrpoject.toml" } },
}

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format" },
  },
  formatters = {
    ruff_fix = { require_cwd = true, append_args = { "--unfixable", "F401" } },
    ruff_format = { require_cwd = true },
    stylua = { require_cwd = true },
  },
  format_on_save = function(buf)
    local opts = { timeout_ms = 2000, lsp_format = "never" }
    if vim.g.format_on_save or vim.b[buf].format_on_save then
      return opts
    end
    local project = projects[vim.bo[buf].filetype]
    if not project then
      return
    end
    if vim.fs.root(buf, { project.auto }) then
      return opts
    end
    local root = project.ask and vim.fs.root(buf, { project.ask })
    if root and not notified[root] then
      notified[root] = true
      vim.notify("format-on-save is off in " .. root .. " (opt in with a trusted .nvim.lua)")
    end
  end,
})
