function CauseAttack(caster, target, amount, ranged)
    UnitDamageTarget(caster, target, amount, true, ranged, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CauseAttackDamage(caster, target, amount)
    UnitDamageTarget(caster, target, amount, true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CauseNormalDamage(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CausePhysicalDamage_Hero(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

function CauseEnhancedDamage(caster, target, amount)
    UnitDamageTarget(caster, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
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
    
    -- Slowed (frozen) units receive 33% less healing
    local healAmount = amount
    if UnitHasBuffBJ(target, FourCC('Bfro')) then
        healAmount = healAmount * 0.67
    end

    local lifeCurrent = GetUnitStateSwap(UNIT_STATE_LIFE, target)
    SetUnitLifeBJ( target, ( lifeCurrent + (healAmount) ) )

    if (healAmount < 1.00) then
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

function CauseStunMini(source, target)
    CauseStunByAbility(source, target, FourCC('A08B'))
end

function CauseStun1s(source, target)
    CauseStunByAbility(source, target, FourCC('A01R'))
end

function CauseStun2s(source, target)
    CauseStunByAbility(source, target, FourCC('A065'))
end

function CauseStun3s(source, target)
    CauseStunByAbility(source, target, FourCC('A048'))
end

function CauseStun5s(source, target)
    CauseStunByAbility(source, target, FourCC('A03I'))
end

function CauseStun10s(source, target)
    CauseStunByAbility(source, target, FourCC('A01I'))
end

function CauseStunByAbility(source, target, abilityId)
    if IsUnitTenacious(target) then
        return
    end
    if ItemFunction_MedallionOfTenacity_Function(source, target) then
        return
    end
    CastDummyAbilityOnTarget(source, target, abilityId, 1, "thunderbolt")
end

function CastDummyAbilityOnTarget(caster, target, abilityId, level, orderString, dummyDuration)
    if dummyDuration == nil then
        dummyDuration = 2.00
    end
    udg_DummyOwner = GetOwningPlayer(caster)
    local loc = GetUnitLoc(target)
    udg_DummyPoint = loc
    udg_DummySkill = abilityId
    udg_DummySkillLevel = level
    udg_DummyDuration = dummyDuration
    udg_DummyOrderString = orderString
    udg_DummyCastType = "unit"
    udg_DummyTargetUnit = target
    ConditionalTriggerExecute( gg_trg_Dummy_Start )
    RemoveLocation(loc)
end

function CastDummyAbilityFromPointOnTarget(owner, target, abilityId, level, orderString, dummyPoint, dummyDuration)
    if dummyDuration == nil then
        dummyDuration = 2.00
    end
    local loc = Location(GetLocationX(dummyPoint), GetLocationY(dummyPoint))
    udg_DummyOwner = owner
    udg_DummyPoint = loc
    udg_DummySkill = abilityId
    udg_DummySkillLevel = level
    udg_DummyDuration = dummyDuration
    udg_DummyOrderString = orderString
    udg_DummyCastType = "unit"
    udg_DummyTargetUnit = target
    ConditionalTriggerExecute( gg_trg_Dummy_Start )
    RemoveLocation(loc)
end

function CastDummyAbilityOnPoint(owner, targetPoint, abilityId, level, orderString, dummyPoint, dummyDuration)
    if dummyDuration == nil then
        dummyDuration = 2.00
    end
    local loc = Location(GetLocationX(dummyPoint), GetLocationY(dummyPoint))
    local loc2 = Location(GetLocationX(targetPoint), GetLocationY(targetPoint))
    udg_DummyOwner = owner
    udg_DummyPoint = loc
    udg_DummySkill = abilityId
    udg_DummySkillLevel = level
    udg_DummyDuration = dummyDuration
    udg_DummyOrderString = orderString
    udg_DummyCastType = "point"
    udg_DummyTargetPoint = loc2
    ConditionalTriggerExecute( gg_trg_Dummy_Start )
    RemoveLocation(loc)
    RemoveLocation(loc2)
end

function CastDummyAbilityOnItem(owner, item, abilityId, level, orderString, dummyPoint, dummyDuration)
    if dummyDuration == nil then
        dummyDuration = 2.00
    end
    local loc = Location(GetLocationX(dummyPoint), GetLocationY(dummyPoint))
    udg_DummyOwner = owner
    udg_DummyPoint = loc
    udg_DummySkill = abilityId
    udg_DummySkillLevel = level
    udg_DummyDuration = dummyDuration
    udg_DummyOrderString = orderString
    udg_DummyCastType = "item"
    udg_DummyTargetItem = item
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

function GetUnitValidLoc(targetLoc)
    local item = CreateItemLoc(FourCC('I00V'), targetLoc)
    local itemLoc = GetItemLoc(item)
    RemoveItem(item)
    return itemLoc
end