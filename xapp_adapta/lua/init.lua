-- init.lua is loaded on startup
-- load many quick shortcuts into _G for less verbosity
-- NOTE: typing provides syntax highlighting for libso.so C functions
require("typing")
print("Loading Lua")
require("module")
require("async")
require("bus")
require("util")
print("Super _G loading complete")
--the base object type
Object = require("class")
