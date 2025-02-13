function CauseAttack(caster, target, amount, ranged)
    UnitDamageTarget(caster, target, amount, true, ranged, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CauseAttackDamage(caster, target, amount)
    UnitDamageTarget(caster, target, amount, true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CauseNormalDamage(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CauseForceDamage(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FORCE, WEAPON_TYPE_WHOKNOWS)
end

function CauseMagicDamage(caster, target, amount)
    --UnitDamageTargetBJ(caster, target, amount, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC )
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
end

function CauseMagicDamage_Enhanced(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
end

function CauseMagicDamage_Fire(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
end

function CauseDefensiveDamage(caster, target, amount)
    --UnitDamageTargetBJ(caster, target, amount, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC )
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DEFENSIVE, WEAPON_TYPE_WHOKNOWS)
end

function CauseHealUnscaled(caster, target, amount)
    if not IsUnitAliveBJ(target) then
        return
    end

    local lifeCurrent = GetUnitStateSwap(UNIT_STATE_LIFE, target)
    SetUnitLifeBJ( target, ( lifeCurrent + (amount) ) )

    if (amount < 1.00) then
        return
    end

    local text = "+" .. math.floor(amount)
    local point = GetUnitLoc(target)
    local x = GetLocationX(point) + (math.random() * 2 - 1) * 15
    local y = GetLocationY(point) + (math.random() * 2 - 1) * 15
    local z = GetLocationZ(point)

    local floatingText = CreateTextTag()
    SetTextTagTextBJ(floatingText, text, 8)
    SetTextTagPos(floatingText, x, y, z)
    SetTextTagColor(floatingText, 0, 255, 0, 255)
    SetTextTagPermanent(floatingText, false)
    SetTextTagLifespan(floatingText, 1.00)
    SetTextTagVelocity(floatingText, 0.0, 0.03)
    SetTextTagVisibility(floatingText, true)

    RemoveLocation(point)
end

function CauseHeal(source, target, amount)
    local factor = GetUnitIntMultiplier(source)
    CauseHealUnscaled(source, target, (amount * factor) )
end

function CauseManaBurnUnscaled(target, amount)
    local manaCurrent = GetUnitStateSwap(UNIT_STATE_MANA, target)
    SetUnitManaBJ( target, ( manaCurrent - amount ) )
end

function CauseStun1s(source, target)
    CastDummyAbilityOnTarget(source, target, FourCC('A01R'), 1, "thunderbolt")
end

function CauseStun2s(source, target)
    CastDummyAbilityOnTarget(source, target, FourCC('A065'), 1, "thunderbolt")
end

function CauseStun3s(source, target)
    CastDummyAbilityOnTarget(source, target, FourCC('A048'), 1, "thunderbolt")
end

function CauseStun5s(source, target)
    CastDummyAbilityOnTarget(source, target, FourCC('A03I'), 1, "thunderbolt")
end

function CastDummyAbilityOnTarget(caster, target, abilityId, level, orderString)
    udg_DummyOwner = GetOwningPlayer(caster)
    local loc = GetUnitLoc(target)
    udg_DummyPoint = loc
    udg_DummySkill = abilityId
    udg_DummySkillLevel = level
    udg_DummyDuration = 2.00
    udg_DummyOrderString = orderString
    udg_DummyCastType = "unit"
    udg_DummyTargetUnit = target
    ConditionalTriggerExecute( gg_trg_Dummy_Start )
    RemoveLocation(loc)
end

function GetUnitStrMultiplier(caster)
    local val = GetHeroStr(caster, true)
    local sum = 100.00 + (val * 1.00)
    local multiplier = sum / 100
    return multiplier
end

function GetUnitAgiMultiplier(caster)
    local val = GetHeroAgi(caster, true)
    local sum = 100.00 + (val * 1.00)
    local multiplier = sum / 100
    return multiplier
end

function GetUnitIntMultiplier(caster)
    local val = GetHeroInt(caster, true)
    local sum = 100.00 + (val * 1.00)
    local multiplier = sum / 100
    return multiplier
end