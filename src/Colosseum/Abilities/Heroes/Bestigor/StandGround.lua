AbilityTrigger_BEST_StandGround = nil

RegInit(function()
    AbilityTrigger_BEST_StandGround = AddAbilityCastTrigger('A09F', AbilityTrigger_BEST_StandGround_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_BEST_StandGround, FourCC('O004'))
end)

function AbilityTrigger_BEST_StandGround_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local strength = GetHeroStr(caster, true)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A09F'))
    local strengthFactor = 0.85 + (0.15 * abilityLevel)
    local tenaciousDuration = 1.00 + (2.00 * abilityLevel)

    CreateEffectAtPoint(casterLoc, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 2.0)
    local targets = GetUnitsInRange_EnemyTargetable(caster, casterLoc, 230)
    for i = 1, #targets do
        local target = targets[i]
        local targetLoc = GetUnitLoc(target)
        local angle = AngleBetweenPoints(casterLoc, targetLoc)
        CauseMagicDamage(caster, target, strength * strengthFactor)
        CauseStun3s(caster, target)
        Knockback_Angled(target, angle, 150)
    end
    MakeTenacious(caster, tenaciousDuration)

    RemoveLocation(casterLoc)
end