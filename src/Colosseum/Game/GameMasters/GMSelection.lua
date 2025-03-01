GMSelections_Trigger_PickUnit = nil

glPlayerSelections = {
    {},
    {},
    {},
    {}
}

GMCurrentPhase = nil

GMDraftDisplayGroup = nil

GMPhases = {}

RegInit(function()
    GMDraftDisplayGroup = CreateGroup()
    GMSelections_Trigger_PickUnit = AddAbilityCastTrigger('A02G', GMSelections_SelectGroup)
    
    GMPhases = {
        { GetPhaseBandits(), GetPhaseMurlocs() },
        { GetPhasePirates(), GetPhaseCreepers() },
        { GetPhaseHorde(), GetPhaseUndeads() },
        { GetPhasePirates() },
    }    
end)

function GMSelections_PhaseChange(phase)
    GMCurrentPhase = phase
    glPhaseRoundIndex = 1

    GMSelections_Create()
end

function GMSelections_Create()
    GMSelections_CreateUnits()
    GMSelections_CreateBosses()
end

function GMSelections_CreateTransitionUnits()
    GMSelections_ClearAll()

    local tindex = math.min(glPhaseIndex, #GMPhases)

    local factions = GMPhases[tindex]
    local indeces = GMSelections_GetSelectRandomBossIndexArray(#factions, 2) -- 2 options only i think

    for i = 1, #indeces do
        local point = GetRectCenter(glBossSelectionZones[i])
        local faction = factions[indeces[i]]
        local signatureUnitId = faction.signatureUnitId

        local unit = CreateUnitAtLoc(Player(27), signatureUnitId, point, 0)
        SetUnitInvulnerable(unit, true)
        GroupAddUnit(glBossSelectionGroups[i], unit)

        local effect = CreateEffectAtPoint(point, "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", 3.00)
        BlzSetSpecialEffectScale(effect, 1.75)
        RemoveLocation(point)
    end
end

function GMSelections_PickRandomTransitionUnit()
    local selectTable = {}
    for i = 1, #glBossSelectionGroups do
        if CountUnitsInGroup(glBossSelectionGroups[i]) > 0 then
            local unit = FirstOfGroup(glBossSelectionGroups[i])
            table.insert(selectTable, FirstOfGroup(glBossSelectionGroups[i]))
        end
    end

    local selectedIndeces = GMSelections_GetSelectRandomBossIndexArray(#selectTable, 1)
    local selectedIndex = selectedIndeces[1]
    local unit = selectTable[selectedIndex]
    local unitId = GetUnitTypeId(unit)
    GMSelections_SelectPhase(unitId)
end

function GMSelections_ClearAll()
    GMSelections_ClearUnits()
    DestroyImmuneEffects()
    GMSelections_ClearBosses()
end

function GMSelections_ResetForFight()
    for i = 1, #glPlayerSelections do
        glPlayerSelections[i] = {}
    end

    GMSelections_ClearUnits()
    GMSelections_CreateUnits()
end

function GMSelections_CreateUnits()
    -- Create initial selections
    for i = 1, #glSquadSelectionZones do
        if (CountUnitsInGroup(glSquadSelectionGroups[i]) < 1) then
            local point = GetRectCenter(glSquadSelectionZones[i])
            
            GMSelections_PickRandomGroup(GMCurrentPhase.groups, function(unitType, nOfType, rarity)
                local rarityEffect = AddSpecialEffectLoc("buildings\\other\\CircleOfPower\\CircleOfPower.mdl", point)
                if rarity == 4 then
                    BlzSetSpecialEffectColor(rarityEffect, 255, 255, 0)
                    BlzSetSpecialEffectAlpha(rarityEffect, 140)
                    BlzSetSpecialEffectScale(rarityEffect, 2.8)
                elseif rarity == 3 then
                    BlzSetSpecialEffectColor(rarityEffect, 255, 40, 255)
                    BlzSetSpecialEffectAlpha(rarityEffect, 110)
                    BlzSetSpecialEffectScale(rarityEffect, 2.5)
                elseif rarity == 2 then
                    BlzSetSpecialEffectColor(rarityEffect, 135, 135, 255)
                    BlzSetSpecialEffectAlpha(rarityEffect, 80)
                    BlzSetSpecialEffectScale(rarityEffect, 2.3)
                else
                    BlzSetSpecialEffectColor(rarityEffect, 190, 255, 190)
                    BlzSetSpecialEffectAlpha(rarityEffect, 70)
                    BlzSetSpecialEffectScale(rarityEffect, 2.2)
                end

                local otherRaritySfx = glSquadSelectionGroupRarityEffects[i]
                if otherRaritySfx ~= nil then
                    DestroyEffect(otherRaritySfx)
                    glSquadSelectionGroupRarityEffects[i] = nil
                end

                glSquadSelectionGroupRarityEffects[i] = rarityEffect

                for j = 1, nOfType do
                    local unit = CreateUnitAtLoc(Player(27), unitType, point, 0)
                    GroupAddUnit(glSquadSelectionGroups[i], unit)
                    SetUnitInvulnerable(unit, true)
                    PauseUnit(unit, true)
                end
            end)

            local effect = CreateEffectAtPoint(point, "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", 3.00)
            BlzSetSpecialEffectScale(effect, 1.75)
            RemoveLocation(point)
        end
    end
end

function GMSelections_CreateBosses()
    local indeces = GMSelections_GetSelectRandomBossIndexArray(#GMCurrentPhase.bosses, #glBossSelectionZones)

    for i = 1, #indeces do
        local point = GetRectCenter(glBossSelectionZones[i])
        local squadIndex = indeces[i]
        local squad = GMCurrentPhase.bosses[squadIndex]

        for j = 1, #squad do
            local nUnits = squad[j].count
            local unitString = squad[j].unitString
            local unitType = GetUnitTypeFromUnitString(unitString)
            for n = 1, nUnits do
                local unit = CreateUnitAtLoc(Player(27), unitType, point, 0)
                GroupAddUnit(glBossSelectionGroups[i], unit)
                SetUnitInvulnerable(unit, true)
                PauseUnit(unit, true)
            end
        end

        local effect = CreateEffectAtPoint(point, "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", 3.00)
        BlzSetSpecialEffectScale(effect, 1.75)
        RemoveLocation(point)
    end
end

function GMSelections_ClearUnits()
    for i = 1, #glSquadSelectionGroups do
        local group = glSquadSelectionGroups[i]
        ForGroup(group, function()
            local unit = GetEnumUnit()
            RemoveUnit(unit)
        end)

        GroupClear(group)

        local raritySfx = glSquadSelectionGroupRarityEffects[i]
        if raritySfx ~= nil then
            DestroyEffect(raritySfx)
            glSquadSelectionGroupRarityEffects[i] = nil
        end
    end
end

function GMSelections_ClearBosses()
    for i = 1, #glBossSelectionGroups do        
        ForGroup(glBossSelectionGroups[i], function()
            local unit = GetEnumUnit()
            RemoveUnit(unit)
        end)

        GroupClear(glBossSelectionGroups[i])
    end
end

function GMSelections_GetSelectRandomBossIndexArray(max, n)
    local values = {}
    for i = 1, max do
        table.insert(values, i)
    end
    
    local result = {}
    for i = 1, n do
        if (#values < 1) then
            return result
        end

        local randomIndex = math.random(1, #values)
        local value = values[randomIndex]
        table.insert(result, value)
        table.remove(values, randomIndex)
    end

    return result
end

function GMSelections_SelectGroup()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    if glIsInPhaseTransition then
        GMSelections_SelectPhase(GetUnitTypeId(target))
        return
    end

    local group = nil
    local array = nil
    local isBossGroup = false
    
    for i = 1, #glSquadSelectionGroups do
        if (IsUnitInGroup(target, glSquadSelectionGroups[i])) then
            group = glSquadSelectionGroups[i]
        end
    end
    
    for i = 1, #glBossSelectionGroups do
        if (IsUnitInGroup(target, glBossSelectionGroups[i])) then
            isBossGroup = true
            group = glBossSelectionGroups[i]
        end
    end

    local owner = GetOwningPlayer(caster)
    for i = 1, #glPlayerSelections do
        if (owner == Player(i - 1)) then
            array = glPlayerSelections[i]
        end
    end

    if (group == nil or array == nil) then
        return
    end

    local point = GetUnitLoc(target)
    local effect = CreateEffectAtPoint(point, "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", 3.00)
    BlzSetSpecialEffectScale(effect, 1.75)
    RemoveLocation(point)

    GMSelections_SelectUnitsFromGroup(group, array)

    if isBossGroup then
        GMSelections_MakeBossGroupsInvulnerable()
    end

    -- Respawn new selection units in the area that has just beend selected.
    local respawnTimer = CreateTimer()
    GMSelections_ClearUnits()
    TimerStart(respawnTimer, 0.7, false, function()
        GMSelections_CreateUnits()
        DestroyTimer(respawnTimer)
    end)
end

function GMSelections_SelectPhase(unitId)
    glIsInPhaseTransition = false

    GMSelections_ClearAll()
    for i = 1, #GMPhases do
        for j = 1, #(GMPhases[i]) do
            if GMPhases[i][j].signatureUnitId == unitId then
                GMSelections_PhaseChange(GMPhases[i][j])
            end
        end
    end

    GameLoop_GrantSelectionsMana()
    GameLoop_BeginRoundCountdown()
end

function GMSelections_SelectUnitsFromGroup(group, array)
    ForGroup(group, function()
        local unit = GetEnumUnit()
        local unitType = GetUnitTypeId(unit)
        table.insert(array, unitType)

        GroupRemoveUnit(group, unit)
        GroupAddUnit(GMDraftDisplayGroup, unit)

        local loc = GetRandomLocInRect(gg_rct_TechDraftDisplay)
        SetUnitPositionLoc(unit, loc)
        -- add magic immunity to prevent targeting by 'Pick Fighters'
        UnitAddAbility(unit, FourCC('ACmi'))
    end)
end

function GMSelections_CleanBossSelections()
    local group = GetUnitsInRectAll(gg_rct_TechSelectRegion)
    local nxt = FirstOfGroup(group)
    while (nxt ~= nil) do
        local owner = GetOwningPlayer(nxt)
        GetForceOfPlayer(Player(1))
        if not IsPlayerInForce(owner, GetForceOfPlayer(Player(1))) then
            RemoveUnit(nxt)    
        end
        RemoveUnit(nxt)
        GroupRemoveUnit(nxt, group)
        nxt = FirstOfGroup(group)
    end

    DestroyGroup(group)
end

function GMSelections_CleanDraftDisplayUnits()
    ForGroup(GMDraftDisplayGroup, function()
        local enumUnit = GetEnumUnit()
        GroupRemoveUnit(GMDraftDisplayGroup, enumUnit)
        RemoveUnit(enumUnit)
    end)
end

glImmuneEffects = {}

function GMSelections_MakeBossGroupsVulnerable()
    for i = 1, #glBossSelectionGroups do
        local group = glBossSelectionGroups[i]
        ForGroup(group, function()
            local eUnit = GetEnumUnit()
            UnitRemoveAbility(eUnit, FourCC('ACmi'))
        end)
    end
    DestroyImmuneEffects()
end

function DestroyImmuneEffects()
    for i = 1, #glImmuneEffects do
        DestroyEffect(glImmuneEffects[i])
    end
end

function GMSelections_MakeBossGroupsInvulnerable()
    for i = 1, #glBossSelectionGroups do
        local group = glBossSelectionGroups[i]
        ForGroup(group, function()
            local eUnit = GetEnumUnit()

            UnitAddAbility(eUnit, FourCC('ACmi'))
            local effect = AddSpecialEffectTarget("Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl", eUnit, "origin")
            table.insert(glImmuneEffects, effect)
            --AddSpecialEffectTargetUnitBJ("chest", eUnit, "Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl")
        end)
    end    
end

function tableContainsInteger(tabl, int)
    for i = 1, #tabl do
        if tabl[i] == int then
            return true
        end
    end
    return false
end

function GMSelections_GetUniqueUnitTypeIdsFromPhase(phase)
    local result = {}

    function addAllFunction(targetTable, sourceTable)
        for i = 1, #sourceTable do
            if not tableContainsInteger(targetTable, sourceTable[i]) then
                table.insert(targetTable, sourceTable[i])
            end
        end
    end

    local commonsIds = GMSelections_GetUniqueUnitTypeIdsFromGroups(phase.groups.commons)
    addAllFunction(result, commonsIds)
    local raresIds = GMSelections_GetUniqueUnitTypeIdsFromGroups(phase.groups.rares)
    addAllFunction(result, raresIds)
    local epicsIds = GMSelections_GetUniqueUnitTypeIdsFromGroups(phase.groups.epics)
    addAllFunction(result, epicsIds)
    local legendariesIds = GMSelections_GetUniqueUnitTypeIdsFromGroups(phase.groups.legendaries)
    addAllFunction(result, legendariesIds)
    local bossesIds = GMSelections_GetUniqueUnitTypeIdsFromGroups(phase.bosses)
    addAllFunction(result, bossesIds)

    return result
end

function GMSelections_GetUniqueUnitTypeIdsFromGroups(groups)
    local result = {}

    local tableContainsInteger = function(tabl, typeId)
        for i = 1, #tabl do
            if tabl[i] == typeId then
                return true
            end
        end
        return false
    end

    for i = 1, #groups do
        local group = groups[i]
        for j = 1, #group do
            local unitString = group[j].unitString
            local unitTypeId = GetUnitTypeFromUnitString(unitString)
            if not tableContainsInteger(result, unitTypeId) then
                table.insert(result, unitTypeId)
            end
        end
    end

    return result
end