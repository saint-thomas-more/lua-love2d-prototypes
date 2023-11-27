

local Player = {}

function Player:load()
  self.x = 100
  self.y = 0
  self.startX = self.x
  self.startY = self.y
  self.width = 20
  self.height = 60
  self.xVel = 0
  self.yVel = 0
  self.maxSpeed = 200
  self.accel = 4000
  self.friction = 3500
  self.gravity = 1500
  self.jumpAmmount = -500
  self.grounded = false
  self.hasJumps = 2
  self.direction = 'right'
  self.state = 'idle'
  self.health = {current = 3, max = 3}
  self.alive = true
  self.coins = 0

  self.color = {
    red = 1,
    green = 1,
    blue = 1,
    speed = 3
  }
  
  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.physics.body:setFixedRotation(true)
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

  self:loadAssets()
end

function Player:update(dt)
  self:syncPhysics()
  self:move(dt)
  self:apllyGravity(dt)
  self:animate(dt)
  self:setState()
  self:respawn()
  self:unTint(dt)
end

function Player:draw()
  local scaleX = 1
  if self.direction == 'left' then
    scaleX = -1
  end
  love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
  love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2)
  love.graphics.setColor(1, 1, 1, 1)
end

function Player:loadAssets()
  self.animation = {timer = 0, rate = 0.1}

  self.animation.run = {total = 6, current = 1, img = {}}
    for i = 1, self.animation.run.total do
      self.animation.run.img[i] = love.graphics.newImage('assets/player/run/'..i..'.png')
    end
  self.animation.idle = {total = 4, current = 1, img = {}}
  for i = 1, self.animation.idle.total do
    self.animation.idle.img[i] = love.graphics.newImage('assets/player/idle/'..i..'.png')
  end
self.animation.air = {total = 4, current = 1, img = {}}
  for i = 1, self.animation.air.total do
    self.animation.air.img[i] = love.graphics.newImage('assets/player/air/'..i..'.png')
  end
  
  
  self.animation.draw = self.animation.idle.img[1]
  self.animation.width = self.animation.draw:getWidth()
  self.animation.height = self.animation.draw:getHeight()

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

function Player:setState()
  if not self.grounded then
    self.state = 'air'
  elseif self.xVel == 0 then
    self.state = 'idle'
  else
    self.state = 'run'
  end
end

function Player:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:move(dt)
  if love.keyboard.isDown("d", "right") then
    self.xVel = math.min(self.xVel + self.accel * dt, self.maxSpeed)
-- Sets the direction player's facing
    self.direction = 'right'
  elseif love.keyboard.isDown("a", "left") then
    self.xVel = math.max(self.xVel - self.accel * dt, -self.maxSpeed)
-- Sets the direction player's facing
    self.direction = "left"

  else
    self:applyFriction(dt)
  end
end

function Player:applyFriction(dt)
  if self.xVel > 0 then
    self.xVel = math.min(self.xVel - self.friction * dt, 0)
  elseif self.xVel < 0 then
    self.xVel = math.max(self.xVel + self.friction * dt, 0)
  end
end

function Player:apllyGravity(dt)
  if not self.grounded then
    self.yVel = self.yVel + self.gravity * dt
  end
end

function Player:beginContact(a, b, clsnObj)
  if self.grounded == true then return end
  local nx, ny = clsnObj:getNormal()
    if a == self.physics.fixture then
      if ny > 0 then
        self:land(clsnObj)
      elseif ny < 0 then
        self.yVel = 0
      end
    elseif b == self.physics.fixture then
      if ny < 0 then
        self:land(clsnObj)
      elseif ny > 0 then
        self.yVel = 0
      end
    end
end

function Player:endContact(a, b, clsnObj)
  if a == self.physics.fixture or b == self.physics.fixture then
    if self.currentGroundCollision == clsnObj then
      self.grounded = false
    end
  end
end

function Player:land(clsnObj)
  self.currentGroundCollision = clsnObj
  self.yVel = 0
  self.grounded = true
  self.hasJumps = 2
end

function Player:jump(key)
  if key == 'w' or key == 'up' then
    if self.hasJumps == 2 then
      self.yVel = self.jumpAmmount
      self.hasJumps = 1
    elseif self.hasJumps == 1 then
      self.yVel = self.jumpAmmount
      self.hasJumps = 0
    end
  end
end

function Player:incrementCoins()
   self.coins = self.coins + 1
end

function Player:takeDamage(dmg)
  if self.health.current - dmg > 0 then
    self.health.current = self.health.current - 1
    self:tintRed()
  else 
    self.health.current = 0
    self.alive = false
  end
end

function Player:respawn()
  if not self.alive then
    self.physics.body:setPosition(self.startX, self.startY)
    self.health.current = self.health.max
    self.alive = true
  end
end

function Player:tintRed()
  self.color.blue = 0
  self.color.green = 0
end

function Player:unTint(dt)
  self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
  self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

return Player