AbilityTrigger_OrcWarlord_Crush_Hashtable = nil

RegInit(function()
    AbilityTrigger_OrcWarlord_Crush_Hashtable = InitHashtable()
    local trg = AddDamagingEventTrigger_CasterHasAbility(FourCC('A08H'), AbilityTrigger_OrcWarlord_Crush_Damaging_Actions)
end)

function AbilityTrigger_OrcWarlord_Crush_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local attackCountToProc = 11

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(caster)

    local index = LoadInteger(AbilityTrigger_OrcWarlord_Crush_Hashtable, id, 0) + 1
    if index < attackCountToProc then
        SaveInteger(AbilityTrigger_OrcWarlord_Crush_Hashtable, id, 0, index)
        local dangerNumber = attackCountToProc - index
        if dangerNumber < 6 then
            local loc = GetUnitLoc(caster)
            DangerTextAt(tostring(dangerNumber) .. "!", loc, 1.11, 0.40 + (8 - dangerNumber) / 8)
            RemoveLocation(loc)
        end

        return
    end
    
    SaveInteger(AbilityTrigger_OrcWarlord_Crush_Hashtable, id, 0, 0)
    if IsUnitElusive(target) or IsUnitTenacious(target) then
        CauseStun5s(caster, caster)
        return
    end
    
    CauseStun3s(caster, target)
    MakeVulnerable(target, 7.00)
    BlzSetEventDamage(GetEventDamage() * 2.5)
end