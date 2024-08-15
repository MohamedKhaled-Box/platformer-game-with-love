Player = {}

function Player:load()

    self:sizeAndSpeed()
    self.canDoubleJump = true
    self.onGround = false

    self.graceTime = 0
    self.graceDuration = 0.1

    self.friction = 3500
    self.gravity = 1500
    self:loadAssets()
    self:physics()

end
function Player:sizeAndSpeed()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.jumpHeight = -600
    self.maxSpeed = 200
    self.acceleration = 4000
end
function Player:physics()
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:loadAssets()
    self.animation = {
        timer = 0,
        rate = 0.1
    }

    self.animation.run = {
        total = 8,
        current = 1,
        img = {}
    }
    for i = 1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/Run" .. i .. ".png")
    end

    self.animation.idle = {
        total = 10,
        current = 1,
        img = {}
    }
    for i = 1, self.animation.idle.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/idle/Idle(" .. i .. ").png")
    end

    self.animation.air = {
        total = 8,
        current = 1,
        img = {}
    }
    for i = 1, self.animation.air.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/air/Jump(" .. i .. ").png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

end

function Player:update(dt)
    self:syncPhysics()
    self:decreaseGraceTime(dt)
    self:move(dt)
    self:applyGravity(dt)
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        if self.xVel < self.maxSpeed then
            if self.xVel + self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a", "left") then
        if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt < -self.maxSpeed then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxSpeed
            end
        end
    else
        self:applyFriction(dt)
    end
end

function Player:decreaseGraceTime(dt)
    if self.onGround == false then
        self.graceTime = self.graceTime - dt
    end
end

function Player:jump(key)
    if (key == "w" or key == "up") then
        if self.onGround or self.graceTime > 0 then
            self.yVel = self.jumpHeight
            self.onGround = false
            self.graceTime = 0
        elseif self.canDoubleJump == true then
            self.canDoubleJump = false
            self.yVel = self.jumpHeight * 0.6
        end
    end
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:applyGravity(dt)
    if self.onGround == false then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:beginContact(a, b, collision)
    if self.onGround == true then
        return
    end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            Player:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            Player:land(collision)
        end
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.onGround = false
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.onGround = true
    self.canDoubleJump = true
    self.graceTime = self.graceDuration
end

function Player:draw()
    -- love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    love.graphics
        .draw(self.animation.draw, self.x, self.y, 0, 1, 1, self.animation.width / 2, self.animation.height / 2)
end
