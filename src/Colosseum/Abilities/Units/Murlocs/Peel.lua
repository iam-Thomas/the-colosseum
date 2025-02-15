AbilityTrigger_Murloc_Peel_Attacking = nil

RegInit(function()
    AbilityTrigger_Murloc_Peel_Attacking = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_Murloc_Peel_Attacking, Condition(function() return GetUnitAbilityLevel(GetAttacker(), FourCC('A07R')) > 0 end))
    TriggerAddAction(AbilityTrigger_Murloc_Peel_Attacking, AbilityTrigger_Murloc_Peel_Attacking_Function)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Murloc_Peel_Attacking, EVENT_PLAYER_UNIT_ATTACKED)
end)

function AbilityTrigger_Murloc_Peel_Attacking_Function()
    local caster = GetAttacker()
    local target = GetAttackedUnitBJ()
    
    DelayedCallback(0.5, function()
        local orderString = OrderId2String(GetUnitCurrentOrder(caster))
        if orderString ~= "attack" and orderString ~= "smart" then
            return
        end

        local casterLoc = GetUnitLoc(caster)
        local targetLoc = GetUnitLoc(target)
        local dist = DistanceBetweenPoints(casterLoc, targetLoc)
        RemoveLocation(casterLoc)
        RemoveLocation(targetLoc)

        if dist > 250.00 then
            return
        end

        local angle = GetUnitFacing(caster)
        Knockback_AngledNoInterrupt(caster, angle + 180, 180, nil)
    end)
end