local files = {}

local function list_files()
  if vim.fs.root(vim.fn.getcwd(), ".git") then
    return vim.fn.systemlist("git ls-files")
  end
  local found = {}
  for name, type in vim.fs.dir(".", { depth = 3 }) do
    if type == "file" then
      table.insert(found, name)
    end
  end
  return found
end

function _G.Find(arg, _)
  if #files == 0 then
    files = list_files()
  end
  local list, query = files, arg
  local dir = arg:match("^.*/")
  if dir and vim.fn.isdirectory(dir) == 1 then
    local prefix = (dir:gsub("^%./", ""))
    list = vim.tbl_filter(function(f)
      return vim.startswith(f, prefix)
    end, files)
    query = arg:sub(#dir + 1)
  end
  return query == "" and list or vim.fn.matchfuzzy(list, query)
end

vim.o.findfunc = "v:lua.Find"
vim.o.wildmode = "noselect:lastused,full"

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = ":",
  callback = function()
    files = {}
  end,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = ":",
  callback = function()
    if vim.fn.getcmdline():match("^fin") then
      vim.fn.wildtrigger()
    end
  end,
})

vim.keymap.set("n", "<leader>f", ":find ", { desc = "Find file" })
vim.keymap.set("n", "<leader>F", ":find <C-r>=expand('%:h')<CR>/", { desc = "Find file next to current" })
vim.keymap.set("c", "%%", "<C-r>=expand('%:h')<CR>/", { desc = "Current file's directory" })
