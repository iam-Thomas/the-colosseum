AbilityTrigger_VP_DivineShield = nil

RegInit(function()
    AbilityTrigger_VP_DivineShield = AddAbilityCastTrigger('A033', AbilityTrigger_VP_DivineShield_Actions)
end)

function AbilityTrigger_VP_DivineShield_Actions()
    local caster = GetSpellAbilityUnit()
    local loc = GetUnitLoc(caster)
    
    local units = GetUnitsInRange_EnemyGroundTargetable(caster, loc, 280.00)

    for i = 1, #units do
        CastDummyAbilityOnTarget(caster, units[i], FourCC('A035'), 1, 'slow')
    end

    SetRoundCooldown_R(caster, 1)
end