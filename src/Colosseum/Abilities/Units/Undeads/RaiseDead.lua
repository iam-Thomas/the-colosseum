AbilityTrigger_Necro_RaiseDead = nil

RegInit(function()
    AbilityTrigger_Necro_RaiseDead = AddAbilityCastTrigger('A05T', AbilityTrigger_Necro_RaiseDead_Actions)
end)

function AbilityTrigger_Necro_RaiseDead_Actions()
    local caster = GetSpellAbilityUnit()
    local owner = GetOwningPlayer(caster)
    local loc = GetUnitLoc(caster)
    local facing = GetUnitFacing(caster)

    local summonPoint = PolarProjectionBJ(loc, 180, facing)
    local x = GetLocationX(summonPoint)
    local y = GetLocationY(summonPoint)
    local unit = CreateUnit(owner, FourCC('u006'), x, y, facing)
    local unitLoc = GetUnitLoc(unit)
    
    local rdEffect = CreateEffectAtPoint(unitLoc, "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 3.00)
end