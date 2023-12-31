local status, lspsaga = pcall(require, "lspsaga")
if not status then
  vim.notify("lspsaga not found.")
  return
end

-- https://github.com/kkharji/lspsaga.nvim
lspsaga.setup { -- defaults ...
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  -- hint_sign = "",
  infor_sign = "",
  diagnostic_header_icon = "   ",
  -- code_action_icon = " ",
  code_action_icon = "⚡",
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  max_preview_lines = 10,
  finder_action_keys = {
    open = "<CR>",
    vsplit = "s",
    split = "i",
    quit = "<ESC>",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  code_action_keys = {
    quit = "<ESC>",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<C-c>",
    exec = "<CR>",
  },
  definition_preview_icon = "  ",
  border_style = "single",
  rename_prompt_prefix = "➤",
  rename_output_qflist = {
    enable = false,
    auto_open_qflist = false,
  },
  server_filetype_map = {},
  diagnostic_prefix_format = "%d. ",
  diagnostic_message_format = "%m %c",
  highlight_prefix = false,
}


local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
map("i", "<tab>", "<C-R>=v:lua.tab_complete()<CR>", opt)
map("i", "<s-tab>", "<C-R>=v:lua.s_tab_complete()<CR>", opt)
map("i", "<enter>", "<C-R>=v:lua.enter_key()<CR>", opt)
map("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opt)
map("n", "re", "<cmd>Lspsaga rename<CR>", opt)
