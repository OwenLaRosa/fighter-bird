Powerup = Class{}

function Powerup:init(def)
    self.property = def.property
    self.value = def.value
    self.image = def.image

    -- set with enemy's position after it's been defeated
    self.x = 0
    self.y = 0

    self.speed = PIPE_SPEED -- should appear stationary
    self.width = 24
    self.height = 24

    self.remove = false
end

function Powerup:update(dt)
    self.x = self.x - self.speed * dt
    if self.x < 0 then
        self.remove = true
    end
end

function Powerup:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Powerup:collides(object)
    return not (self.x + self.width < object.x or self.x > object.x + object.width or
                self.y + self.height < object.y or self.y > object.y + object.height)
end
