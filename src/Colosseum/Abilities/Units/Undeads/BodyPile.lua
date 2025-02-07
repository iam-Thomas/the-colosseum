AbilityTrigger_Undead_BodyPile = nil

RegInit(function()
    AbilityTrigger_Undead_BodyPile = AddPeriodicPassiveAbility_CasterHasAbility(FourCC('A06S'), AbilityTrigger_Undead_BodyPile_Functions)
end)

function AbilityTrigger_Undead_BodyPile_Functions(caster, tick)
    if ModuloInteger(tick, 12) ~= 0 then
        return
    end

    IsUnitPaused(caster, false)
    BlzIsUnitInvulnerable(caster)

    local casterLoc = GetUnitLoc(caster)
    local summonLoc = PolarProjectionBJ(casterLoc, 180, math.random(0, 360))
    local unit = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC('u001'), summonLoc, 0)
    local unitLoc = GetUnitLoc(unit)

    CreateEffectAtPoint(unitLoc, "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 2.0)
end