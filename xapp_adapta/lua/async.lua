-- everything using async
local novaride = require("novaride").setup()

local co = coroutine

---wrap a yielding function as an iterator
_G.wrap = co.wrap
---coroutine yeild within a function
_G.yield = co.yield

---construct a producer function which can use send(x)
---and receive(producer: thread) using the supply chain
---@param fn fun(chain: unknown): nil
---@param chain unknown
---@return thread
_G.producer = function(fn, chain)
  return co.create(function()
    -- generic ... and other info supply
    fn(chain)
  end)
end

---receive a sent any from a producer in a thread
---this includes the main thread with it's implicit coroutine
---@param prod thread
---@return any
_G.receive = function(prod)
  -- manual vague about error message (maybe second return, but nil?)
  local ok, value = co.resume(prod)
  -- maybe rx nil ...
  if ok then
    return value
    -- else
    -- return -- nil
  end
end

---send an any from inside a producer thread to be received
---returns success if send(nil) is considered a fail
---@param x any
---@return boolean
_G.send = function(x)
  co.yield(x)
  if x == nil then
    return false
  else
    -- close out (if not send(x) then return end?)
    return true
  end
end

novaride.restore()
