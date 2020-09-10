-----------------------------
-- Import Engine as Globals
local bge = {}
bge.gameStateManager  = require("bge.gameStateSystem")
bge.entitySystem      = require("bge.entitySystem")
bge.collisionSystem   = require("bge.collisionSystem")
bge.camera            = require("bge.camera")
bge.resourceManager   = require("bge.resourceManager")
bge.gameData          = require("bge.gameData")
bge.overWorld         = require("overworldMap")


return bge