-- Require luafilesystem and luash

local lfs = require("lfs")

dir = lfs.currentdir()
home = os.getenv("HOME")

lfs.link(dir.."/nvim", home.."/.config/nvim", true)
lfs.link(dir.."/hypr", home.."/.config/hypr", true)
lfs.link(dir.."/bear", home.."/.config/bear", true)
lfs.link(dir.."/zsh-scripts", home.."/.local/share/scripts", true)

for file in lfs.dir(dir.."/zsh") do
	if file ~= nil and file ~= "." and file ~= ".." then
		lfs.link(dir.."/zsh/"..file, home.."/"..file, true)
	end
end
