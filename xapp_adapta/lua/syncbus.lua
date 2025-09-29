-- bus for state signalling
-- NOTE: a state bus for sending messages by named target
-- messages are combined and the last is issued by sync()
-- so used to keep a state current and avoid unsychronized
-- transitions of state
local nv = require("novaride").setup()

local Bus = require("bus")
--make it fine
---@class SyncBus: Bus
_G.SyncBus = Bus:extend()

local que = {}

---send bus arguments on bus actor
---@param self SyncBus
---@param ... ...
function SyncBus:send(...)
  que[self] = table.insert(que[self] or {}, { ... })
end

---synchronize to all send(...) on bus
---@param self SyncBus
function SyncBus:sync()
  --best order for I-cache locallity
  for k, _ in pairs(self) do
    for _, v in pairs(que[self] or {}) do
      -- call value function on all sent arguments
      k(unpack(v))
    end
  end
  que[self] = {}
end

nv()
