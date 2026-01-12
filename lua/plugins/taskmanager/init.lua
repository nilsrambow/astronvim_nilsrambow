-- ~/.config/nvim/lua/plugins/taskmanager/init.lua
local M = {}
local tasks = {}
local tasks_file = vim.fn.stdpath "data" .. "//taskmanager//tasks.json"

-- Lade Tasks aus der JSON-Datei
local function load_tasks()
  local file = io.open(tasks_file, "r")
  if file then
    local content = file:read "*a"
    file:close()
    tasks = vim.json.decode(content) or {}
  end
end

-- Speichere Tasks in die JSON-Datei
local function save_tasks()
  local file = io.open(tasks_file, "w")
  if file then
    file:write(vim.json.encode(tasks))
    file:close()
  end
end

-- Erstelle einen neuen Task
local function create_task()
  -- Erstelle einen neuen Buffer für die Eingabe
  local buf = vim.api.nvim_create_buf(false, true)
  local width = 60
  local height = 5

  -- Erstelle das Floating Window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
  })

  -- Setze den Buffer-Inhalt (Prompt)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Neuen Task erstellen:",
    "(Format: 'Beschreibung [due:YYYY-MM-DD]')",
    "",
    "> ",
  })

  -- Setze den Cursor auf die Eingabezeile
  vim.api.nvim_win_set_cursor(win, { 4, 3 })
  vim.api.nvim_command "startinsert"

  -- Keybinding für Bestätigung (Enter)
  vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
    noremap = true,
    silent = true,
    callback = function()
      local input = vim.api.nvim_get_current_line():sub(2) -- Hole die Eingabe (nach "> ")
      vim.api.nvim_command "stopinsert"
      vim.api.nvim_win_close(win, true) -- Schließe das Fenster

      if input == "" then return end

      -- Extrahiere Due Date und Beschreibung
      local due_date = input:match "due:(%d%d%d%d%-%d%d%-%d%d)"
      local description = input:gsub("due:%d%d%d%d%-%d%d%-%d%d", ""):gsub("^%s*(.-)%s*$", "%1")

      -- Erstelle den Task
      local new_task = {
        id = #tasks + 1,
        description = description,
        due_date = due_date,
        status = "pending",
      }

      table.insert(tasks, new_task)
      save_tasks()

      vim.api.nvim_echo({ { string.format('Task "%s" erstellt!', description), "None" } }, false, {})
    end,
  })

  -- Keybinding für Abbruch (ESC)
  vim.api.nvim_buf_set_keymap(buf, "i", "<Esc>", "", {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_command "stopinsert"
      vim.api.nvim_win_close(win, true) -- Schließe das Fenster sofort
    end,
  })
end

-- Zeige alle Tasks in einem Buffer an
local function show_tasks()
  -- Sortiere Tasks nach Due Date (aufsteigend)
  table.sort(tasks, function(a, b)
    if a.due_date and b.due_date then
      return a.due_date < b.due_date
    elseif a.due_date then
      return true
    elseif b.due_date then
      return false
    else
      return a.id < b.id
    end
  end)

  -- Erstelle einen neuen Buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {
    string.format("%-4s | %-8s | %-30s | %-12s", "ID", "Status", "Beschreibung", "Due Date"),
    string.rep("-", 60),
  }

  -- Füge alle Tasks als Zeilen hinzu
  for _, task in ipairs(tasks) do
    local status = task.status == "pending" and "✗" or "✓"
    local due_date = task.due_date or "–"
    table.insert(lines, string.format("%-4d | %-8s | %-30s | %-12s", task.id, status, task.description, due_date))
  end

  -- Setze den Buffer-Inhalt
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Berechne die Größe des Floating Windows
  local width = math.min(80, vim.o.columns - 10)
  local height = math.min(20, #lines + 2)

  -- Erstelle das Floating Window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
  })

  -- Schließe das Fenster mit 'q' oder ESC
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

-- Initialisiere das Plugin
function M.setup()
  load_tasks()
  vim.api.nvim_create_user_command("TaskNew", create_task, { desc = "Erstelle einen neuen Task" })
  vim.api.nvim_create_user_command("TaskList", show_tasks, { desc = "Zeige alle Tasks an" })
  vim.keymap.set("n", "<leader>tt", "<cmd>TaskNew<cr>", { desc = "Neuen Task erstellen" })
  vim.keymap.set("n", "<leader>tl", "<cmd>TaskList<cr>", { desc = "Task-Liste anzeigen" })
end

-- Starte das Plugin
M.setup()
