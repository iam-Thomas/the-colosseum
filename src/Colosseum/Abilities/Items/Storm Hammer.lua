ItemTrigger_StormHammer_Damaging = nil
ItemTrigger_StormHammer_Damaged = nil

RegInit(function()
    ItemTrigger_StormHammer_Damaging = AddDamagingEventTrigger_CasterHasItem(FourCC('I00T'), ItemTrigger_StormHammer_Damaging_Actions)
    ItemTrigger_StormHammer_Damaged = AddDamagedEventTrigger_CasterHasItem(FourCC('I00T'), ItemTrigger_StormHammer_Damaged_Actions)
end)

function ItemTrigger_StormHammer_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A07H'))
    if cooldownRemaining > 0 then
        return
    end
    
    local damage = GetEventDamage()
    BlzSetEventDamage((damage * 1.15) + 30)
end

function ItemTrigger_StormHammer_Damaged_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A07H'))
    if cooldownRemaining > 0 then
        return
    end

    local target = BlzGetEventDamageTarget()    
    local damage = GetEventDamage()

    BlzStartUnitAbilityCooldown(caster, FourCC('A07H'), 15.00)

    local loc = GetUnitLoc(target)
    local units = GetUnitsInRange_EnemyTargetablePhysical(caster, loc, 220)
    
    for i = 1, #units do
        if units[i] ~= target then
            CauseDefensiveDamage(caster, units[i], damage * 0.5)
        end
        CastDummyAbilityOnTarget(caster, units[i], FourCC('A07I'), 1, "slow")
    end

    CreateEffectAtPoint(loc, "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 2.0)
    RemoveLocation(loc)
end