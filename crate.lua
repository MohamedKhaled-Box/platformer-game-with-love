local Crate = {
    img = love.graphics.newImage("assets/boxs.png")
}
Crate.__index = Crate
Crate.width = Crate.img:getWidth()
Crate.height = Crate.img:getHeight()
local ActiveCrates = {}

function Crate.new(x, y)
    local instance = setmetatable({}, Crate)
    instance.x = x
    instance.r = 0
    instance.y = y
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(30)
    table.insert(ActiveCrates, instance)
end

function Crate:update(dt)
    self:sync()
end
function Crate:sync()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Crate:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Crate.updateAll(dt)
    for i, instance in ipairs(ActiveCrates) do
        instance:update(dt)
    end
end
function Crate.drawAll()
    for i, instance in ipairs(ActiveCrates) do
        instance:draw()
    end
end

function Crate.removeAll()
    for i, v in ipairs(ActiveCrates) do
        v.physics.body:destroy()
    end
    ActiveCrates = {}
end

return Crate
