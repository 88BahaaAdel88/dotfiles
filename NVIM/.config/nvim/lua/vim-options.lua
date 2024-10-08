vim.cmd("set noexpandtab")
vim.cmd("set shiftwidth=8")
vim.cmd("set autoindent")
vim.cmd("set smartindent")
vim.cmd("filetype on")
vim.cmd("set relativenumber")
vim.g.mapleader = " "
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("nnoremap <C-d> yyP")

vim.cmd("set tabstop=8")
vim.cmd("set textwidth=80")
vim.cmd("set cindent")
vim.cmd("set cinoptions=:0")
vim.cmd("set formatoptions+=cqrn")
vim.cmd("command! Betty !betty %")
vim.cmd("nnoremap <S-PageDown> $")
vim.cmd("inoremap <S-PageDown> <C-o>$")
vim.cmd("nnoremap <S-PageUp> ^")
vim.cmd("inoremap <S-PageUp> <C-o>^")



-- Enable persistent undo
vim.cmd('set undofile')
-- Set the directory for undo files
vim.cmd('set undodir=~/.config/nvim/undo')
-- Optional: Set the maximum number of levels for the undo history
vim.cmd('set undolevels=1000')
