AbilityTrigger_Necro_Necrobolt = nil

RegInit(function()
    AbilityTrigger_Necro_Necrobolt = AddAbilityCastTrigger('A04H', AbilityTrigger_Necro_Necrobolt_Actions)
end)

function AbilityTrigger_Necro_Necrobolt_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local startPoint = GetUnitLoc(caster)

    local damage = 25.00
    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl", 400, 0, function()
        RemoveLocation(startPoint)
        local point = GetUnitLoc(target)
        CauseMagicDamage(caster, target, damage)
        AbilityFunction_Undead_InfestTarget(caster, target, 5.0)
        CreateEffectAtPoint(point, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", 2.0)
        RemoveLocation(point)
    end)
end