GUI = {}

function GUI:load()
    self.coins = {}
    self.coins.x = 50
    self.coins.y = 50
    self.coins.img = love.graphics.newImage("assets/coins/coin_01.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 2.5
    self.font = love.graphics.newFont("assets/bit.ttf", 36)

end
function GUI:update(dt)

end
function GUI:draw()
    self:displayCoins()
    self:displayText()
end

function GUI:displayCoins()
    love.graphics.setColor(0.4, 0.2, 0, 0.5) -- Brownish shadow with 50% opacity
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
    love.graphics.setColor(1, 1, 1, 1) -- Reset to normal color
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)

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
