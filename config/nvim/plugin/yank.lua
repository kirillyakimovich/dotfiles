vim.keymap.set("x", "<leader>y", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  local file = vim.api.nvim_buf_get_name(0)
  local root = vim.fs.root(0, ".git")
  local path = root and vim.fs.relpath(root, file) or file
  local ref = s == e and ("%s:%d"):format(path, s) or ("%s:%d-%d"):format(path, s, e)
  vim.fn.setreg("+", ref)
  vim.cmd.normal({ vim.keycode("<Esc>"), bang = true })
  vim.notify(ref)
end, { desc = "Copy file:line reference" })
