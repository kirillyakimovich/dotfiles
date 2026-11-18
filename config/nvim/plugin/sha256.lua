-- :Sha256 [url] downloads the URL on the cursor line and replaces the sha256 or
-- integrity that checks it. In Dockerfiles, $VARs resolve from ENV and ARG.
local ns = vim.api.nvim_create_namespace("sha256")

local function dockerfile_var(lines, name)
  for i, line in ipairs(lines) do
    local keyword, rest = line:match("^%s*(%u+)%s+(.*)$")
    if keyword == "ENV" or keyword == "ARG" then
      local v = (" " .. rest):match("%s" .. name .. '="([^"]*)"')
        or (" " .. rest):match("%s" .. name .. "=(%S+)")
        or (keyword == "ENV" and rest:match("^" .. name .. "%s+(.-)%s*$"))
      if v then
        return i, v
      end
    end
  end
end

local filetypes = {
  dockerfile = {
    resolve = function(url, lines)
      local missing = {}
      local function lookup(name)
        local _, v = dockerfile_var(lines, name)
        if not v then
          table.insert(missing, name)
        end
        return v
      end
      url = url:gsub("%${([%w_]+)}", lookup):gsub("%$([%w_]+)", lookup)
      if #missing > 0 then
        return nil, "No ENV or ARG value for " .. table.concat(missing, ", ")
      end
      return url
    end,
    definition = function(lines, name)
      return (dockerfile_var(lines, name))
    end,
  },
}

local formats = {
  { pattern = "%f[%x]" .. ("%x"):rep(64) .. "%f[^%x]", args = {} },
  { pattern = "sha256%-" .. ("[%w+/]"):rep(43) .. "=", args = { "--integrity" } },
}

local function match_hash(line)
  for _, format in ipairs(formats) do
    local s = line:find(format.pattern)
    if s then
      return format, s - 1
    end
  end
end

local function find_hash(lines, row, ft)
  local last = #lines
  for i = row + 2, #lines do
    if lines[i]:find("https?://") then
      last = i - 1
      break
    end
  end
  for i = row + 1, last do
    local format, s = match_hash(lines[i])
    if format then
      return { format = format, row = i - 1, s = s }
    end
  end
  if not (ft and ft.definition) then
    return
  end
  for i = row + 1, last do
    for name in lines[i]:gmatch("%${?([%w_]+)") do
      local d = ft.definition(lines, name)
      local format, s = match_hash(d and lines[d] or "")
      if format then
        return { format = format, row = d - 1, s = s }
      end
    end
  end
end

vim.api.nvim_create_user_command("Sha256", function(opts)
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.fn.line(".") - 1
  local url = opts.args ~= "" and opts.args or vim.api.nvim_get_current_line():match("https?://[^%s\"']+")
  if not url then
    vim.notify("No URL on this line", vim.log.levels.ERROR)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local ft = filetypes[vim.bo[buf].filetype]
  if ft then
    local err
    url, err = ft.resolve(url, lines)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
  end
  local hit = find_hash(lines, row, ft)
  if not hit then
    vim.notify("No sha256 or integrity for this URL", vim.log.levels.ERROR)
    return
  end
  local format = hit.format
  local mark = vim.api.nvim_buf_set_extmark(buf, ns, hit.row, hit.s, {})
  local cmd = { "get-sha256", unpack(format.args) }
  table.insert(cmd, url)
  vim.notify("Downloading " .. url)
  vim.system(
    cmd,
    { text = true },
    vim.schedule_wrap(function(result)
      local new = vim.trim(result.stdout or "")
      local ok = result.code == 0 and new:match("^" .. format.pattern .. "$")
      if not vim.api.nvim_buf_is_valid(buf) then
        if ok then
          vim.notify("Buffer closed, new hash: " .. new, vim.log.levels.WARN)
        end
        return
      end
      local pos = vim.api.nvim_buf_get_extmark_by_id(buf, ns, mark, {})
      vim.api.nvim_buf_del_extmark(buf, ns, mark)
      if not ok then
        vim.notify(vim.trim(result.stderr or ""), vim.log.levels.ERROR)
        return
      end
      local r, s = pos[1], pos[2]
      local old = vim.api.nvim_buf_get_text(buf, r, s, r, s + #new, {})[1]
      if not old:match("^" .. format.pattern .. "$") then
        vim.notify("The hash was edited during the download, new hash: " .. new, vim.log.levels.WARN)
        return
      end
      vim.api.nvim_buf_set_text(buf, r, s, r, s + #new, { new })
      local function short(hash)
        local prefix = hash:match("^sha256%-") or ""
        return prefix .. hash:sub(#prefix + 1, #prefix + 8) .. "…"
      end
      vim.notify(
        old == new and ("sha256 unchanged: " .. short(new))
          or ("sha256 updated: " .. short(old) .. " → " .. short(new))
      )
    end)
  )
end, { nargs = "?", desc = "Replace the next sha256 or integrity with the hash of the URL on this line" })
