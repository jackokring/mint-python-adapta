-- blank functions to get syntax highlighting from libso.so lua_CFunctions
-- NOTE: the string causes this to not assign and use the C version
local nv = require("novaride").setup("libso.so loaded")

---Unitary simplified sine and cosine
---@param x number
---@param quad number | nil
---@param quart number | nil
---@return number
---@return number
_G.csq = function(x, quad, quart)
  return 0.0, 0.0
end

nv()
