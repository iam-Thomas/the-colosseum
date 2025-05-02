AbilityTrigger_Bandit_ArcaneExplosion = nil

RegInit(function()
    AbilityTrigger_Bandit_ArcaneExplosion = AddAbilityCastTrigger('A011', AbilityTrigger_Bandit_ArcaneExplosion_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Bandit_ArcaneExplosion, FourCC('h00E'))
end)

function AbilityTrigger_Bandit_ArcaneExplosion_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()
    local areaOfEffect = 320

    local effect = CreateEffectAtPoint(targetLoc, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", 5.0)
    BlzSetSpecialEffectScale(effect, 2.5)

    DangerAreaAt(targetLoc, 5.00, areaOfEffect)
    DelayedCallback(5.00, function()
        DestroyEffect(effect)

        local units = GetUnitsInRange_EnemyTargetable(caster, targetLoc, areaOfEffect)
        for i = 1, #units do
            CauseMagicDamage(caster, units[i], 175)
        end

        local effectA = CreateEffectAtPoint(targetLoc, "Units\\NightElf\\Wisp\\WispExplode.mdl", 3.0)
        BlzSetSpecialEffectScale(effectA, 1.4)
        local effectB = CreateEffectAtPoint(targetLoc, "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 3.0)
        BlzSetSpecialEffectScale(effectB, 1.4)
        RemoveLocation(targetLoc)
    end)
    
end