return {pri = 1000, func = function()
	vim.pack.add({
		"https://github.com/vhyrro/luarocks.nvim"
	})
	require("luarocks-nvim").setup({
		rocks = {"luafilesystem"},
	})
end
}
