local GUI = {}
local Player = require("player")

function GUI:load()
    self.coins = {}
    self.coins.y = 50
    self.coins.x = love.graphics.getWidth() - 200
    self.coins.img = love.graphics.newImage("assets/coins/coin_01.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 2.5
    self.font = love.graphics.newFont("assets/bit.ttf", 36)

    self.hp = {}
    self.hp.x = 0
    self.hp.y = 30
    self.hp.img = love.graphics.newImage("assets/hp/heart.png")
    self.hp.width = self.coins.img:getWidth()
    self.hp.height = self.coins.img:getHeight()
    self.hp.scale = 3
    self.hp.spacing = self.hp.width * self.hp.scale + 16

end
function GUI:update(dt)

end
function GUI:draw()
    self:displayCoins()
    self:displayHP()
    self:displayText()
end

function GUI:displayCoins()
    love.graphics.setColor(0.4, 0.2, 0, 0.5) -- Brownish shadow with 50% opacity
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
    love.graphics.setColor(1, 1, 1, 1) -- Reset to normal color
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
end
function GUI:displayHP()
    for i = 1, Player.health.current do
        local x = self.hp.x + self.hp.spacing * i
        love.graphics.setColor(0.5, 0, 0, 0.5) -- Dark red shadow with 50% opacity
        love.graphics.draw(self.hp.img, x, self.hp.y, 0, self.hp.scale, self.hp.scale)
        love.graphics.setColor(1, 1, 1, 1) -- Reset to normal color
        love.graphics.draw(self.hp.img, x + 2, self.hp.y + 2, 0, self.hp.scale, self.hp.scale)
    end
end

function GUI:displayText()
    love.graphics.setFont(self.font)
    local x = self.coins.x + self.coins.width * self.coins.scale
    local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
    love.graphics.setColor(0, 0, 0, 0.5) -- black shadow
    love.graphics.print(" x " .. Player.coins, x + 2, y + 2)
    love.graphics.setColor(1, 1, 1, 1) -- reset to normal color
    love.graphics.print(" x " .. Player.coins, x, y)
end
return GUI
