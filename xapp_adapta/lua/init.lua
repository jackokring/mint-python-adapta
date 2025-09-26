-- init.lua is loaded on startup
-- load many quick shortcuts into _G for less verbosity
print("Loading Lua")
require("module")
require("async")
require("bus")
require("util")
-- syntax highlighting for lua_CFunctions
-- make sure you have the if not _G.xxx then ... end guard
require("typing")
print("Super _G loading complete")
--the base object type
Object = require("class")
