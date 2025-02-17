ItemTrigger_Greataxe = nil

RegInit(function()
    ItemTrigger_Greataxe = AddDamagedEventTrigger_CasterHasItem(FourCC('I00W'), ItemTrigger_Greataxe_Actions)
end)

function ItemTrigger_Greataxe_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end
    
    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()

    local loc = GetUnitLoc(target)

    local units = GetUnitsInRange_EnemyTargetablePhysical(caster, loc, 160)
    
    for i = 1, #units do
        if units[i] ~= target then
            CauseAttackDamage(caster, units[i], damage * 0.25)
        end
    end

    RemoveLocation(loc)
end