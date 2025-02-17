AbilityTrigger_Mage_ArcaneBolt = nil

RegInit(function()
    AbilityTrigger_Mage_ArcaneBolt = AddAbilityCastTrigger('A07K', AbilityTrigger_Mage_ArcaneBolt_Actions)
end)

function AbilityTrigger_Mage_ArcaneBolt_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local casterLoc = GetUnitLoc(caster)

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A07K'))
    local damage = 45.00 + (45.00 * abilityLevel)
    
    FireHomingProjectile_PointToUnit(casterLoc, target, "war3mapImported\\s_ArcaneRocket Projectile.mdx", 1100, 0.07, function()
        CauseMagicDamage(caster, target, damage)
    end)
end