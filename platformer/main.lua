love.graphics.setDefaultFilter('nearest', 'nearest')

local STI = require 'sti'
local Player = require('player')
local Coin = require('coin')
local GUI = require('gui')
local Spike = require('spike')
local Camera = require("camera")
local Stone = require('stone')

function love.load()
  Map = STI('map/1.lua', {'box2d'})
  MapWidth = Map.layers.ground.width * 16
  World = love.physics.newWorld(0, 0)
  World:setCallbacks(beginContact, endContact)
  Map:box2d_init(World)
  Map.layers.solid.visible = false
  Background = love.graphics.newImage('assets/background.png')
  Player:load()
  GUI:load()
  Coin.new(300,200)
  Coin.new(400, 200)
	Coin.new(500, 100)
  Spike.new(500, 325)
  Stone.new(400, 310)
end

function love.update(dt)
  World:update(dt)
  Player:update(dt)
  Coin.updateAll(dt)
  Spike.updateAll(dt)
  Stone.updateAll(dt)
  GUI:update(dt)
  Camera:setPosition(Player.x, 0)
end

function love.draw()
  love.graphics.draw(Background)
  Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

	Camera:apply()
  Player:draw()
  Coin.drawAll()
  Spike.drawAll()
  Stone.drawAll()
	Camera:clear()

  GUI:draw()
end

function love.keypressed(key)
  Player:jump(key)
end

function beginContact(a, b, clsnObj)
if Coin.beginContact(a, b, clsnObj) then return end
if Spike.beginContact(a, b, clsnObj) then return end
  Player:beginContact(a, b, clsnObj)
end

function endContact(a, b, clsnObj)
  Player:endContact(a, b, clsnObj)
end
