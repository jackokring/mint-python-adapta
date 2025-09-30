-- bus for state signalling
-- NOTE: a sync bus for sending messages by named target
-- messages are grouped to efficiently forward at a time by sync()
-- so used to control timely processing of messages on a clock

-- oooh, <leader>e for less mousy tabbing
-- trying not to get distracted by Mordoria ...
local nv = require("novaride").setup()

local Bus = require("bus")
--make it fine
---@class SyncBusClass: BusClass
_G.SyncBus = Bus:extend()

local que = {}

---send bus arguments on bus actor
---@param self Bus
---@param ... any
function SyncBus:send(...)
  que[self] = table.insert(que[self] or {}, { ... })
end

---synchronize to all send(...) on bus
---@param self Bus
function SyncBus:sync()
  --best order for I-cache locallity
  local qs = que[self]
  -- aligned atomic commit
  que[self] = {}
  for k, _ in pairs(self) do
    for _, v in pairs(qs or {}) do
      -- call value function on all sent arguments
      k(unpack(v))
    end
  end
end

nv()
