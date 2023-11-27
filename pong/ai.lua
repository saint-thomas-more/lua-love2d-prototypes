AI = {}
local cntctPnt = 0
local agilityCounter = 0
local r = 0
function AI:load()
  self.width = 20
  self.height = 100
  self.x = love.graphics.getWidth() - self.width - 50
  self.y = love.graphics.getHeight() / 2
  self.yVel = 0
  self.speed = 500
  -- for Contact point
  self.timer = 0
  self.rate = 0.05
  -- for
end

function AI:update(dt)
  self:seekBall()
  self:move(dt)
  self:chechBoundaries()
  self.timer = self.timer + dt
  self:createContactPoint()
  self:randomAgility()
end
function AI:draw()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function AI:move(dt)
  self.y = self.y + self.yVel * dt
end

function AI:chechBoundaries()
  if self.y < 0 then
    self.y = 0
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height
  end
end
function AI:seekBall()
 if self.y + self.height < cntctPnt then
    self.yVel = self.speed
  elseif self.y > cntctPnt + Ball.height then
    self.yVel = -self.speed
  else
    self.yVel = 0
  end
end
function AI:createContactPoint()
   if self.timer > self.rate then
    self.timer = 0
    cntctPnt = Ball.y
   agilityCounter = agilityCounter + 1
  end
end

function AI:randomAgility()
  if agilityCounter > 10 then
    local rnd = math.random(-10, 10) * 0.001
    print('rnd = ' .. rnd)
    self.rate = 0.05 + rnd
    agilityCounter = 0
    print('rate =  ' .. self.rate)
  end
end