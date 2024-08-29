love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
local Coin = require("coin")
local Spike = require("spike")
local Crate = require("crate")
local Enemy = require("enemy")
local GUI = require("gui")
local Camera = require("camera")
local Map = require("map")
local Sound = require("sound")

function love.load()
    Coin:loadAudio()
    Player:loadAudio()
    Map:loadAudio()
    Enemy.loadAssets()
    Map:load()
    Player:load()
    GUI:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    GUI:update(dt)
    Coin.updateAll(dt)
    Spike:updateAll(dt)
    Enemy.updateAll(dt)
    Crate:updateAll(dt)
    Camera:setPostion(Player.x, 0)
    Sound:update()
    Map:update(dt)
end

function love.draw()
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    Camera:apply()
    Player:draw()
    Enemy.drawAll()
    Coin.drawAll()
    Spike.drawAll()
    Crate.drawAll()
    Camera:clear()
    GUI:draw()
end

function love.keypressed(key)
    Player:jump(key)
    Player:resetPostion(key)

end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then
        return
    end
    if Spike.beginContact(a, b, collision) then
        return
    end
    Enemy.beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

