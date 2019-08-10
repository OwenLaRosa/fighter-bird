EnemyManager = Class{}

function EnemyManager:init()
    self.enemies = {}
    self.projectiles = {}

    self.spawnInterval = 1
    self.lastSpawnedEnemy = 0
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
                speed = 60,
                damage = 12,
                points = 500,
                projectileSpeed = 130,
                fireInterval = 1,
                sprayMin = -400,
                sprayMax = 400
            }))
        else
            -- spawn aircraft
            table.insert(self.enemies, Enemy({
                type = "aircraft",
                health = 10,
                speed = 100,
                damage = 9,
                points = 150,
                projectileSpeed = 100,
                fireInterval = 1.2,
                sprayMin = 0,
                sprayMax = 0
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
        table.insert(self.projectiles, Projectile(enemy.x, enemy.y, 0, enemy.y + math.random(enemy.sprayMin, enemy.sprayMax), enemy.speed + enemy.projectileSpeed, enemy.damage))
        enemy.readyToFire = false
    end
end