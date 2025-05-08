sa_scoreLimit = 15

function BeginShuffleArenaGame()
    GameLoop_SelectedGameMode = GAME_MODE_SHUFFLE

    -- Create selection units
    local timer = CreateTimer()
    TimerStart(timer, 1.60, false, function()

        if udg_IsDevelopment then
            for i=1,4 do
                local player = Player(i - 1)                
                local loc = GetRectCenter(gg_rct_GladiatorHeroSelectWispSpawn)
                local unit = CreateUnitAtLoc(player, FourCC('e000'), loc, 0)
                sa_Score[i] = 0
                RemoveLocation(loc)
            end
        else
            for i=1,24 do
                local player = Player(i - 1)
                
                if GetPlayerController(player) == MAP_CONTROL_USER then
                    local loc = GetRectCenter(gg_rct_GladiatorHeroSelectWispSpawn)
                    local unit = CreateUnitAtLoc(player, FourCC('e000'), loc, 0)
                    sa_Score[i] = 0
                    RemoveLocation(loc)
                end
            end
        end
    end)    

    local timer = CreateTimer()
    TimerStart(timer, glGameStartDelayDuration, false, function()
        DestroyTimer(timer)
        ShuffleArena_InitialCountDownEnd()
    end)

    ConditionalTriggerExecute(gg_trg_ShuffleLeaderboardCreation)
    --EnableTrigger(gg_trg_ShuffleLeaderboardUpdate)
end

function ShuffleArena_InitialCountDownEnd()    
    ShuffleArena_BeginRoundCountdown()
end

function ShuffleArena_BeginRoundCountdown()
    ShuffleArena_BeginIntermissionTimer("Next Fight: ", glIntermissionDuration, function()
        return false
    end, function()
        ShuffleArena_BeginRound()
    end)
end

function ShuffleArena_BeginRound()
    glIsInFight = true
    
    ShuffleArena_ShuffleTeams()

    ShuffleArena_SetGladiatorUnitsToFight()
    ShuffleArena_MoveGladiatorUnitsToArena()
    
    -- revoke mana after units spawned. Unit spawn function checks for remaining mana
    BattleRoyale_Begin()
    -- reset damage meter?
    --DamageMeter_Reset()
end

function ShuffleArena_TeamAVictory()
    for i = 1, #sa_TeamA do
        local hero = sa_TeamA[i]
        local player = GetOwningPlayer(hero)
        GameLoop_AddGoldToPlayer(player, GameLoop_Gladiators_GoldOnGreed)
        local targetScore = sa_Score[GetPlayerId(player) + 1] + 1
        sa_Score[GetPlayerId(player) + 1] = targetScore
    end
    for i = 1, #sa_TeamB do
        local hero = sa_TeamB[i]
        local player = GetOwningPlayer(hero)
        GameLoop_AddGoldToPlayer(player, GameLoop_Gladiators_GoldOnNeed)
    end
    ShuffleArena_EndRound()
end

function ShuffleArena_TeamBVictory()
    for i = 1, #sa_TeamA do
        local hero = sa_TeamA[i]
        local player = GetOwningPlayer(hero)
        GameLoop_AddGoldToPlayer(player, GameLoop_Gladiators_GoldOnNeed)
    end
    for i = 1, #sa_TeamB do
        local hero = sa_TeamB[i]
        local player = GetOwningPlayer(hero)
        GameLoop_AddGoldToPlayer(player, GameLoop_Gladiators_GoldOnGreed)
        local targetScore = sa_Score[GetPlayerId(player) + 1] + 1
        sa_Score[GetPlayerId(player) + 1] = targetScore
    end
    ShuffleArena_EndRound()
end

function ShuffleArena_GetScore(player)
    local index = GetPlayerId(player) + 1
    return sa_Score[index]
end

function ShuffleArena_EndRound()
    glIsInFight = false
    glRoundIndex = glRoundIndex + 1
    glPhaseRoundIndex = glPhaseRoundIndex + 1

    ShuffleArena_SetGladiatorsStateToRest()
    DelayedCallback(2.0, ShuffleArena_MoveGladiatorUnitsToRest)

    ResolveRoundCooldown()
    BattleRoyale_End()

    local hasWinner = false
    for i = 1, 24 do
        local score = sa_Score[i]
        if score >= sa_scoreLimit then
            hasWinner = true
            break
        end
    end
    if hasWinner then
        ShuffleArena_EndGame()
        return
    end

    ShuffleArena_BeginRoundCountdown()    
end

function ShuffleArena_EndGame()
    DelayedCallback(3.5, function()
        for i = 1, 24 do
            local playerId = i - 1
            local player = Player(playerId)
            local score = sa_Score[i]
    
            if score > sa_scoreLimit then
                CustomVictoryDialogBJ(player)
            else
                CustomDefeatDialogBJ(player, "noob")
            end
        end
    end)    
end
