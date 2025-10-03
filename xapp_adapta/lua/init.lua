-- init.lua is loaded on startup
-- load many quick shortcuts into _G for less verbosity
-- NOTE: typing provides syntax highlighting for libso.so C functions

local nv = require("novaride").setup()
require("typing")
print("Loading Lua")
require("module")
require("async")
require("util")
print("Super _G loading complete")
--the base object type
Object = require("class")
Bus = require("bus")
SyncBus = require("syncbus")
StateBus = require("statebus")

nv()
