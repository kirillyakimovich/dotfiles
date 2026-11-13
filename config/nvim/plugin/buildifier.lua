-- Alternative: nvim-lint (https://github.com/mfussenegger/nvim-lint) ships a
-- buildifier linter.
local ns = vim.api.nvim_create_namespace("buildifier")
local group = vim.api.nvim_create_augroup("buildifier", {})

local function diagnostics(result)
  local items = {}
  local ok, report = pcall(vim.json.decode, result.stdout)
  for _, file in ipairs(ok and report.files or {}) do
    if file.valid and not file.formatted then
      table.insert(items, {
        lnum = 0,
        col = 0,
        severity = vim.diagnostic.severity.HINT,
        source = "buildifier",
        code = "reformat",
        message = "The file isn't formatted with buildifier.",
      })
    end
    for _, warning in ipairs(file.warnings) do
      table.insert(items, {
        lnum = warning.start.line - 1,
        col = warning.start.column - 1,
        end_lnum = warning["end"].line - 1,
        end_col = warning["end"].column - 1,
        severity = vim.diagnostic.severity.WARN,
        source = "buildifier",
        code = warning.category,
        message = warning.message .. "\n\n" .. warning.url,
      })
    end
  end
  local line, col, message = (result.stderr or ""):match(":(%d+):(%d+): ([^\n]+)")
  if line then
    table.insert(items, {
      lnum = tonumber(line) - 1,
      col = tonumber(col) - 1,
      severity = vim.diagnostic.severity.ERROR,
      source = "buildifier",
      message = message,
    })
  end
  return items
end

local function lint(buf)
  local root = vim.fs.root(buf, { "MODULE.bazel", "WORKSPACE", "WORKSPACE.bazel" })
  if not root or vim.fn.executable("buildifier") == 0 then
    return
  end
  local path = vim.fs.relpath(root, vim.api.nvim_buf_get_name(buf))
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
  local cmd = { "buildifier", "-mode=check", "-lint=warn", "-format=json", "-path", path, "-" }
  vim.system(
    cmd,
    { cwd = root, stdin = text, text = true },
    vim.schedule_wrap(function(result)
      if vim.api.nvim_buf_is_valid(buf) then
        vim.diagnostic.set(ns, buf, diagnostics(result))
      end
    end)
  )
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "bzl",
  callback = function(args)
    lint(args.buf)
    vim.api.nvim_clear_autocmds({ group = group, buffer = args.buf })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      buffer = args.buf,
      callback = function()
        lint(args.buf)
      end,
    })
  end,
})
