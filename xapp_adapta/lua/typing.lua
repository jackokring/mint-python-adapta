-- blank functions to get syntax highlighting from libso.so lua_CFunctions
local novaride = require("novaride").setup()

---Unitary simplified sine and cosine
---@param x number
---@param quad number
---@param quart number
---@return number
---@return number
_G.csq = function(x, quad, quart)
	return 0.0, 0.0
end

novaride.restore()
