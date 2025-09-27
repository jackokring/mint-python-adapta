-- blank functions to get syntax highlighting from libso.so lua_CFunctions
local nv = require("novaride").setup()

if not _G.csq then
  ---Unitary simplified sine and cosine
  ---@param x number
  ---@param quad number | nil
  ---@param quart number | nil
  ---@return number
  ---@return number
  _G.csq = function(x, quad, quart)
    return 0.0, 0.0
  end
end

nv()
