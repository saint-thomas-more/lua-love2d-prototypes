Ball = {}

function Ball:load()
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2
  self.width = 20
  self.height = 20
  self.speed = 200
  self.xVel = -self.speed
  self.yVel = 0
end

function Ball:update(dt)
  self:move(dt)
  self:collide()
  self:scored()
end


function Ball:draw()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:move(dt)
  self.x = self.x + self.xVel * dt
  self.y = self.y + self.yVel * dt
end

function Ball:collide()
 self:collidePlayer()
 self:collideWalls()
 self:collideAI()
end

function Ball:collidePlayer()
   if checkCollision(self, Player) then
    self.xVel = self.speed
    local midPlayer = Player.y + Player.height / 2
    local midBall = self.y + self.height / 2
    local collisionPosition = midBall - midPlayer
    self.yVel = collisionPosition * 5
  end
end

function Ball:collideAI()
  if checkCollision(self, AI) then
    self.xVel = -self.speed
    local midAI = AI.y + AI.height / 2
    local midBall = self.y + self.height / 2
    local collisionPosition = midBall - midAI
    self.yVel = collisionPosition * 5
  end
end

function Ball:collideWalls()
   if self.y < 0 then
    self.y = 0
    self.yVel = -self.yVel
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height
    self.yVel = -self.yVel
  end
end

function Ball:scored()
  if self.x + self.width < 0 then
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.yVel = 0
    self.xVel = -self.speed
  elseif self.x > love.graphics.getWidth() then
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.yVel = 0
    self.xVel = -self.speed
  end
end