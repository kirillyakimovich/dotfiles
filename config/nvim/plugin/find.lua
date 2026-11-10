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
  return arg == "" and files or vim.fn.matchfuzzy(files, arg)
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
