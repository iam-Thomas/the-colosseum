AbilityTrigger_Undead_Infest = nil
AbilityTrigger_Undead_Infest_Hashtable = nil

RegInit(function()
    AbilityTrigger_Undead_Infest_Hashtable = InitHashtable()
    AbilityTrigger_Undead_Infest = AddDamagedEventTrigger_CasterHasAbility(FourCC('A04K'), AbilityTrigger_Undead_Infest_Actions)
end)

function AbilityTrigger_Undead_Infest_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    AbilityFunction_Undead_InfestTarget(caster, target, 0.40)
end