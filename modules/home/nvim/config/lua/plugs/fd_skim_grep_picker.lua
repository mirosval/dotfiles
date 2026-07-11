-- Custom Telescope picker: fuzzy filename search (fd + sk --filter) that,
-- on the first comma typed, freezes the matched files and switches to a
-- ripgrep full-text search scoped to just those files.
local pickers = require("telescope.pickers")
local make_entry = require("telescope.make_entry")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values

local M = {}

local MAX_CANDIDATES = 1000

local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

-- Splits on the first comma only; later commas are literal chars of the
-- grep query. Returns (before, nil) when there is no comma yet.
local function split_on_first_comma(prompt)
  local idx = prompt:find(",", 1, true)
  if not idx then
    return prompt, nil
  end
  return prompt:sub(1, idx - 1), prompt:sub(idx + 1)
end

local function lines_from_output(output, limit)
  local lines = {}
  if output and output ~= "" then
    for line in output:gmatch("[^\n]+") do
      lines[#lines + 1] = line
      if limit and #lines >= limit then
        break
      end
    end
  end
  return lines
end

local function fd_candidates(cwd)
  local res = vim.system({ "fd", "--type", "f", "--color", "never" }, { cwd = cwd, text = true }):wait()
  return lines_from_output(res.stdout)
end

-- Runs `sk --filter query` over `lines`, capped to MAX_CANDIDATES results,
-- and calls on_done(result_lines) on the main loop. Returns the spawned job
-- (or nil if short-circuited) so the caller can cancel it.
local function sk_filter(lines, query, on_done)
  if query == "" then
    local capped = {}
    for i = 1, math.min(#lines, MAX_CANDIDATES) do
      capped[i] = lines[i]
    end
    on_done(capped)
    return nil
  end

  local stdin = table.concat(lines, "\n")
  if stdin ~= "" then
    stdin = stdin .. "\n"
  end

  return vim.system({ "sk", "--filter", query }, { stdin = stdin, text = true }, vim.schedule_wrap(function(res)
    on_done(lines_from_output(res.stdout, MAX_CANDIDATES))
  end))
end

local function rg_search(cwd, files, pattern, on_done)
  local args = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--", pattern }
  for _, f in ipairs(files) do
    args[#args + 1] = f
  end

  return vim.system(args, { cwd = cwd, text = true }, vim.schedule_wrap(function(res)
    on_done(lines_from_output(res.stdout))
  end))
end

local function new_finder(opts)
  local file_entry_maker = make_entry.gen_from_file(opts)
  local grep_entry_maker = make_entry.gen_from_vimgrep(opts)

  local candidates = fd_candidates(opts.cwd)
  local current_job
  local generation = 0

  local function cancel()
    if current_job then
      pcall(function()
        current_job:kill(9)
      end)
      current_job = nil
    end
  end

  local function emit(process_result, process_complete, lines, entry_maker)
    for i, line in ipairs(lines) do
      local entry = entry_maker(line)
      if entry then
        entry.index = i
      end
      if process_result(entry) then
        return
      end
    end
    process_complete()
  end

  local callable = function(_, prompt, process_result, process_complete)
    cancel()
    generation = generation + 1
    local my_generation = generation

    local before, after = split_on_first_comma(prompt or "")

    if after == nil then
      current_job = sk_filter(candidates, before, function(lines)
        if my_generation ~= generation then
          return
        end
        emit(process_result, process_complete, lines, file_entry_maker)
      end)
      return
    end

    local pattern = trim(after)
    if pattern == "" then
      process_complete()
      return
    end

    current_job = sk_filter(candidates, before, function(scoped_files)
      if my_generation ~= generation then
        return
      end
      if #scoped_files == 0 then
        process_complete()
        return
      end
      current_job = rg_search(opts.cwd, scoped_files, pattern, function(lines)
        if my_generation ~= generation then
          return
        end
        emit(process_result, process_complete, lines, grep_entry_maker)
      end)
    end)
  end

  return setmetatable({
    close = cancel,
  }, {
    __call = callable,
  })
end

function M.picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()

  pickers
    .new(opts, {
      prompt_title = "Find Files + Grep (comma to scope)",
      finder = new_finder(opts),
      sorter = sorters.empty(),
      previewer = conf.grep_previewer(opts),
      debounce = 100,
    })
    :find()
end

return M
