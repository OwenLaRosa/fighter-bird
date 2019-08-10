Enemy = Class{}

function Enemy:init(def)
    self.type = def.type
    self.health = def.health
    self.speed = def.speed
    self.damage = def.damage
    self.projectileSpeed = def.projectileSpeed
    self.fireInterval = def.fireInterval
    self.spawnPowerup = def.spawnPowerup
    self.sprayMin = def.sprayMin
    self.sprayMax = def.sprayMax

    self.x = VIRTUAL_WIDTH + 64
    self.y = VIRTUAL_HEIGHT/2

    self.width = 20
    self.height = 20

    self.remove = false

    self.readyToFire = false
    self.fireTimer = 0
end

function Enemy:update(dt)
    self.x = self.x - self.speed * dt
    self.fireTimer = self.fireTimer + dt
    if self.fireTimer >= self.fireInterval then
        self.fireTimer = 0
        self.readyToFire = true
    end
    if self.x < 0 then
        self.remove = true
    end
end

function Enemy:render()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 255)
end
