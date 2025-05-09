sa_TeamA = {}
sa_TeamB = {}
sa_Score = {
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0
}

function ShuffleArena_ShuffleTeams()
    sa_TeamA = {}
    sa_TeamB = {}

    local heroes = {}
    local i = 1
    ForGroup(udg_GladiatorHeroes, function()
        local hero = GetEnumUnit()
        heroes[i] = hero
        i = i + 1
    end)

    local n = #heroes
    local nTeamA = math.floor(n / 2)
    local nTeamB = n - nTeamA
    local teamAIndeces = SelectRandomIndeces(#heroes, nTeamA)

    local tContains = function(t, v)
        for i = 1, #t do
            if t[i] == v then
                return true
            end
        end
        return false
    end

    for i = 1, #heroes do
        if tContains(teamAIndeces, i) then
            sa_TeamA[#sa_TeamA + 1] = heroes[i]
        else
            sa_TeamB[#sa_TeamB + 1] = heroes[i]
        end
    end    

    for i = 1, #sa_TeamA do
        for j = 1, #sa_TeamA do
            if (i ~= j) then
                SetPlayerAllianceStateAllyBJ(GetOwningPlayer(sa_TeamA[i]), GetOwningPlayer(sa_TeamA[j]), true)
            end
        end
        for j = 1, #sa_TeamB do
            SetPlayerAllianceStateAllyBJ(GetOwningPlayer(sa_TeamA[i]), GetOwningPlayer(sa_TeamB[j]), false)
        end
    end

    for i = 1, #sa_TeamB do
        for j = 1, #sa_TeamB do
            if (i ~= j) then
                SetPlayerAllianceStateAllyBJ(GetOwningPlayer(sa_TeamB[i]), GetOwningPlayer(sa_TeamB[j]), true)
            end
        end
        for j = 1, #sa_TeamA do
            SetPlayerAllianceStateAllyBJ(GetOwningPlayer(sa_TeamB[i]), GetOwningPlayer(sa_TeamA[j]), false)
        end
    end
end

function ShuffleArena_AddGoldToPlayer(player, amount)
    if (udg_IsDevelopment) then
        -- give the gold to player 1 red
        player = Player(0)
    end

    local gold = GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD)
    SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, gold + amount)
end

function ShuffleArena_BeginIntermissionTimer(message, time, cancelPredicate, callback)
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

function ShuffleArena_GrantSelectionsMana()
    local nManaToGrant = CountPlayersInForceBJ(udg_GladiatorPlayers)
    local nManaLeftToGrant = nManaToGrant

    -- First, set the mana of all units to 0
    for i = 1, #ShuffleArena_SelectorUnits do
        local unit = ShuffleArena_SelectorUnits[i]
        -- SetUnitState(unit, UNIT_STATE_MANA, 0)
        SetUnitManaBJ(unit, 0)
    end

    -- Then, grant mana to all units
    while (nManaLeftToGrant > 0) do
        local unit = ShuffleArena_GetNextIndexedSelectorUnit()

        local mana = GetUnitState(unit, UNIT_STATE_MANA)
        local targetMana = mana + 1
        --SetUnitState(unit, UNIT_STATE_MANA, targetMana)
        SetUnitManaBJ(unit, targetMana)

        nManaLeftToGrant = nManaLeftToGrant - 1
    end
end

function ShuffleArena_GetNextIndexedSelectorUnit()
    local nGameMasterPlayers = CountPlayersInForceBJ(udg_GameMasterPlayers)
    local index = ModuloInteger(ShuffleArena_SelectorUnits_CurrentIndex, nGameMasterPlayers)
    local unit = ShuffleArena_SelectorUnits[index + 1]
    ShuffleArena_SelectorUnits_CurrentIndex = ShuffleArena_SelectorUnits_CurrentIndex + 1
    return unit
end

function ShuffleArena_RevokeSelectionsMana()
    for i = 1, #ShuffleArena_SelectorUnits do
        local unit = ShuffleArena_SelectorUnits[i]
        SetUnitState(unit, UNIT_STATE_MANA, 0)
    end
end

function ShuffleArena_SpawnUnits()
    -- if any mana remains, random groups will be selected.
    for i = 1, #ShuffleArena_SelectorUnits do
        local selectorUnit = ShuffleArena_SelectorUnits[i]
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
            local spawnLoc = ShuffleArena_GetSpawnLocationForUnit(0, unitId)

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
                    local nextSelectorUnit = ShuffleArena_GetNextIndexedSelectorUnit()
                    local defSpawnLoc = ShuffleArena_GetSpawnLocationForUnit(0, unitId)
                    CreateUnitAtLoc(GetOwningPlayer(nextSelectorUnit), unitId, defSpawnLoc, 0)
                    RemoveLocation(defSpawnLoc)
                end
            end
        end
    end

    local remainingManaSum = 0
    for i = 1, #ShuffleArena_SelectorUnits do
        local unit = ShuffleArena_SelectorUnits[i]
        local manaRemain = GetUnitState(unit, UNIT_STATE_MANA)
        remainingManaSum = remainingManaSum + math.floor(manaRemain + 0.5)
    end
end

function ShuffleArena_GetSpawnLocationForUnit(groupIndex, unitId)
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

function ShuffleArena_MoveGladiatorUnitsToArena()
    local pointTeamA = GetRectCenter(gg_rct_KingOfTheHillGladiatorStart)
    local pointTeamB = GetRectCenter(gg_rct_KingOfTheHillGMStart)

    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        local owner = GetOwningPlayer(unit)
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        local isTeamA = false
        for i = 1, #sa_TeamA do
            if (unit == sa_TeamA[i]) then
                isTeamA = true
                break
            end
        end

        if isTeamA then
            SetUnitPositionLoc(unit, pointTeamA)
            PanCameraToTimedLocForPlayer(owner, point, 0.0)
        else
            SetUnitPositionLoc(unit, pointTeamB)
            PanCameraToTimedLocForPlayer(owner, point, 0.0)
        end
    end)

    ForGroup(udg_GladiatorUnits, function()
        local unit = GetEnumUnit()
        local unitType = GetUnitTypeId(unit)
        local owner = GetOwningPlayer(unit)
        if (unitType == FourCC('e000')) then
            return
        end
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        local isTeamA = false
        for i = 1, #sa_TeamA do
            if IsUnitAlly(unit, GetOwningPlayer(sa_TeamA[i])) then
                isTeamA = true
                break
            end
        end

        if isTeamA then
            SetUnitPositionLoc(unit, pointTeamA)
            PanCameraToTimedLocForPlayer(owner, point, 0.0)
        else
            SetUnitPositionLoc(unit, pointTeamB)
            PanCameraToTimedLocForPlayer(owner, point, 0.0)
        end

        SetUnitPositionLoc(unit, point)
    end)

    RemoveLocation(pointTeamA)
    RemoveLocation(pointTeamB)
end

function ShuffleArena_SetGladiatorUnitsToFight()
    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        SetUnitInvulnerable(unit, false)
        UnitAddAbility(unit, abilityId)
        UnitResetCooldown(unit)
        SetUnitManaPercentBJ(unit, 100)
        SetUnitLifePercentBJ(unit, 100)
    end)
    
    ForGroup(udg_GladiatorUnits, function()
        local unit = GetEnumUnit()
        SetUnitInvulnerable(unit, false)
        UnitResetCooldown(unit)
        SetUnitManaPercentBJ(unit, 100)
        SetUnitLifePercentBJ(unit, 100)
    end)
end

function ShuffleArena_SetGladiatorsStateToRest()
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
            SetUnitInvulnerable(unit, true)
        end
    end)
end

function ShuffleArena_MoveGladiatorUnitsToRest()
    local point = GetRectCenter(gg_rct_GladiatorShopRegion)

    ForGroup(udg_GladiatorUnits, function()
        local unit = GetEnumUnit()
        local unitType = GetUnitTypeId(unit)
        if (unitType == FourCC('e000')) then
            return
        end
        if (not IsUnitAliveBJ(unit)) then
            return
        end

        SetUnitInvulnerable(unit, true)
        SetUnitPositionLoc(unit, point)
    end)

    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        if (not IsUnitAliveBJ(unit)) then
            ReviveHeroLoc(unit, point, true)
            SetUnitInvulnerable(unit, true)
        else
            SetUnitPositionLoc(unit, point)
        end

        local currentLevel = GetHeroLevel(unit)
        SetHeroLevel(unit, math.min(20, currentLevel + 1), true)

        local camLoc = GetUnitLoc(unit)
        local owner = GetOwningPlayer(unit)
        PanCameraToTimedLocForPlayer(owner, camLoc, 0.0)
        RemoveLocation(camLoc)
    end)

    RemoveLocation(point)
end