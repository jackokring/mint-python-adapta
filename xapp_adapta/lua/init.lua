-- init.lua is loaded on startup
-- load many quick shortcuts into _G for less verbosity
print("Loading Lua")
require("module")
require("async")
require("bus")
require("util")
-- syntax highlighting for lua_CFunctions
require("typing")
print("Super _G loading complete")
require("class")
