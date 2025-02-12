AbilityTrigger_BEST_Deep_Wounds = nil
AbilityTrigger_BEST_Deep_Wounds_Hashtable = nil

RegInit(function()
    AbilityTrigger_BEST_Deep_Wounds_Hashtable = InitHashtable()
    AbilityTrigger_BEST_Deep_Wounds = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_BEST_Deep_Wounds, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A02S')) > 0 end))
    TriggerAddAction(AbilityTrigger_BEST_Deep_Wounds, AbilityTrigger_BEST_Deep_Wounds_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_BEST_Deep_Wounds, EVENT_PLAYER_UNIT_DAMAGED)
end)

function AbilityTrigger_BEST_Deep_Wounds_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(target)
    local ticksDefault = 4
    
    local storedCaster = LoadUnitHandle(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 0)
    if storedCaster == nil then
        SaveUnitHandle(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 0, caster)
        local timer = CreateTimer()
        TimerStart(timer, 1, true, function()
            local bleedValue = LoadReal(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 1)
            local ticksRemain = LoadInteger(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 2)
            
            CauseDefensiveDamage(caster, target, bleedValue * 0.20)

            if ticksRemain - 1 < 1 then
                FlushChildHashtable(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id)
                DestroyTimer(timer)
            else
                SaveInteger(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 2, ticksRemain - 1)
            end
        end)
    end

    local damage = GetEventDamage()
    local storedDamage = LoadReal(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 1)
    SaveReal(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 1, math.max(storedDamage, damage))
    SaveInteger(AbilityTrigger_BEST_Deep_Wounds_Hashtable, id, 2, ticksDefault)

    CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", 2.00)
end