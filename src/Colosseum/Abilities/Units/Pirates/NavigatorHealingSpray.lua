AbilityTrigger_Navigator_Healing_Spray = nil

RegInit(function()
    AbilityTrigger_Navigator_Healing_Spray = CreateTrigger();
    TriggerAddAction(AbilityTrigger_Navigator_Healing_Spray, AbilityTrigger_Navigator_Healing_Spray_Actions);
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Navigator_Healing_Spray, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
end)

function AbilityTrigger_Navigator_Healing_Spray_Actions()
    local spellId = GetSpellAbilityId()
    
    if not (spellId == FourCC('A08Q')) then
        return 
    end

    local caster = GetTriggerUnit()
    local targetPoint = GetSpellTargetLoc()
    local timerInterval = 1
    local healAmount = 35*timerInterval
    local areaOfEffect = 300
    local sharkhideMultiplier = 1.5

    local healingTimer = CreateTimer()
    TimerStart(healingTimer, timerInterval, true, function()
        if (GetUnitCurrentOrder(caster) == String2OrderIdBJ("healingspray")) then
            local units = GetUnitsInRange_FriendlyTargetable(caster, targetPoint, areaOfEffect)
            for i = 1, #units do
                if not (IsUnitType(units[i], UNIT_TYPE_MECHANICAL)) then
                    if (GetUnitAbilityLevel(units[i], FourCC('A094')) > 0) then
                        CauseHeal(caster, units[i], healAmount * sharkhideMultiplier)
                    else
                        CauseHeal(caster, units[i], healAmount)
                    end
                    
                end
            end
        else
            RemoveLocation(targetPoint)
            DestroyTimer(healingTimer)
        end
    end)
end
