-- blank functions to get syntax highlighting from libso.so lua_CFunctions
-- NOTE: the string causes this to not assign and use the C version
local nv = require("novaride").setup("libso.so loaded")

-- NOTE: TYPING DEFINITION
-- @param <name> <type>
-- -- function type best not to list names avoiding confusion
-- @param <name> fun(<type>[, <type>][, ...]): [<type>, ][...]
-- @param ... <type>
-- -- and backwards for return on <type> and ... ordering
-- @return <type> [...]

-- NOTE: CLASS DEFINITION (THE CLASSES)
-- @class <class.class>[: <super.class>]
-- -- all the way upto "Class"
-- NOTE: INSTANCE WITHIN new() (THE INSTANCES)
-- @class <class>[: <super>]
-- -- all the way upto "Object"
-- NOTE: CAST A TYPE
-- @cast <name> <type>

-- NOTE: TYPE EXAMPLES IF YOU NEED STRANGE ONES
-- Union Type: TYPE_1 | TYPE_2
-- Array: VALUE_TYPE[]
-- Dictionary: { [string]: VALUE_TYPE }
-- Key-Value Table: table<KEY_TYPE, VALUE_TYPE>
-- Table Literal: { key1: VALUE_TYPE, key2: VALUE_TYPE }
-- Function: fun(PARAM: TYPE): RETURN_TYPE
-- Prefered Function: fun(TYPE): RETURN_TYPE
-- Generic: `NAME`

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
