-- bus for state signalling
-- NOTE: a signalling bus for sending messages by named target
local nv = require("novaride").setup()

local Object = require("class")
--make it fine
---@class BusClass: Class
_G.Bus = Object:extend()
local names = {}

---return a bus object for a name
---this bus object then supports
---send() and listen() with remove()
---bus singleton
---@param self Bus
---@param named string
---@return Bus | nil
function Bus:new(named)
  -- avoid namespace issues with method names in self
  local b = names[named]
  if b then
    ---@class Bus: Object
    return b
  else
    names[named] = self
  end
end

---send bus arguments on bus actor
---@param self Bus
---@param ... any
function Bus:send(...)
  for k, _ in pairs(self) do
    -- call value function on arguments
    k(...)
  end
end

---listen for calls on bus actor for function
---@param self Bus
---@param fn fun(...): nil
function Bus:listen(fn)
  -- minor ref count efficiency
  self[fn] = true
end

---remove listener function from bus
---@param self Bus
---@param fn fun(...): nil
function Bus:remove(fn)
  self[fn] = nil
end

---destroy a bus so it can be released by the collector
---@param self Bus
function Bus:destroy()
  -- cancel all bussing
  for k, _ in pairs(self) do
    -- remove listeners
    self[k] = nil
  end
  for k, v in pairs(names) do
    if v == self then
      names[k] = nil
      return
    end
  end
  error("bus clone anti-pattern with nice destroy", 2)
end

nv()
