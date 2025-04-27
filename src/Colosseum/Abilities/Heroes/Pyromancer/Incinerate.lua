AbilityTrigger_Pyro_Incinerate_Hashtable = nil
AbilityTrigger_Pyro_Incinerate_Damaging = nil
AbilityTrigger_Pyro_Incinerate_Damaged = nil

RegInit(function()
    AbilityTrigger_Pyro_Incinerate_Hashtable = InitHashtable()
    AbilityTrigger_Pyro_Incinerate_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A03O'), AbilityTrigger_Pyro_Incinerate_Damaging_Actions)
    AbilityTrigger_Pyro_Incinerate_Damaged = AddDamagedEventTrigger_TargetHasBuff(FourCC('B00Q'), AbilityTrigger_Pyro_Incinerate_Damaged_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Pyro_Incinerate_Damaging, FourCC('H00X'))
    RegisterTriggerEnableById(AbilityTrigger_Pyro_Incinerate_Damaged, FourCC('H00X'))
end)

function AbilityTrigger_Pyro_Incinerate_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    local target = BlzGetEventDamageTarget()
    
    if isAttack then
        MakeBurnt(target, 5.00)
        return
    end
end

function AbilityTrigger_Pyro_Incinerate_Damaged_Actions()
    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    if GetUnitAbilityLevel(caster, FourCC('A03O')) < 1 then
        return
    end

    if not UnitHasBuffBJ(target, FourCC('B00Q')) then
        return
    end

    if not (DAMAGE_TYPE_FIRE == BlzGetEventDamageType()) then
        return
    end

    local id = GetHandleId(target)
    local dotDamageSource = LoadUnitHandle(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 0)
    --print("dotDamageSource: " .. dotDamageSource)

    local currentAccumulatedDamage = LoadReal(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 2)
    local newAccumulatedDamage = GetEventDamage() + currentAccumulatedDamage
    SaveReal(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 2, newAccumulatedDamage)

    if dotDamageSource == nil then
        SaveUnitHandle(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 0, GetEventDamageSource())
        SaveUnitHandle(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 1, BlzGetEventDamageTarget())
        local timer = CreateTimer()
        TimerStart(timer, 1.00, true, function()
            local stop = false
            if not IsUnitAliveBJ(target) then
                stop = true
            end
            if not UnitHasBuffBJ(target, FourCC('B00Q')) then
                stop = true
            end

            if stop then
                DestroyTimer(timer)
                FlushChildHashtable(AbilityTrigger_Pyro_Incinerate_Hashtable, id)
            end

            local dotSource = LoadUnitHandle(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 0)
            local dotTarget = LoadUnitHandle(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 1)
            local accumulatedDamage = LoadReal(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 2)
            local damage = accumulatedDamage * 0.04
            CauseDefensiveDamage(dotSource, dotTarget, damage)
            SaveReal(AbilityTrigger_Pyro_Incinerate_Hashtable, id, 2, accumulatedDamage * 0.90)
        end)
    end
end