function GameLoop_AddGoldToPlayer(player, amount)
    if (udg_IsDevelopment) then
        -- give the gold to player 1 red
        player = Player(0)
    end

    local gold = GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD)
    SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, gold + amount)
end

function GameLoop_BeginIntermissionTimer(message, time, cancelPredicate, callback)
    local timer = CreateTimer()
    local dialog = CreateTimerDialog(timer)

    local frequentTimer = CreateTimer()
    local elapsed = 0.00
    local duration = time

    TimerStart(timer, time, false, function()
        DestroyTimerDialog(dialog)
        DestroyTimer(timer)
        DestroyTimer(frequentTimer)
        callback()
    end)

    TimerDialogSetTitle(dialog, message)
    TimerDialogDisplay(dialog, true)

    TimerStart(frequentTimer, 0.20, true, function()
        if (cancelPredicate()) then
            DestroyTimerDialog(dialog)
            DestroyTimer(timer)
            DestroyTimer(frequentTimer)
            callback()
        end
    end)
end

function GameLoop_GrantSelectionsMana()
    local nManaToGrant = CountPlayersInForceBJ(udg_GladiatorPlayers)
    local nManaLeftToGrant = nManaToGrant

    -- First, set the mana of all units to 0
    for i = 1, #GameLoop_SelectorUnits do
        local unit = GameLoop_SelectorUnits[i]
        -- SetUnitState(unit, UNIT_STATE_MANA, 0)
        SetUnitManaBJ(unit, 0)
    end

    -- Then, grant mana to all units
    while (nManaLeftToGrant > 0) do
        local unit = GameLoop_GetNextIndexedSelectorUnit()

        local mana = GetUnitState(unit, UNIT_STATE_MANA)
        local targetMana = mana + 1
        --SetUnitState(unit, UNIT_STATE_MANA, targetMana)
        SetUnitManaBJ(unit, targetMana)

        nManaLeftToGrant = nManaLeftToGrant - 1
    end
end

function GameLoop_GetNextIndexedSelectorUnit()
    local nGameMasterPlayers = CountPlayersInForceBJ(udg_GameMasterPlayers)
    local index = ModuloInteger(GameLoop_SelectorUnits_CurrentIndex, nGameMasterPlayers)
    local unit = GameLoop_SelectorUnits[index + 1]
    GameLoop_SelectorUnits_CurrentIndex = GameLoop_SelectorUnits_CurrentIndex + 1
    return unit
end

function GameLoop_RevokeSelectionsMana()
    for i = 1, #GameLoop_SelectorUnits do
        local unit = GameLoop_SelectorUnits[i]
        SetUnitState(unit, UNIT_STATE_MANA, 0)
    end
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
                GMSelections_PickRandomGroup_CommonRare(GMCurrentPhase.groups, function(unitType, nOfType, rarity)
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
            local spawnLoc = GameLoop_GetSpawnLocationForUnit(0, unitId)

            local unit = CreateUnitAtLoc(owner, unitId, spawnLoc, 0)
            GroupAddUnit(udg_GameMasterUnits, unit)
            RemoveLocation(spawnLoc)
        end
    end

    -- spawn default phase units
    if GMCurrentPhase.defaultGroups ~= nil then
        for i = 1, #GMCurrentPhase.defaultGroups do
            local defaultGroup = GMCurrentPhase.defaultGroups[i]
            for j = 1, #defaultGroup do
                local defaultTypeGroup = defaultGroup[j]
                local unitTypeString = defaultTypeGroup.unitString                    
                local unitId = GetUnitTypeFromUnitString(unitTypeString)
                for n = 1, defaultTypeGroup.count do
                    local nextSelectorUnit = GameLoop_GetNextIndexedSelectorUnit()
                    local defSpawnLoc = GameLoop_GetSpawnLocationForUnit(0, unitId)
                    CreateUnitAtLoc(GetOwningPlayer(nextSelectorUnit), unitId, defSpawnLoc, 0)
                    RemoveLocation(defSpawnLoc)
                end
            end
        end
    end

    local remainingManaSum = 0
    for i = 1, #GameLoop_SelectorUnits do
        local unit = GameLoop_SelectorUnits[i]
        local manaRemain = GetUnitState(unit, UNIT_STATE_MANA)
        remainingManaSum = remainingManaSum + math.floor(manaRemain + 0.5)
    end
end

function GameLoop_GetSpawnLocationForUnit(groupIndex, unitId)
    local pointValue = GetUnitPointValueByType(unitId)
    local pointString = tostring(pointValue)
    local spawnChar = string.sub(pointString, -2, -2)

    local spawnLoc = nil
    if spawnChar == "0" then
        return GetRectCenter(gg_rct_KingOfTheHillGMStart)
    elseif spawnChar == "1" then
        spawnLoc = GetRandomLocInRect(gg_rct_KingOfTheHillCenterRegion)
        local tempLoc = GetUnitValidLoc(spawnLoc)
        RemoveLocation(spawnLoc)
        return tempLoc
    elseif spawnChar == "2" then
        return GetRectCenter(gg_rct_KingOfTheHillGladiatorDefendPoint)
    else
        return GetRectCenter(gg_rct_KingOfTheHillGMStart)
    end
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

function GameLoop_SetGladiatorUnitsToFight()
    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        SetUnitInvulnerable(unit, false)
        UnitResetCooldown(unit)
        SetUnitManaPercentBJ(unit, 100)
    end)
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
                if id == FourCC('I00K') then -- ring of regen
                    regenFromItems = regenFromItems + 200
                elseif id == FourCC('I00Y') then -- mask of death
                    regenFromItems = regenFromItems + 150
                elseif id == FourCC('I00Z') then -- helm of battlethirst
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

function GameLoop_IsUnitDeathRequired(unit)
    return GetUnitAbilityLevel(unit, FourCC('A00N')) < 1
end