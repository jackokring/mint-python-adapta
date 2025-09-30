-- blank functions to get syntax highlighting from libso.so lua_CFunctions
-- NOTE: the string causes this to not assign and use the C version
local nv = require("novaride").setup("libso.so loaded")

-- NOTE: TYPING DEFINITION
-- @param <name>[?] <type>[?]
-- @param <name>[?] fun([<name>: <type> [,<name>: <type>]]): <type>[?][, <type>[?]][...]
-- @param ... <type>[?]
-- @return <type>[?][, <type>[?]][...]

-- NOTE: CLASS DEFINITION
-- @class <class>[: <super>]
-- NOTE: CAST A TYPE AND GENERIC
-- @cast <name> <type>
-- @generic <name>

-- NOTE: TYPE EXAMPLES IF YOU NEED STRANGE ONES
-- Union Type: TYPE_1 | TYPE_2
-- Array: VALUE_TYPE[]
-- Dictionary: { [KEY_TYPE]: VALUE_TYPE }
-- Key-Value Table: table<KEY_TYPE, VALUE_TYPE>
-- Table Literal: { key1: VALUE_TYPE, key2: VALUE_TYPE }
-- Generic Capture: `NAME`

---Unitary simplified sine and cosine
---@param x number
---@param quad number?
---@param quart number?
---@return number
---@return number
_G.csq = function(x, quad, quart)
  return 0.0, 0.0
end

nv()
