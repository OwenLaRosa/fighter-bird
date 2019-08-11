--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.enemiesDefeated = 0

    self.enemyManager = EnemyManager()
    self.powerups = {}

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    -- number of seconds after the last pipe pair spawned, in which to spawn the next pair
    self.lastPipeDuration = 2
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- spawn a new pipe pair every second and a half
    if self.timer > self.lastPipeDuration then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = 0
        -- makes the pipes appear at a varied distance apart
        self.lastPipeDuration = 2 + math.random(-0.25, 0.25)
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 100
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if pipe.collidable and self.bird:collides(pipe) then
                sounds['shock']:play()
                pipe.collidable = false

                self.bird.health = self.bird.health - 10
                self:checkGameOver()
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- update enemies and projectiles
    self.enemyManager:update(dt)

    for k, projectile in pairs(self.bird.projectiles) do
        projectile:update(dt)
        for j, enemy in pairs(self.enemyManager.enemies) do
            if projectile:collides(enemy) then
                sounds['enemy-hit']:play()
                enemy.health = enemy.health - projectile.damage
                if enemy.health <= 0 then
                    table.remove(self.bird.projectiles, k)
                    -- birds can kill enemies with a cheap shot (overlapping) but powerups are only awarded if fired at a distance
                    if enemy.powerup ~= nil and enemy:collides(self.bird) == false then
                        enemy.powerup.x = enemy.x
                        enemy.powerup.y = enemy.y
                        table.insert(self.powerups, enemy.powerup)
                    end
                    table.remove(self.enemyManager.enemies, j)
                    self.score = self.score + enemy.points
                    self.enemiesDefeated = self.enemiesDefeated + 1
                end
            end
        end

        if projectile.remove then
            table.remove(self.bird.projectiles, k)
        end
    end

    for k, projectile in pairs(self.enemyManager.projectiles) do
        if projectile:collides(self.bird) then
            sounds['bird-hit']:play()
            self.bird.health = self.bird.health - projectile.damage
            table.remove(self.enemyManager.projectiles, k)
            self:checkGameOver()
        end
    end

    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)
        if powerup:collides(self.bird) then
            if powerup.property == "health" then
                sounds["health-powerup"]:play()
                self.bird.health = math.min(100, self.bird.health + powerup.value)
            end
            table.remove(self.powerups, k)
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score,
            enemiesDefeated = self.enemiesDefeated
        })
    end
end

function PlayState:checkGameOver()
    if self.bird.health <= 0 then
        gStateMachine:change('score', {
            score = self.score,
            enemiesDefeated = self.enemiesDefeated
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.print('Health: ' .. tostring(self.bird.health), VIRTUAL_WIDTH/2, 8)

    self.bird:render()
    self.enemyManager:render()
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end