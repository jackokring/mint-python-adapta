---@brief [[
---classic (altered by S. Jackson under MIT)
---
---Copyright (c) 2014, rxi
---@brief ]]

---@class Class
local Class = {}
Class.__index = Class

---Does nothing.
---You have to implement this yourself for extra functionality when initializing
---@param self Class
function Class:new() end

---Create a new class/Class by extending the base Class class.
---The extended Class will have a field called `super` that will access the super class.
---@param self Class
---@return Class
function Class:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find "__" == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

---Implement a mixin onto this Class.
---@param self Class
---@param nil ...
function Class:mixin(...)
  for _, cls in pairs { ... } do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end

---Checks if the Class is an instance
---This will start with the lowest class and loop over all the superclasses.
---@param self Class
---@param T Class
---@return boolean
function Class:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

---The default tostring implementation for an Class.
---You can override this to provide a different tostring.
---@param self Class
---@return string
function Class:__tostring()
  return "Class " .. tostring(self)
end

---You can call the class the initialize it without using `Class:new`.
---@param self Class
---@param nil ...
---@return Class
function Class:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

return Class

