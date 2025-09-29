-- bus for state signalling
-- NOTE: a state bus for sending messages by named target
-- messages are combined and the last is issued by sync()
-- so used to keep a state current and avoid unsychronized
-- transitions of state
local nv = require("novaride").setup()

local Bus = require("bus")
--make it fine
---@class StateBus: Bus
_G.StateBus = Bus:extend()

local que = {}

---send bus arguments on bus actor
---@param self StateBus
---@param ... ...
function StateBus:send(...)
  que[self] = { ... }
end

---synchronize to last send(...) only
---beware the infinite send loop if sync() triggers send()
---@param self StateBus
function StateBus:sync()
  local qs = que[self]
  if qs then
    repeat
      for k, _ in pairs(self) do
        -- call value function on last sent arguments
        k(unpack(que[self]))
      end
    -- bus managed to not send() to itself at least one whole sync
    until qs == que[self]
    que[self] = nil
  end
end

nv()
