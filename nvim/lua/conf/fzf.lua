return {pri = 300, func = function ()
	vim.pack.add({"https://github.com/ibhagwan/fzf-lua", "https://github.com/nvim-tree/nvim-web-devicons"})

	require'nvim-web-devicons'.setup({
	})

	require("fzf-lua").setup({})
	
	vim.keymap.set('n', '<Leader>ff', function () 
        require("fzf-lua").files({resume = true})
    end, {noremap = true})
    vim.keymap.set('n', '<Leader>fo', function () 
        require("fzf-lua").oldfiles()
    end, {noremap = true})

    vim.keymap.set('n', '<Leader>fg', function () 
        require("fzf-lua").live_grep()
    end, {noremap = true})
    vim.keymap.set('n', '<Leader>g', function ()
        require("fzf-lua").lgrep_curbuf()
    end, {noremap = true})
end}
