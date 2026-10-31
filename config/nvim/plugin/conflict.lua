local marker = [[^[<=>|]\{7\}\( \|$\)]]

vim.keymap.set({ "n", "x" }, "]x", function()
  vim.fn.search(marker)
end, { desc = "Next conflict marker" })

vim.keymap.set({ "n", "x" }, "[x", function()
  vim.fn.search(marker, "b")
end, { desc = "Previous conflict marker" })
