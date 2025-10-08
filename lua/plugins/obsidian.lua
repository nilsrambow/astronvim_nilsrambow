---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  cmd = { "Obsidian" },
  ft = "markdown",
  keys = {
      { "gf", "<cmd>Obsidian follow<cr>", ft = "markdown", desc = "Follow Obsidian link" },
      { "<leader>Oo", "<cmd>Obsidian open<cr>", ft = "markdown", desc = "Open in Obsidian" },
      { "<leader>On", "<cmd>Obsidian new<cr>", ft = "markdown", desc = "New Obsidian note" },
      { "<leader>Os", "<cmd>Obsidian search<cr>", ft = "markdown", desc = "Search Obsidian" },
      { "<leader>Oq", "<cmd>Obsidian quick-switch<cr>", ft = "markdown", desc = "Quick switch" },
      { "<leader>Ob", "<cmd>Obsidian backlinks<cr>", ft = "markdown", desc = "Show backlinks" },
      { "<leader>Ot", "<cmd>Obsidian today<cr>", ft = "markdown", desc = "Today's note" },
      { "<leader>Oy", "<cmd>Obsidian yesterday<cr>", ft = "markdown", desc = "Yesterday's note" },
      { "<leader>Ol", "<cmd>Obsidian links<cr>", ft = "markdown", desc = "Show links" },
  },
  opts = {
   legacy_commands = false,
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
    },
    checkbox = {
      order = { " ", "x", ">", "~", "!" },  -- Define the cycling order
      chars = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
    },
    ui = {
      enable = true,  -- Set to false to disable all UI features
      update_debounce = 200,  -- Update delay in milliseconds
      max_file_length = 5000,  -- Disable UI for files longer than this
            -- Bullets for lists
      bullets = { char = "•", hl_group = "ObsidianBullet" },
        -- External link icon
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Reference text (for footnotes, etc.)
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
    picker = {
      name = "telescope.nvim",
      note_mappings = {
      -- Create a new note from your query.
        new = "<C-x>",
      -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
      -- Add tag(s) to current note.
        tag_note = "<C-x>",
      -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },
    daily_notes = {
      folder = "daily", -- Where daily notes are stored
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "daily.md" -- Path to your template (relative to vault root)
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    disable_frontmatter = true
  },
}
