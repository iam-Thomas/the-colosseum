AbilityTrigger_Mage_TouchOfTheMagi_Hashtable = nil
AbilityTrigger_Mage_TouchOfTheMagi = nil
AbilityTrigger_Mage_TouchOfTheMagi_Damaged = nil

RegInit(function()
    AbilityTrigger_Mage_TouchOfTheMagi_Hashtable = InitHashtable()
    AbilityTrigger_Mage_TouchOfTheMagi = AddAbilityCastTrigger('A07L', AbilityTrigger_Mage_TouchOfTheMagi_Actions)
    AbilityTrigger_Mage_TouchOfTheMagi_Damaged = AddDamagedEventTrigger_CasterHasAbility(FourCC('A07L'), AbilityTrigger_Mage_TouchOfTheMagi_Damaged_Actions)
end)

function AbilityTrigger_Mage_TouchOfTheMagi_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local id = GetHandleId(target)

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A07L'))
    local initialDamage = 10.00 + (abilityLevel * 10.00)

    SaveUnitHandle(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 0, caster)
    SaveReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 1, udg_ElapsedTime + 10.00)
    SaveReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 2, initialDamage)
    
    local touchEffect = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Drain\\ManaDrainTarget.mdl", target, "origin")

    local timer = CreateTimer()
    TimerStart(timer, 0.1, true, function()
        local detonate = false
        local t = LoadReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 1)
        if udg_ElapsedTime > t then
            detonate = true
        end

        if not IsUnit_Targetable(target) then
            detonate = true
        end

        if not detonate then
            return
        end

        DestroyTimer(timer)
        local storedDamage = LoadReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 2)
        FlushChildHashtable(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id)

        local loc = GetUnitLoc(target)
        local units = GetUnitsInRange_EnemyTargetable(caster, loc, 290.00)
        for i = 1, #units do
            if target ~= units[i] then
                CauseDefensiveDamage(caster, units[i], storedDamage)
            end
        end
        if IsUnitAliveBJ(target) then
            CauseDefensiveDamage(caster, target, storedDamage)
        end

        CreateEffectAtPoint(loc, "war3mapImported\\Flamestrike Starfire I.mdl", 3.0)

        DestroyEffect(touchEffect)
    end)
end

function AbilityTrigger_Mage_TouchOfTheMagi_Damaged_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if not IsDamageType_Magic(damageType) then
        return
    end

    local damage = GetEventDamage()
    if damage < 1.00 then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(target)

    local storedCaster = LoadUnitHandle(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 0)
    if storedCaster == nil then
        return
    end

    local damage = GetEventDamage()
    --SaveReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 1, udg_ElapsedTime + 4.00)
    local storedDamage = LoadReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 2)
    SaveReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, id, 2, storedDamage + (damage * 0.35))
end