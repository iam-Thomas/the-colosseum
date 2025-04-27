AbilityTrigger_D_ThunderClap = nil

RegInit(function()
    AbilityTrigger_D_ThunderClap = AddAbilityCastTrigger('A027', AbilityTrigger_D_ThunderClap_Actions)

    RegisterTriggerEnableById(AbilityTrigger_D_ThunderClap, FourCC('H005'))
end)

function AbilityTrigger_D_ThunderClap_Actions()
    local caster = GetSpellAbilityUnit()
    local loc = GetUnitLoc(caster)
    local damage = 20.00 + (1.00 * GetHeroLevel(caster))
    
    local units = GetUnitsInRange_EnemyGroundTargetable(caster, loc, 250)
    CreateEffectAtPoint(loc, "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 2.0)
    for i = 1, #units do
        local targetLoc = GetUnitLoc(units[i])
        local angle = AngleBetweenPoints(loc, targetLoc)
        CastDummyAbilityOnTarget(caster, units[i], FourCC('A04B'), 1, "slow")
        CauseMagicDamage(caster, units[i], damage)
        Knockback_Angled(units[i], angle, 180.00)
    end

    RemoveLocation(loc)
end