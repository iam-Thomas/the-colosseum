ItemTrigger_Greataxe = nil

RegInit(function()
    ItemTrigger_Greataxe = AddDamagedEventTrigger_CasterHasItem(FourCC('I00W'), ItemTrigger_Greataxe_Actions)
end)

function ItemTrigger_Greataxe_Actions()
    local caster = GetEventDamageSource()
    local isAttack = BlzGetEventIsAttack()

    if (not isAttack) or (not IsUnitType(caster, UNIT_TYPE_MELEE_ATTACKER)) then
        return
    end

    
    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()

    local loc = GetUnitLoc(target)

    local units = GetUnitsInRange_EnemyTargetablePhysical(caster, loc, 160)
    
    for i = 1, #units do
        if units[i] ~= target then
            CauseDefensiveDamage(caster, units[i], damage * 0.18)
        end
    end

    RemoveLocation(loc)
end