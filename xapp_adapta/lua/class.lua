---@brief [[
---classic (altered by S. Jackson under MIT)
---
---Copyright (c) 2014, rxi
---@brief ]]

---@class Class: Instance
---@field super Class|nil
local Class = {}
-- static class variables
Class.__index = Class
Class.super = nil

---Does nothing.
---You have to implement this yourself for extra functionality when initializing
---@param self Instance
---@param ... unknown
function Class:new(...) end

---Create a new class/Class by extending the base Class class.
---The extended Class will have a field called `super` that will access the super class.
---@param self Class
---@return Class
function Class:extend()
	local cls = {}
	for k, v in pairs(self) do
		--behaviours by copying "__metatable of instance == class"
		--not the static class variables as different class
		if k:find("__") == 1 then
			cls[k] = v
		end
	end
	--but check own statics not super's statics
	cls.__index = cls
	--static reference to super
	cls.super = self
	--if static not found, check super?
	--no as cls.__index = cls
	--an extra hidden super pointer for is()?
	--I suppose it has a bit of dynamic programming anti-clobber of super
	return setmetatable(cls, self)
	--optimise
end

---Implement a mixin onto this Class.
---@param self Class
---@param ... unknown
function Class:mixin(...)
	for _, cls in pairs({ ... }) do
		for k, v in pairs(cls) do
			if self[k] == nil and type(v) == "function" then
				self[k] = v
			end
		end
	end
end

---Checks if the Class is an instance
---This will start with the lowest class and loop over all the superclasses.
---@param self Instance
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
---@param self Instance
---@return string
function Class:__tostring()
	return "Instance " .. tostring(self)
end

---You can call the class the initialize it without using `Class:new`.
---@param self Class
---@param ... unknown
---@return Instance
function Class:__call(...)
	--Yes, a Class is an instance of class class
	---@class Instance
	local obj = setmetatable({}, self)
	--compiler type exact not inferred
	--as the : notation just goes funny, and won't
	getmetatable(obj).new(obj, ...)
	return obj
end

return Class
