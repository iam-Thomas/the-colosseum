glGameStartDelayDuration = 45.00
glPhaseStartDelayDuration = 45.00
glIntermissionDuration = 45.00

glStarted = false
glIsInFight = false
glPhaseIndex = 1
glRoundIndex = 0
glPhaseRoundIndex = 0
glIsInPhaseTransition = false

glSquadSelectionZones = nil
glSquadSelectionGroups = nil
glSquadSelectionGroupRarityEffects = nil
glBossSelectionZones = nil
glBossSelectionGroups = nil
--    PanCameraToTimedLocForPlayer(owner, loc, 0.0)

--GameLoop_Trigger_InitialCountdown = nil
GameLoop_SelectorUnits = {}
GameLoop_SelectorUnits_CurrentIndex = 0
GameLoop_HeroSelectorUnits = {}

GameLoop_Gladiators_GoldOnGreed = 250
GameLoop_Gladiators_GoldOnNeed = 125
--GameLoop_Gladiators_GoldLossOnDeath = 200
GameLoop_GladiatorsGreedyness = {}

GAME_MODE_SURVIVAL = 0
GAME_MODE_SHUFFLE = 1
GameLoop_SelectedGameMode = GAME_MODE_SURVIVAL

function BeginGame()
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
        GameLoop_InitialCountDownEnd()
    end)

    glSquadSelectionZones = {
        gg_rct_TechSelect1,
        gg_rct_TechSelect2,
        gg_rct_TechSelect3,
        gg_rct_TechSelect4
    }

    glSquadSelectionGroups = {
        CreateGroup(), CreateGroup(), CreateGroup(),
        CreateGroup(), CreateGroup(), CreateGroup(),
    }

    glSquadSelectionGroupRarityEffects = {
        nil, nil, nil, nil, nil, nil
    }

    glBossSelectionZones = {
        gg_rct_TechSelectBoss1,
        gg_rct_TechSelectBoss2,
        gg_rct_TechSelectBoss3,
        gg_rct_TechSelectBoss4
    }

    glBossSelectionGroups = {
        CreateGroup(), CreateGroup(), CreateGroup(),
        CreateGroup(), CreateGroup(),
    }

    udg_GladiatorLives = 2
    GameLoop_GrantLifeToGladiator()
end

function GameLoop_InitialCountDownEnd()
    --Create a dummy phase to signal that the game masters have to select a phase
    GMCurrentPhase = {
        evaluateState = function(roundIndex, phaseRoundIndex)
            return {
                IsTransitionFight = true,
                IsBossFight = false,
            }
        end
    }
    
    GameLoop_BeginRoundCountdown()
end

function GameLoop_BeginRoundCountdown()
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
        GameLoop_BeginRound()
    end)
end

function GameLoop_BeginRound()
    glIsInFight = true
    
    GameLoop_SetGladiatorUnitsToFight(false)
    GameLoop_MoveGladiatorUnitsToArena()
    GameLoop_SpawnUnits()
    -- revoke mana after units spawned. Unit spawn function checks for remaining mana
    GameLoop_RevokeSelectionsMana()
    GMSelections_CleanDraftDisplayUnits()
    BattleRoyale_Begin()
    -- reset damage meter?
    DamageMeter_Reset()
end

function GameLoop_GameMastersVictory()
    GameLoop_TakeGladiatorLife()
    if GameLoop_GladiatorsLivesLeft() <= 0 then
        GameLoop_GameMastersWinGame()
    else
        GameLoop_EndRound()
    end    
end

function GameLoop_GladiatorsVictory()
    GameLoop_EndRound()
end

function GameLoop_EndRound()
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
            GameBalanceTrigger_AddScaling(player, 1.30, 0.5, 0.5)
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

    GameLoop_BeginRoundCountdown()
    
    BattleRoyale_End()
    ResolveRoundCooldown()
end