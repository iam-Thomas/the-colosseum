function GameLoop_GameMastersWinGame()
    ForForce(udg_GladiatorPlayers, function()
        local player = GetEnumPlayer()
        CustomDefeatDialogBJ(player, "Defeated!")
    end)

    ForForce(udg_GameMasterPlayers, function()
        local player = GetEnumPlayer()
        CustomVictoryDialogBJ(player)
    end)
end

function GameLoop_GladiatorsWinGame()
    ForForce(udg_GladiatorPlayers, function()
        local player = GetEnumPlayer()
        CustomVictoryDialogBJ(player)
    end)

    ForForce(udg_GameMasterPlayers, function()
        local player = GetEnumPlayer()
        CustomDefeatDialogBJ(player, "Defeated!")
    end)
end

function GameLoop_TakeGladiatorLife()
    udg_GladiatorLives = udg_GladiatorLives - 1
    print("Gladiator lives left: " .. udg_GladiatorLives)
end

function GameLoop_GrantLifeToGladiator()
    udg_GladiatorLives = udg_GladiatorLives + 1
    print("Gladiator lives left: " .. udg_GladiatorLives)
end

function GameLoop_GladiatorsLivesLeft()
    return udg_GladiatorLives
end