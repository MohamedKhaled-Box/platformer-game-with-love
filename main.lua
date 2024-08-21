local STI = require("sti")
require("player")
require("coin")
require("gui")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false -- Hides the solid layer from drawing.
    Player:load()
    GUI:load()
    Coin.new(300, 200)
    Coin.new(400, 100)
    Coin.new(500, 100)
    -- background = love.graphics.newImage("assets/country-platform-files/layers/country-platform-back.png")
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    GUI:update(dt)
    Coin.updateAll(dt)
end
function love.draw()
    -- love.graphics.draw(background)
    Map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)
    Player:draw()
    Coin.drawAll()

    love.graphics.pop()
    GUI:draw()
end
function love.keypressed(key)
    Player:jump(key)
end
function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then
        return
    end
    Player:beginContact(a, b, collision)
end
function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end
