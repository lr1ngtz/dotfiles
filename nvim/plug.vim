call plug#begin()

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Git signs
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Nvim tree (File explorer)
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" LSP config
Plug 'neovim/nvim-lspconfig'

" Nvim cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Nvim autopairs
Plug 'windwp/nvim-autopairs'

" Need to config, have some issues
" " LSPsaga
" Plug 'glepnir/lspsaga.nvim'

call plug#end()

