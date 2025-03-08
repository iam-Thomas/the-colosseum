RegInit(function()
    local trigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A03H'), AbilityTrigger_Warden_VoidCoating)
    local damagingTrigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A06T'), AbilityTrigger_Warden_VoidAttack)
end)

function AbilityTrigger_Warden_VoidCoating()
    if not Event_IsHitEffect() then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    AbilityTrigger_Warden_VoidCoating_DealDamage(caster, target)
end

function AbilityTrigger_Warden_VoidAttack()
    local animatedShadow = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local summoner = Warden_GetAnimatedShadowSummoner(animatedShadow)
    AbilityTrigger_Warden_VoidCoating_DealDamage(summoner, target)
end

function AbilityTrigger_Warden_VoidCoating_DealDamage(caster, target)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A03H'))
    local damage = 5.00 + (5.00 * abilityLevel)

    CauseMagicDamage(caster, target, damage)
    local effect = AddSpecialEffectTarget("Abilities\\Spells\\Other\\BlackArrow\\BlackArrowMissile.mdl", target, "chest")
    DestroyEffect(effect)
end