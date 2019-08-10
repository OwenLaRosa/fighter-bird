--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.enemiesDefeated = params.enemiesDefeated
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 70, VIRTUAL_WIDTH, 'center')

    -- display a medal (if any) for the player's performance
    medalImage = nil
    if self.score >= 1000 then
        medalImage = love.graphics.newImage("flawless_flapper.png")
    elseif self.score >= 5000 then
        medalImage = love.graphics.newImage("happy_bird.png")
    elseif self.score >= 10000 then 
        medalImage = love.graphics.newImage("lame_duck.png")
    end
    if self.enemiesDefeated >= 5 then
        love.graphics.printf('Kills: ' .. tostring(self.enemiesDefeated .. ' - ' .. math.floor(self.enemiesDefeated/5) .. 'x Ace'), 0, 200, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Kills: ' .. tostring(self.enemiesDefeated), 0, 200, VIRTUAL_WIDTH, 'center')
    end

    if medalImage ~= nil then
        love.graphics.draw(medalImage, VIRTUAL_WIDTH / 2 - 64, VIRTUAL_HEIGHT / 2 - 64, 0, 1, 1)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 230, VIRTUAL_WIDTH, 'center')
end