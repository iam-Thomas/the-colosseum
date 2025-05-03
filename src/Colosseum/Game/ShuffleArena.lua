RegInit(function()
    GameLoop_SelectorUnit_Hashtable = InitHashtable()

    -- Create selection units
    local timer = CreateTimer()
    TimerStart(timer, 1.60, false, function()
        ForForce(udg_GameMasterPlayers, function()
            local player = GetEnumPlayer()
            local loc = GetRectCenter(gg_rct_TechSelectSpawnWisp)
            local unit = CreateUnitAtLoc(player, FourCC('h00R'), loc, 0)
            table.insert(GameLoop_SelectorUnits, unit)
            RemoveLocation(loc)
        end)
        DestroyTimer(timer)

        ForForce(udg_GladiatorPlayers, function()
            local player = GetEnumPlayer()
            local loc = GetRectCenter(gg_rct_GladiatorHeroSelectWispSpawn)
            local unit = CreateUnitAtLoc(player, FourCC('e000'), loc, 0)
            table.insert(GameLoop_HeroSelectorUnits, unit)
            RemoveLocation(loc)
        end)
    end)    

    local timer = CreateTimer()
    TimerStart(timer, glGameStartDelayDuration, false, function()
        DestroyTimer(timer)
        ShuffleArena_InitialCountDownEnd()
    end)

    udg_GladiatorLives = 2
    GameLoop_GrantLifeToGladiator()
end)

function ShuffleArena_InitialCountDownEnd()
    --Create a dummy phase to signal that the game masters have to select a phase
    GMCurrentPhase = {
        evaluateState = function(roundIndex, phaseRoundIndex)
            return {
                IsTransitionFight = true,
                IsBossFight = false,
            }
        end
    }
    
    ShuffleArena_BeginRoundCountdown()
end

function ShuffleArena_BeginRoundCountdown()
    local eval = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)

    if eval.IsTransitionFight then
        glIsInPhaseTransition = true
        -- Clear everything, create transition adds
        GMSelections_CreateTransitionUnits()
        GameLoop_GrantSelectionsMana()

        GameLoop_BeginIntermissionTimer("Next phase: ", glPhaseStartDelayDuration, function()
            -- local evalState = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)
            -- return not evalState.IsTransitionFight
            return false
        end, function()
            local evalState = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)
            if evalState.IsTransitionFight then
                GMSelections_PickRandomTransitionUnit()
            end
        end)

        GameLoop_GrantLifeToGladiator()

        return
    end

    -- Reset selections for the fight, so that players can select new units
    GMSelections_ResetForFight()

    -- Grant mana to select units
    -- TODO: This call does not grant mana to the players after the 'selections phase' ?!?!?
    GameLoop_GrantSelectionsMana()    

    if eval.IsBossFight then
        GMSelections_MakeBossGroupsVulnerable()
    else
        GMSelections_MakeBossGroupsInvulnerable()
    end

    GameLoop_BeginIntermissionTimer("Next Fight: ", glIntermissionDuration, function()
        return false
    end, function()
        ShuffleArena_BeginRound()
    end)
end

function ShuffleArena_BeginRound()
    glIsInFight = true
    
    GameLoop_SetGladiatorUnitsToFight()
    GameLoop_MoveGladiatorUnitsToArena()
    GameLoop_SpawnUnits()
    -- revoke mana after units spawned. Unit spawn function checks for remaining mana
    GameLoop_RevokeSelectionsMana()
    GMSelections_CleanDraftDisplayUnits()
    BattleRoyale_Begin()
    -- reset damage meter?
    DamageMeter_Reset()
end

function ShuffleArena_GameMastersVictory()
    GameLoop_TakeGladiatorLife()
    if GameLoop_GladiatorsLivesLeft() <= 0 then
        GameLoop_GameMastersWinGame()
    else
        ShuffleArena_EndRound()
    end    
end

function ShuffleArena_GladiatorsVictory()
    ShuffleArena_EndRound()
end

function ShuffleArena_EndRound()
    glIsInFight = false
    glRoundIndex = glRoundIndex + 1
    glPhaseRoundIndex = glPhaseRoundIndex + 1
    local state = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)

    if state.IsFinal then
        GameLoop_GladiatorsWinGame()        
        return
    end

    if state.IsTransitionFight then
        glPhaseIndex = glPhaseIndex + 1
    end

    ForForce(udg_GameMasterPlayers, function()
        local player = GetEnumPlayer()
        if state.IsTransitionFight then
            GameBalanceTrigger_AddScaling(player, 1.10, 0.5, 0.5)
        else
            GameBalanceTrigger_AddScaling(player, 0.10, 0.05, 0.05)
        end
    end)

    GameLoop_SetGladiatorsStateToRest()
    DelayedCallback(2.0, GameLoop_MoveGladiatorUnitsToRest)
    DelayedCallback(2.0, function()
        ForGroup(udg_GameMasterUnits, function()
            local unit = GetEnumUnit()
            if IsUnitAliveBJ(unit) then
                KillUnit(unit)
            end
        end)
        GroupClear(udg_GameMasterUnits)
    end)
   
    ForGroup(udg_GameMasterUnits, function()
        local unit = GetEnumUnit()
        KillUnit(unit)
    end)

    ShuffleArena_BeginRoundCountdown()
    
    BattleRoyale_End()
    ResolveRoundCooldown()
end
