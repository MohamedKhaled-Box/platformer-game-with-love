local Map = {}
local STI = require("sti")
local Coin = require("coin")
local Spike = require("spike")
local Crate = require("crate")
local Enemy = require("enemy")
local Sound = require("sound")
local Player = require("player")

function Map:load()
    self.currentLevel = 1
    World = love.physics.newWorld(0, 1500)
    loopSound = Sound:play("music", "sfx", 0.4)
    loopSound:setLooping(true)
    World:setCallbacks(beginContact, endContact)
    self:init()

end
function Map:loadAudio()
    Sound:init("music", "sfx/background.ogg", "static")

end

function Map:init()
    if self.currentLevel < 7 then
        self.level = STI("map/" .. self.currentLevel .. ".lua", {"box2d"})
    else
        self.currentLevel = 1
        Player.coins = 0
        Player.deathCounter = 0
        Player.health.current = Player.health.max
        self.level = STI("map/" .. self.currentLevel .. ".lua", {"box2d"})
    end
    -- self.level = STI("map/4.lua", {"box2d"})
    self.level:box2d_init(World)
    self.solidLayer = self.level.layers.solid
    self.grassLayer = self.level.layers.grass
    self.objectLayer = self.level.layers.objects

    self.solidLayer.visible = false -- Hides the solid layer for the gound from drawing.
    self.objectLayer.visible = false -- Hides the solid layer for the objects from drawing.
    MapWidth = self.grassLayer.width * 16
    self:spawnObjects()
end
function Map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
    Player:spawn()

end

function Map:update(dt)
    if Player.x > MapWidth - 16 then
        self:next()
    end
end

function Map:clean()
    self.level:box2d_removeLayer("solid")
    Crate.removeAll()
    Coin.removeAll()
    Enemy.removeAll()
    Spike.removeAll()
end

function Map:spawnObjects()
    for i, v in ipairs(self.objectLayer.objects) do
        if v.type == "spikes" then
            Spike.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "crate" then
            Crate.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "enemy" then
            Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "coin" then
            Coin.new(v.x, v.y) -- because coins are circles and spike and boxs are rectangles
        end

    end

end
return Map
