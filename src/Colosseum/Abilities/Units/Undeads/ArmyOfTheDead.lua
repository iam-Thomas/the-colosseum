AbilityTrigger_Necro_ArmyOfTheDead = nil

RegInit(function()
    AbilityTrigger_Necro_ArmyOfTheDead = AddAbilityCastTrigger('A08D', AbilityTrigger_Necro_ArmyOfTheDead_Actions)
end)

function AbilityTrigger_Necro_ArmyOfTheDead_Actions()
    local caster = GetSpellAbilityUnit()
    
    local timer = CreateTimer()
    TimerStart(timer, 1.5, true, function()
        local order = OrderId2String(GetUnitCurrentOrder(caster))    
        if (not (order == "starfall")) then
            DestroyTimer(timer)
            return
        end

        AbilityTrigger_Necro_ArmyOfTheDead_Summon(caster)
    end)    
end

function AbilityTrigger_Necro_ArmyOfTheDead_Summon(caster)
    local loc = GetUnitLoc(caster)
    local facing = GetUnitFacing(caster)
    local owner = GetOwningPlayer(caster)
    
    local summonPoint = PolarProjectionBJ(loc, 170, math.random(0, 360))
    local x = GetLocationX(summonPoint)
    local y = GetLocationY(summonPoint)
    local unit = CreateUnit(owner, FourCC('u006'), x, y, facing)
    local unitLoc = GetUnitLoc(unit)    
    local rdEffect = CreateEffectAtPoint(unitLoc, "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 3.00)

    RemoveLocation(summonPoint)
    RemoveLocation(loc)
    RemoveLocation(unitLoc)
end