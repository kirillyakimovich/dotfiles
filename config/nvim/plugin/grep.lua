local default_grepprg = vim.o.grepprg

local function set_grepprg()
  vim.o.grepprg = vim.fs.root(vim.fn.getcwd(), ".git") and "git grep -n --column -E" or default_grepprg
end

set_grepprg()
vim.api.nvim_create_autocmd("DirChanged", { callback = set_grepprg })

local running

vim.api.nvim_create_user_command("Grep", function(opts)
  if running then
    running:kill("sigterm")
  end
  local cmd = vim.o.grepprg .. " " .. vim.fn.expandcmd(opts.args)
  vim.fn.setqflist({}, " ", { title = cmd })
  local id = vim.fn.getqflist({ id = 0 }).id
  local partial = ""
  local opened = false

  local function add(lines)
    if #lines == 0 then
      return
    end
    vim.fn.setqflist({}, "a", { id = id, lines = lines, efm = vim.o.grepformat })
    if not opened then
      opened = true
      vim.cmd("botright copen | wincmd p")
    end
  end

  local this
  this = vim.system(
    { vim.o.shell, vim.o.shellcmdflag, cmd },
    {
      stdout = vim.schedule_wrap(function(_, data)
        if not data then
          return
        end
        local lines = vim.split(partial .. data, "\n")
        partial = table.remove(lines)
        add(lines)
      end),
    },
    vim.schedule_wrap(function(result)
      if running == this then
        running = nil
      end
      if result.signal ~= 0 then
        return
      end
      add(partial ~= "" and { partial } or {})
      local count = vim.fn.getqflist({ id = id, size = 0 }).size
      if result.code > 1 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
      else
        vim.notify(count .. " matches")
      end
    end)
  )
  running = this
end, { nargs = "+", complete = "file" })
