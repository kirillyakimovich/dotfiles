local marker = [[^[<=>|]\{7\}\( \|$\)]]

vim.keymap.set({ "n", "x" }, "]x", function()
  vim.fn.search(marker)
end, { desc = "Next conflict marker" })

vim.keymap.set({ "n", "x" }, "[x", function()
  vim.fn.search(marker, "b")
end, { desc = "Previous conflict marker" })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function(args)
    vim.diagnostic.enable(vim.fn.search(marker, "nw") == 0, { bufnr = args.buf })
  end,
})
