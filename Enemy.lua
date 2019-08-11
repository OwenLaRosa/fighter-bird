Enemy = Class{}

function Enemy:init(def)
    self.type = def.type
    self.health = def.health
    self.speed = def.speed
    self.damage = def.damage
    self.points = def.points
    self.projectileSpeed = def.projectileSpeed
    self.fireInterval = def.fireInterval
    self.powerup = def.powerup
    self.sprayMin = def.sprayMin
    self.sprayMax = def.sprayMax
    self.width = def.width
    self.height = def.height
    self.image = def.image
    self.projectileColor = def.projectileColor
    self.projectileSound = def.projectileSound

    self.x = VIRTUAL_WIDTH + 64
    self.y = VIRTUAL_HEIGHT/2 - self.height/2 + math.random(-70, 70)

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

-- used to check for collisions with the bird
function Enemy:collides(object)
    return not (self.x + self.width < object.x or self.x > object.x + object.width or
                self.y + self.height < object.y or self.y > object.y + object.height)
end

function Enemy:render()
    love.graphics.draw(self.image, self.x, self.y, 0, 2, 2)
end
