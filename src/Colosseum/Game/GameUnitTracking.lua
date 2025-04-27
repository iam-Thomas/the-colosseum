GameUnitTracking_HeroSelection = nil

GameUnitTracking_Trigger_UnitSpawned = nil
GameUnitTracking_Trigger_UnitDied = nil

RegInit(function()
    GameUnitTracking_HeroSelection = AddAbilityCastTrigger('A000', GameUnitTracking_HeroSelection_Select)
    
    GameUnitTracking_Trigger_UnitDied = CreateTrigger()
    TriggerAddAction(GameUnitTracking_Trigger_UnitDied, GameUnitTracking_HandleUnitDied)
    TriggerRegisterAnyUnitEventBJ(GameUnitTracking_Trigger_UnitDied, EVENT_PLAYER_UNIT_DEATH)

    GameUnitTracking_Trigger_UnitSpawned = CreateTrigger()
    TriggerAddAction(GameUnitTracking_Trigger_UnitSpawned, GameUnitTracking_HandleUnitSpawned)
    TriggerRegisterEnterRectSimple(GameUnitTracking_Trigger_UnitSpawned, GetEntireMapRect())
end)

function GameUnitTracking_HeroSelection_Select()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    if not IsUnitType(target, UNIT_TYPE_HERO) then
        return
    end

    EnableTriggerById(GetUnitTypeId(target))

    local unitType = GetUnitTypeId(target)
    local owner = GetOwningPlayer(caster)
    local playerId = GetPlayerId(owner)
    local loc = nil
    if glIsInFight then
        loc = GetRectCenter(gg_rct_KingOfTheHillGladiatorStart)
    else
        loc = GetRectCenter(gg_rct_GladiatorSpawnRegion)
    end
    --local unit = CreateUnitAtLoc(owner, unitType, loc, 0.00)
    local unit = CreateUnit(owner, unitType, GetLocationX(loc), GetLocationY(loc), 0.00)
    GroupAddUnit(udg_GladiatorHeroes, unit)
    PanCameraToTimedLocForPlayer(owner, loc, 0.0)
    
    KillUnit(caster)
    RemoveUnit(target)

    RemoveLocation(loc)
end

function GameUnitTracking_HandleUnitDied()
    local dyingUnit = GetDyingUnit()
    if (IsUnitInGroup(dyingUnit, udg_GladiatorUnits)) then
        GroupRemoveUnit(udg_GladiatorUnits, dyingUnit)
    end

    if not glIsInFight then
        return
    end

    if IsUnitInGroup(dyingUnit, udg_GameMasterUnits) and glIsInFight then
        local hasGameMasterUnitAlive = false
        ForGroup(udg_GameMasterUnits, function()
            local unit = GetEnumUnit()
            if (IsUnitAliveBJ(unit)) and GameLoop_IsUnitDeathRequired(unit) then
                hasGameMasterUnitAlive = true
                return
            end
        end)

        if not hasGameMasterUnitAlive then
            GameLoop_GladiatorsVictory()
            return
        end
    end
    
    if IsUnitInGroup(dyingUnit, udg_GladiatorHeroes) and glIsInFight then
        local hasGladiatorHeroAlive = false
        ForGroup(udg_GladiatorHeroes, function()
            local unit = GetEnumUnit()
            if (IsUnitAliveBJ(unit)) then
                hasGladiatorHeroAlive = true
                return
            end
        end)

        if not hasGladiatorHeroAlive then
            GameLoop_GameMastersVictory()
            return
        end
    end    
end

function GameUnitTracking_HandleUnitSpawned()
    --glIsInFight 
    local unit = GetEnteringUnit()
    local owner = GetOwningPlayer(unit)

    -- hmnm//
    local unitId = GetUnitTypeId(unit)
    if FourCC('h00R') == unitId then
        return
    end

    if (IsPlayerInForce(owner, udg_GameMasterPlayers) and (not IsUnitInGroup(unit, udg_GameMasterUnits))) then
        GroupAddUnit(udg_GameMasterUnits, unit)
    end
end