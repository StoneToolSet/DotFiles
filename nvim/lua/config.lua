vim.pack.add({
	"https://github.com/vhyrro/luarocks.nvim"
})
require("luarocks-nvim").setup({
	rocks = {"luafilesystem"},
})

local lfs = require("lfs")

return {pri = -1, func = function()
	local confd = "/home/caveman/.config/nvim/"
	local function GetConfigs(dir, pass)
		p = pass
		d = confd..dir
		for file in lfs.dir(d) do
			if file ~= "." and file ~= ".." then
				local f = dir..'/'..file
				local attr = lfs.attributes(confd..f)

				if attr.mode == "directory" then
					p = GetConfigs(dir..'/'..file, p)
				else -- entry is a file
					if f:match("[^.]+$") == "lua" then
						p[#(p) + 1] = string.gsub(string.gsub(string.gsub(dir..'/'..f:match("^.+/(.+)$"), ".lua", ""), "lua/", ""), "/", ".")
					end
				end
			end
		end
		return p
	end

	local function GetFunctionTable(files)
		functions = {}
		
		for i,f in pairs(files) do
			functions[i] = require(f)
		end


		return functions
	end
	
	files = GetConfigs("lua", {})

	functions = GetFunctionTable(files)
		
	table.sort(functions, function(a, b)
        return a.pri > b.pri
    end)
	for p,f in next,functions do
		if f.pri ~= -1 then
			f.func()
		end
	end
end}
