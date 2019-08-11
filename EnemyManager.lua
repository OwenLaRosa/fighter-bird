EnemyManager = Class{}

function EnemyManager:init()
    self.enemies = {}
    self.projectiles = {}

    self.spawnInterval = 0.5
    self.lastSpawnedEnemy = 0

    self.aircraftImage = love.graphics.newImage('aircraft.png')
    self.saucerImage = love.graphics.newImage('saucer.png')
    self.healthPowerupImage = love.graphics.newImage('health_powerup.png')
end

function EnemyManager:update(dt)
    self.lastSpawnedEnemy = self.lastSpawnedEnemy + dt
    if self.lastSpawnedEnemy > self.spawnInterval then
        self.lastSpawnedEnemy = 0
        if math.random(10) == 1 then
            -- lucky player, spawn saucer
            table.insert(self.enemies, Enemy({
                type = "saucer",
                health = 20,
                speed = 100,
                damage = 12,
                points = 500,
                projectileSpeed = 130,
                fireInterval = 1,
                sprayMin = -400,
                sprayMax = 400,
                image = self.saucerImage,
                width = 60,
                height = 20,
                projectileColor = {255, 0, 255, 255},
                projectileSound = "saucer-shoot",
                powerup = Powerup({
                    property = "health",
                    value = 25,
                    image = self.healthPowerupImage
                })
            }))
        else
            -- spawn aircraft
            table.insert(self.enemies, Enemy({
                type = "aircraft",
                health = 10,
                speed = 130,
                damage = 9,
                points = 150,
                projectileSpeed = 100,
                fireInterval = 1.2,
                sprayMin = 0,
                sprayMax = 0,
                image = self.aircraftImage,
                width = 62,
                height = 32,
                projectileColor = {255, 255, 0, 255},
                projectileSound = "aircraft-shoot"
            }))
        end
    end

    for k, object in pairs(self.enemies) do
        object:update(dt)
        self:fire(object)
        if object.remove then
            table.remove(self.enemies, k)
        end
    end
    for k, object in pairs(self.projectiles) do
        object:update(dt)
        if object.remove then
            table.remove(self.projectiles, k)
        end
    end
end

function EnemyManager:render()
    for k, object in pairs(self.enemies) do
        object:render()
    end
    for k, object in pairs(self.projectiles) do
        object:render()
    end
end

function EnemyManager:fire(enemy)
    if enemy.readyToFire then
        table.insert(self.projectiles, Projectile({
            startX = enemy.x,
            startY = enemy.y,
            endX = 0,
            endY = enemy.y + math.random(enemy.sprayMin, enemy.sprayMax),
            speed = enemy.speed + enemy.projectileSpeed,
            damage = enemy.damage,
            color = enemy.projectileColor
        }))
        sounds[enemy.projectileSound]:play()
        enemy.readyToFire = false
    end
end