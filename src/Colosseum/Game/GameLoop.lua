glGameStartDelayDuration = 15.00
glIntermissionDuration = 15.00

glCountdownTimer = nil
glCountdownTimerDialog = nil

glStarted = false
glIsInFight = false
glPhaseIndex = 1
glRoundIndex = 1
glPhaseRoundIndex = 1
glIsInPhaseTransition = false

glSquadSelectionZones = nil
glSquadSelectionGroups = nil
glBossSelectionZones = nil
glBossSelectionGroups = nil
--    PanCameraToTimedLocForPlayer(owner, loc, 0.0)

GameLoop_Trigger_InitialCountdown = nil
GameLoop_SelectorUnits = {}
GameLoop_SelectorUnits_CurrentIndex = 0

GameLoop_Gladiators_GoldOnGreed = 200
GameLoop_Gladiators_GoldOnNeed = 100
--GameLoop_Gladiators_GoldLossOnDeath = 200
GameLoop_GladiatorsGreedyness = {}

RegInit(function()
    GameLoop_SelectorUnit_Hashtable = InitHashtable()

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
    end)    

    GameLoop_Trigger_InitialCountdown = CreateTrigger()
    TriggerAddAction(GameLoop_Trigger_InitialCountdown, GameLoop_InitialCountDownEnd)
    TriggerRegisterTimerEventSingle(GameLoop_Trigger_InitialCountdown, glGameStartDelayDuration)

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
end)

function GameLoop_InitialCountDownEnd()
    glCountdownTimer = CreateTimer()

    GMSelections_PhaseChange(GetPhaseBandits())
    
    GameLoop_BeginRoundCountdown()
end

function GameLoop_BeginRoundCountdown()
    local eval = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)
    if eval.IsTransitionFight then
        glIsInPhaseTransition = true
        -- Clear everything, create transition adds
        GMSelections_ClearAll()
        print("game loop: begin create trnasition units")
        GMSelections_CreateTransitionUnits()
        GameLoop_GrantSelectionsMana()
        return
    end

    -- Reset selections for the fight, so that players can select new units
    GMSelections_ResetForFight()

    -- Grant mana to select units
    GameLoop_GrantSelectionsMana()    

    if eval.IsBossFight then
        GMSelections_MakeBossGroupsVulnerable()
    else
        GMSelections_MakeBossGroupsInvulnerable()
    end

    TimerStart(glCountdownTimer, glIntermissionDuration, false, GameLoop_BeginRound)
    glCountdownTimerDialog = CreateTimerDialog(glCountdownTimer)
    TimerDialogSetTitle(glCountdownTimerDialog, "Next Fight: ")
    TimerDialogDisplay(glCountdownTimerDialog, true)
end

function GameLoop_GrantSelectionsMana()
    local nGameMasterPlayers = CountPlayersInForceBJ(udg_GameMasterPlayers)
    local nManaToGrant = CountPlayersInForceBJ(udg_GladiatorPlayers)
    local nManaLeftToGrant = nManaToGrant

    -- First, set the mana of all units to 0
    for i = 1, #GameLoop_SelectorUnits do
        local unit = GameLoop_SelectorUnits[i]
        SetUnitState(unit, UNIT_STATE_MANA, 0)
    end

    -- Then, grant mana to all units
    while (nManaLeftToGrant > 0) do
        local index = ModuloInteger(GameLoop_SelectorUnits_CurrentIndex, nGameMasterPlayers)
        local unit = GameLoop_SelectorUnits[index + 1]

        local mana = GetUnitState(unit, UNIT_STATE_MANA)
        local targetMana = mana + 1
        SetUnitState(unit, UNIT_STATE_MANA, targetMana)

        GameLoop_SelectorUnits_CurrentIndex = GameLoop_SelectorUnits_CurrentIndex + 1
        nManaLeftToGrant = nManaLeftToGrant - 1
    end
end

function GameLoop_RevokeSelectionsMana()
    for i = 1, #GameLoop_SelectorUnits do
        local unit = GameLoop_SelectorUnits[i]
        SetUnitState(unit, UNIT_STATE_MANA, 0)
    end
end

function GameLoop_BeginRound()
    TimerDialogDisplay(glCountdownTimerDialog, false)

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

function GameLoop_SpawnUnits()
    -- if any mana remains, random groups will be selected.
    for i = 1, #GameLoop_SelectorUnits do
        local selectorUnit = GameLoop_SelectorUnits[i]
        local manaRemain = GetUnitState(selectorUnit, UNIT_STATE_MANA)
        local nGroups = math.floor(manaRemain + 0.5)

        if nGroups > 0 then
            for i = 1, nGroups do

                local owner = GetOwningPlayer(selectorUnit)
                GMSelections_PickRandomGroup_CommonRare(GMCurrentPhase.groups, function(unitType, nOfType)
                    local playerId = GetPlayerId(owner)
                    for i = 1, nOfType do
                        table.insert(glPlayerSelections[playerId + 1], unitType)
                    end
                end)
            end
        end
    end

    -- spawn units
    for i = 1, #glPlayerSelections do
        local owner = Player(i - 1)
        local unitIdList = glPlayerSelections[i]

        for j = 1, #unitIdList do
            local unitId = unitIdList[j]

            local pointValue = GetUnitPointValueByType(unitId)
            local pointString = tostring(pointValue)
            local spawnChar = string.sub(pointString, -2, -2)

            local spawnLoc = nil
            if spawnChar == "1" then
                spawnLoc = GetRandomLocInRect(gg_rct_KingOfTheHillNorthCenterRegion)
            else
                spawnLoc = GetRectCenter(gg_rct_KingOfTheHillGMStart)
            end
            
            local unit = CreateUnitAtLoc(owner, unitId, spawnLoc, 0)
            GroupAddUnit(udg_GameMasterUnits, unit)
            RemoveLocation(spawnLoc)
        end
    end

    local remainingManaSum = 0
    for i = 1, #GameLoop_SelectorUnits do
        local unit = GameLoop_SelectorUnits[i]
        local manaRemain = GetUnitState(unit, UNIT_STATE_MANA)
        remainingManaSum = remainingManaSum + math.floor(manaRemain + 0.5)
    end
end

function GameLoop_SetGladiatorUnitsToFight()
    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        SetUnitInvulnerable(unit, false)
        UnitResetCooldown(unit)
        SetUnitManaPercentBJ(unit, 100)
    end)
end

function GameLoop_MoveGladiatorUnitsToArena()
    local point = GetRectCenter(gg_rct_KingOfTheHillGladiatorStart)

    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        local owner = GetOwningPlayer(unit)
        local playerIndex = GetPlayerId(owner)
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        if (RectContainsUnit(gg_rct_GladiatorGreedRegion, unit)) then                
            GameLoop_GladiatorsGreedyness[playerIndex] = true
        elseif (RectContainsUnit(gg_rct_GladiatorShopRegion, unit)) then
            -- after the shop round, gladiators gain greed gold and are healed to full
            GameLoop_GladiatorsGreedyness[playerIndex] = true
            SetUnitLifePercentBJ(unit, 100)
        else
            GameLoop_GladiatorsGreedyness[playerIndex] = false
            SetUnitLifePercentBJ(unit, 100)
        end

        SetUnitPositionLoc(unit, point)
        PanCameraToTimedLocForPlayer(owner, point, 0.0)
    end)

    ForGroup(udg_GladiatorUnits, function()
        local unit = GetEnumUnit()
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        SetUnitPositionLoc(unit, point)
    end)

    RemoveLocation(point)
end

function GameLoop_GameMastersVictory()
    GameLoop_EndRound()
end

function GameLoop_GladiatorsVictory()
    GameLoop_EndRound()
end

function GameLoop_EndRound()
    glIsInFight = false
    glRoundIndex = glRoundIndex + 1
    glPhaseRoundIndex = glPhaseRoundIndex + 1
    local state = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)
    if state.IsTransitionFight then
        glPhaseIndex = glPhaseIndex + 1
    end

    ForForce(udg_GameMasterPlayers, function()
        local player = GetEnumPlayer()
        if state.IsTransitionFight then
            GameBalanceTrigger_AddScaling(player, 0.98, 0.65, 0.65)
        else
            GameBalanceTrigger_AddScaling(player, 0.10, 0.05, 0.05)
        end
    end)

    GameLoop_SetGladiatorsStateToRest()
    DelayedCallback(2.0, GameLoop_MoveGladiatorUnitsToRest)
   
    ForGroup(udg_GameMasterUnits, function()
        local unit = GetEnumUnit()
        RemoveUnit(unit)
    end)
    GroupClear(udg_GameMasterUnits)

    GameLoop_BeginRoundCountdown()
    
    BattleRoyale_End()
    ResolveRoundCooldown()
end

function GameLoop_SetGladiatorsStateToRest()
    ForGroup(udg_GladiatorUnits, function()
        local unit = GetEnumUnit()
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        --SetUnitLifePercentBJ(unit, 100)
    end)

    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        local owner = GetOwningPlayer(unit)
        local playerIndex = GetPlayerId(owner)
        -- dont give xp if the unit is dead, it will bug out
        if IsUnitAliveBJ(unit) then
            -- if the hero died, the player will not be awarded gold.
            local didGreed = GameLoop_GladiatorsGreedyness[playerIndex]
            if (didGreed) then                
                GameLoop_AddGoldToPlayer(owner, GameLoop_Gladiators_GoldOnGreed)
            else
                GameLoop_AddGoldToPlayer(owner, GameLoop_Gladiators_GoldOnNeed)
            end

            local currentLevel = GetHeroLevel(unit)
            SetHeroLevel(unit, math.min(20, currentLevel + 1), true)
            SetUnitInvulnerable(unit, true)
            --SetUnitLifePercentBJ(unit, 100)
            
            local defaultRegen = 50
            local regenFromItems = 0

            for i = 1, 6 do
                local item = UnitItemInSlotBJ(unit, i)
                local id = GetItemTypeId(item)
                -- ring of regen
                if id == FourCC('I00K') then
                    regenFromItems = regenFromItems + 200
                end
            end

            local str = GetHeroStr(unit, true)
            CauseHealUnscaled(unit, unit, defaultRegen + regenFromItems + (str * 3))
        end
    end)
end

function GameLoop_MoveGladiatorUnitsToRest()
    local point = nil
    local state = GMCurrentPhase.evaluateState(glRoundIndex, glPhaseRoundIndex)
    if state.IsTransitionFight then
        point = GetRectCenter(gg_rct_GladiatorShopRegion)
    else
        point = GetRectCenter(gg_rct_GladiatorDraftRegion)
    end

    ForGroup(udg_GladiatorUnits, function()
        local unit = GetEnumUnit()
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        SetUnitPositionLoc(unit, point)
    end)

    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        if (not IsUnitAliveBJ(unit)) then
            ReviveHeroLoc(unit, point, true)
            -- give xp, if the hero was dead, it was not given xp
            local currentLevel = GetHeroLevel(unit)
            SetHeroLevel(unit, math.min(20, currentLevel + 1), true)
            SetUnitInvulnerable(unit, true)
        else
            SetUnitPositionLoc(unit, point)
        end

        local camLoc = GetUnitLoc(unit)
        local owner = GetOwningPlayer(unit)
        PanCameraToTimedLocForPlayer(owner, camLoc, 0.0)
        RemoveLocation(camLoc)
    end)

    RemoveLocation(point)
end
