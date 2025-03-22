RegInit(function()
    AddAbilityCastTrigger('A0AP', AbilityTrigger_Sef_Wildfire)
end)

function AbilityTrigger_Sef_Wildfire()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local startLoc = PolarProjectionBJ(casterLoc, 400, angle)
    local aoeLoc = PolarProjectionBJ(casterLoc, 180, angle)

    local damage = 75.00
    
    local effect = CreateEffectAtPoint(startLoc, "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdl", 3.0)
    BlzSetSpecialEffectScale(effect, 1.7)
    BlzSetSpecialEffectYaw(effect, angle * bj_DEGTORAD)
    Knockback_AngledNoInterrupt(caster, angle, 350)
    local units = GetUnitsInRange_EnemyTargetable(caster, aoeLoc, 240)
    for i = 1, #units do
        CauseMagicDamage_Fire(caster, units[i], damage)
    end

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
    RemoveLocation(startLoc)
    RemoveLocation(aoeLoc)
end