vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/doc/cheat.txt",
  command = "helptags <afile>:p:h",
})
