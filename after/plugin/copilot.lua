vim.cmd[[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
vim.cmd[[imap <silent><script><expr> <C-n> copilot#Next()]]
vim.cmd[[imap <silent><script><expr> <C-p> copilot#Previous()]]
vim.g.copilot_no_tab_map = true
vim.cmd[[highlight CopilotSuggestionCurrent guifg=#555555 ctermfg=8]]

