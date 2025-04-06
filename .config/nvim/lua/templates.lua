local function insert_bash_template()
  -- Check if the buffer is empty
  if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
    -- Define your template as a Lua string
    local bash_template = [[#!/bin/bash
# Date: $(date +%Y-%m-%d)
set -euo pipefail
# Your script starts here

]]
    -- Insert the template into the current buffer
    vim.api.nvim_put(vim.split(bash_template, "\n"), "l", false, true)
  end
end

-- Create an autocommand for .sh files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.sh", -- Trigger on new .sh files
  callback = insert_bash_template,
})
