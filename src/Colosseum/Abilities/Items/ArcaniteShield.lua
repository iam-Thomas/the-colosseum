ItemTrigger_ArcaniteShield_Damaging = nil

RegInit(function()
    ItemTrigger_ArcaniteShield_Damaging = AddDamagingEventTrigger_TargetHasItem(FourCC('I00O'), ItemTrigger_ArcaniteShield_Damaging_Actions)
end)

function ItemTrigger_ArcaniteShield_Damaging_Actions()
    local caster = BlzGetEventDamageTarget()
    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A06Z'))

    if cooldownRemaining > 0 then
        return
    end

    local damage = GetEventDamage()
    local lifePercent = GetUnitLifePercent(caster)
    if lifePercent > 30.00 or damage < 1.00 then
        return
    end

    local casterLoc = GetUnitLoc(caster)
    BlzSetEventDamage(0.00)
    BlzStartUnitAbilityCooldown(caster, FourCC('A06Z'), 75.00)

    local effectDamage = 80.00 + BlzGetUnitArmor(caster)

    local units = GetUnitsInRange_EnemyTargetable(caster, casterLoc, 290)
    for i = 1, #units do
        local targetLoc = GetUnitLoc(units[i])
        local angle = AngleBetweenPoints(casterLoc, targetLoc)
        CauseMagicDamage(caster, units[i], effectDamage)
        CauseStun1s(caster, units[i])
        Knockback_Angled(units[i], angle, 420, nil)
    end

    CreateEffectAtPoint(casterLoc, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 2.0)
    local effectA = CreateEffectAtPoint(casterLoc, "war3mapImported\\GodsRebuke.mdl", 2.0)
    local effectB = CreateEffectAtPoint(casterLoc, "war3mapImported\\GodsRebuke.mdl", 2.0)
    local effectC = CreateEffectAtPoint(casterLoc, "war3mapImported\\GodsRebuke.mdl", 2.0)

    BlzSetSpecialEffectYaw(effectA, 000.00 / 57.2958)
    BlzSetSpecialEffectYaw(effectB, 120.00 / 57.2958)
    BlzSetSpecialEffectYaw(effectC, 240.00 / 57.2958)

    RemoveLocation(casterLoc)
end