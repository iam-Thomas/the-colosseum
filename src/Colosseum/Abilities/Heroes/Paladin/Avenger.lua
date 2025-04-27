AbilityTrigger_VP_Avenger = nil
AbilityTrigger_VP_Avenger_Died = nil
AbilityTrigger_VP_Avenger_Hashtable = nil
AbilityTrigger_VP_Avenger_Damaging = nil

RegInit(function()
    AbilityTrigger_VP_Avenger_Hashtable = InitHashtable()
    AbilityTrigger_VP_Avenger = AddAbilityCastTrigger('A036', AbilityTrigger_VP_Avenger_Actions)
    AbilityTrigger_VP_Avenger_Died = CreateTrigger()
    TriggerAddAction(AbilityTrigger_VP_Avenger_Died, AbilityTrigger_VP_Avenger_Died_Actions)
    -- TriggerAddCondition(AbilityTrigger_VP_Avenger_Died, Condition(function()
    --     local unit = GetDyingUnit()
    --     local id = GetHandleId(unit)
    --     local caster = LoadUnitHandle(AbilityTrigger_VP_Avenger_Died_Hashtable, id, 0)
    --     return caster ~= nil
    -- end))
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_VP_Avenger_Died, EVENT_PLAYER_UNIT_DEATH)

    AbilityTrigger_VP_Avenger_Damaging = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_VP_Avenger_Damaging, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A036')) > 0 end))
    TriggerAddAction(AbilityTrigger_VP_Avenger_Damaging, AbilityTrigger_VP_Avenger_Damaging_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_VP_Avenger_Damaging, EVENT_PLAYER_UNIT_DAMAGING)
    
    RegisterTriggerEnableById(AbilityTrigger_VP_Avenger, FourCC('H00S'))
    RegisterTriggerEnableById(AbilityTrigger_VP_Avenger_Died, FourCC('H00S'))
    RegisterTriggerEnableById(AbilityTrigger_VP_Avenger_Damaging, FourCC('H00S'))
end)

function AbilityTrigger_VP_Avenger_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local id = GetHandleId(target)

    SaveUnitHandle(AbilityTrigger_VP_Avenger_Hashtable, id, 0, caster)

    local timer = CreateTimer()
    TimerStart(timer, 1, true, function()
        local hasBuff = UnitHasBuffBJ(target, FourCC('B00L'))
        if not hasBuff then
            FlushChildHashtable(AbilityTrigger_VP_Avenger_Hashtable, id)
            DestroyTimer(timer)
        end
    end)
end

function AbilityTrigger_VP_Avenger_Died_Actions()
    local unit = GetDyingUnit()
    local id = GetHandleId(unit)
    local caster = LoadUnitHandle(AbilityTrigger_VP_Avenger_Hashtable, id, 0)
    if caster == nil then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A036'))
    local bonusDamage = 30.00
    local bonusArmor = 10
    local healingPerSecond = 10.00
    local manaPerSecond = 5.00
    local typeFactor = 1
    
    if IsUnitType(unit, UNIT_TYPE_HERO) then
        typeFactor = 3
    end

    if abilityLevel > 1 then
        bonusDamage = 40.00
    end

    if abilityLevel > 2 then
        healingPerSecond = 20.00
    end

    GrantTempArmor(caster, bonusArmor * typeFactor, 20.00)
    GrantTempDamage(caster, bonusDamage * typeFactor, 20.00)

    local tick = 0
    local timer = CreateTimer()
    TimerStart(timer, 2.00, true, function()
        tick = tick + 1
        if tick > 10 then
            DestroyTimer(timer)
            return
        end
        
        -- times 2 because it ticks every 2 seconds
        CauseHeal(caster, caster, healingPerSecond * typeFactor * 2)

        local currentMana = GetUnitState(caster, UNIT_STATE_MANA)    
        SetUnitState(caster, UNIT_STATE_MANA, currentMana + (manaPerSecond * typeFactor * 2))
    end)

    CreateEffectOnUnit("origin", caster, "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", 5.00)
end

function AbilityTrigger_VP_Avenger_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local damage = GetEventDamage()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A034'))

    local factor = 1.12 + (0.03 * abilityLevel)

    BlzSetEventDamage(damage * factor)
end