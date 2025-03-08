RegInit(function()
    local trigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A01D'), AbilityTrigger_Warden_DrippingVenom)
    local damagingTrigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A06T'), AbilityTrigger_Warden_ShadowStrike)
end)

function AbilityTrigger_Warden_DrippingVenom()
    if not Event_IsHitEffect() then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    AbilityTrigger_Warden_DrippingVenom_DealDamage(caster, target)
end

function AbilityTrigger_Warden_ShadowStrike()
    local animatedShadow = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local summoner = Warden_GetAnimatedShadowSummoner(animatedShadow)
    AbilityTrigger_Warden_DrippingVenom_DealDamage(summoner, target)
end

function AbilityTrigger_Warden_DrippingVenom_DealDamage(caster, target)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A01D'))
    local damage = 5.00 + (5.00 * abilityLevel)

    CauseMagicDamage(caster, target, damage)
    local effect = AddSpecialEffectTarget("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl", target, "chest")
    DestroyEffect(effect)
end