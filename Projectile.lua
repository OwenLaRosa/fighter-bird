Projectile = Class{}

function Projectile:init(startX, startY, endX, endY, speed)
    self.startX = startX
    self.startY = startY
    self.endX = endX
    self.endY = endY
    self.speed = speed
    if endX < startX then
        self.speed = -self.speed
    end

    self.slope = (self.endY - self.startY) / (self.endX - self.startX)
    self.inverseSlope = 1 / self.slope

    self.x = startX
    self.y = startY

    self.width = 12
    self.height = 2

    self.length = 12
    self.lineWidth = 2

    local angle = math.atan(self.slope)
    self.xLength = self.length * math.cos(angle)
    self.yLength = self.length * math.sin(angle)

    self.remove = false
end

function Projectile:update(dt)
    self.x = self.x + self.speed * dt
    self.y = self.y + self.speed * dt * 1 / self.inverseSlope

    if (self.startX < self.endX and self.x > self.endX) or (self.startX > self.endX and self.x + self.xLength < self.endX) then
        self.remove = true
    elseif (self.startY < self.endY and self.y > self.endY) or (self.startY > self.endY and self.y + self.yLength < self.endY) then
        self.remove = true
    end
end

function Projectile:render()
    love.graphics.setColor(223, 223, 0, 255)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.line(self.x, self.y, self.x + self.xLength, self.y + self.yLength)
    love.graphics.setColor(255, 255, 255, 255)
end