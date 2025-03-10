AbilityTrigger_Graveyard_RaiseGhouls = nil

RegInit(function()
    AbilityTrigger_Graveyard_RaiseGhouls = AddAbilityCastTrigger('A04L', AbilityTrigger_Graveyard_RaiseGhouls_Actions)
end)

function AbilityTrigger_Graveyard_RaiseGhouls_Actions()
    local caster = GetSpellAbilityUnit()
    local loc = GetUnitLoc(caster)
    local owner = GetOwningPlayer(caster)

    local n = 8
    for i = 1, n do
        local summonPoint = PolarProjectionBJ(loc, 200, (360 / n) * i)
        local x = GetLocationX(summonPoint)
        local y = GetLocationY(summonPoint)
        local unit = CreateUnit(owner, FourCC('u004'), x, y, 0)
        UnitApplyTimedLife(unit, 0, 9.00)
        CreateEffectAtPoint(summonPoint, "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 2.00)
        RemoveLocation(summonPoint)
    end

    RemoveLocation(loc)
end