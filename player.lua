local Player = {}
local Sound = require("sound")

function Player:load()

    self:sizeAndSpeed()
    self.canDoubleJump = true
    self.onGround = false
    self.direction = "left"
    self.state = "idle"
    self.graceTime = 0
    self.graceDuration = 0.1
    self.coins = 0
    self.deathCounter = 0
    self.friction = 3500
    self.gravity = 1500
    self:loadAssets()
    self:health()
    self:physics()
    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }
end
function Player:sizeAndSpeed()
    self.x = 100
    self.y = 0
    self.startX = self.x
    self.startY = self.y
    self.alive = true
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.jumpHeight = -600
    self.maxSpeed = 200
    self.acceleration = 4000
end
function Player:loadAudio()
    Sound:init("hit", "sfx/player_damage.ogg", "static")
    Sound:init("jump", "sfx/player_jump.ogg", "static")
    Sound:init("death", "sfx/player_death_escape.ogg", "static")
end

function Player:physics()
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end
function Player:health()
    self.health = {
        current = 3,
        max = 3
    }
end
function Player:takeDamage(amount)
    self:paintRed()
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
        Sound:play("hit", "sfx", 0.2)
    else
        self.health.current = 0
        Player:die()
        Sound:play("death", "sfx", 0.2)
    end
end
function Player:die()
    self.alive = false
    self.deathCounter = self.deathCounter + 1
end

function Player:respawn()
    if self.alive == false then
        self:spawn()
        self.health.current = self.health.max
        self.alive = true
    end
end

function Player:spawn()
    self.physics.body:setPosition(self.startX, self.startY)

end

function Player:countCoins()
    self.coins = self.coins + 1
    self:paintGold()
end

function Player:loadAssets()
    self.animation = {
        timer = 0,
        rate = 0.1
    }

    self.animation.run = {
        total = 10,
        current = 1,
        img = {}
    }
    for i = 1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/Run" .. i .. ".png")
    end

    self.animation.idle = {
        total = 7,
        current = 1,
        img = {}
    }
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/Idle(" .. i .. ").png")
    end

    self.animation.air = {
        total = 10,
        current = 1,
        img = {}
    }
    for i = 1, self.animation.air.total do
        self.animation.air.img[i] = love.graphics.newImage("assets/player/air/Jump(" .. i .. ").png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

end

function Player:update(dt)
    self:respawn()
    self:animate(dt)
    self:resetColor(dt)
    self:changeDirection()
    self:changeState()
    self:syncPhysics()
    self:decreaseGraceTime(dt)
    self:move(dt)
    self:applyGravity(dt)
end

function Player:changeState()
    if self.onGround == false then
        self.state = "air"
    elseif self.xVel == 0 then
        self.state = "idle"
    else
        self.state = "run"
    end
end

function Player:changeDirection()
    if self.xVel < 0 then
        self.direction = "left"
    elseif self.xVel > 0 then
        self.direction = "right"
    end
end

function Player:animate(dt)

    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
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
    if (key == "w" or key == "up" or key == "space") then
        if self.onGround or self.graceTime > 0 then
            self.yVel = self.jumpHeight
            self.onGround = false
            Sound:play("jump", "sfx", 0.2)
            self.graceTime = 0
        elseif self.canDoubleJump == true then
            Sound:play("jump", "sfx", 0.2)
            self.canDoubleJump = false
            self.yVel = self.jumpHeight * 0.6
        end
    end
end
function Player:resetPostion(key)
    if key == "r" then
        self:spawn()

    end
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0)

    elseif self.xVel < 0 then
        self.xVel = math.min(self.xVel + self.friction * dt, 0)

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
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            Player:land(collision)
        elseif ny > 0 then
            self.yVel = 0
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

function Player:paintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Player:paintGold()
    self.color.red = 255
    self.color.green = 215
    self.color.blue = 0
end

function Player:resetColor(dt)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
end

function Player:draw()
    local scaleX = 1
    if self.direction == "left" then
        scaleX = -1
    end
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue, 1) -- flash red when taking damge

    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 1.5,
        self.animation.height / 1.5)
    love.graphics.setColor(1, 1, 1, 1) -- reset to normal color

end
return Player
