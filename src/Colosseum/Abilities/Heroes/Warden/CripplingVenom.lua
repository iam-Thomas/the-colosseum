RegInit(function()
    local trigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A01D'), AbilityTrigger_Warden_CripplingVenom)
    local damagingTrigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A06T'), AbilityTrigger_Warden_ShadowStrike)
    local castTrigger = AddAbilityCastTrigger('A01D', AbilityTrigger_Warden_CripplingVenomCast)
end)

function AbilityTrigger_Warden_CripplingVenom()
    if not Event_IsHitEffect() then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    AbilityTrigger_Warden_CripplingVenom_DealDamage(caster, target)
end

function AbilityTrigger_Warden_ShadowStrike()
    local animatedShadow = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local summoner = Warden_GetAnimatedShadowSummoner(animatedShadow)
    AbilityTrigger_Warden_CripplingVenom_DealDamage(summoner, target)
end

function AbilityTrigger_Warden_CripplingVenom_DealDamage(caster, target)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A01D'))
    local damage = 5.00 + (5.00 * abilityLevel)

    CauseMagicDamage(caster, target, damage)
    local effect = AddSpecialEffectTarget("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl", target, "chest")
    DestroyEffect(effect)
end

function AbilityTrigger_Warden_CripplingVenomCast()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A01D'))
    local dps = 9.00 + (9.00 * abilityLevel)

    local startPoint = GetUnitLoc(caster)
    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Spells\\NightElf\\shadowstrike\\ShadowStrikeMissile.mdl", 900, 0, function()
        ApplySilence(caster, target, 12.1, 6.1, function(buffTarget)
            CauseMagicDamage(caster, buffTarget, dps)
        end)
    end)

    RemoveLocation(startPoint)
end