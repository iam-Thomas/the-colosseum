RegInit(function()
    local trg = AddAbilityCastTrigger('A0AT', AbilityTrigger_Dwarf_Stormbolt_Actions)
    
    RegisterTriggerEnableById(trg, FourCC('H005'))
end)

function AbilityTrigger_Dwarf_Stormbolt_Actions()
    local caster = GetSpellAbilityUnit()
    local startPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A0AT'))

    local damage = 90.00 + (50.00 * abilityLevel)

    local data = FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl", 800, 0.00, function()
        CauseMagicDamage(caster, target, damage)
        CauseStun3s(caster, target)
    end)

    RemoveLocation(startPoint)
end