AbilityTrigger_Storm_Wing = nil

RegInit(function()
    AbilityTrigger_Storm_Wing = CreateTrigger();
    TriggerAddAction(AbilityTrigger_Storm_Wing, AbilityTrigger_Storm_Wing_Actions);
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Storm_Wing, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
end)


function AbilityTrigger_Storm_Wing_Actions()
    local spellId = GetSpellAbilityId()
    
    if not (spellId == FourCC('A08T')) then
        return 
    end

    local caster = GetTriggerUnit()
    local casterLoc = GetUnitLoc(caster)
    local timerInterval = 0.25
    local areaOfEffect = 400
    local damage = 50*timerInterval
    local healing = 0.5*damage
    local effectIncrease = 1 + (0.1*timerInterval)
    local sharkhideMultiplier = 1.5

    local animationReset = 1.3
    local currentAnimation = 0
    SetUnitAnimationByIndexAfterDelay(caster, 7 , 0.03)

    local circleEffect = CreateEffectAtPoint(casterLoc, "UI\\Feedback\\TargetPreSelected\\TargetPreSelected.mdl", 10)
    local circleEffectSize = 10

    local stormEffect = CreateEffectAtPoint(casterLoc, "Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", 10)
    local stormEffectSize = 8

    Cause_Storm_Wing_Effect(caster, casterLoc, areaOfEffect, healing, damage, sharkhideMultiplier, stormEffect, stormEffectSize, circleEffect, circleEffectSize)
    

    local stormTimer = CreateTimer()
    TimerStart(stormTimer, timerInterval, true, function()


        local endChannel = false;

        currentAnimation = currentAnimation + timerInterval
        
        if (currentAnimation > animationReset) then
            SetUnitAnimationByIndex(caster, 7)
            currentAnimation = 0
        end

        if (GetUnitCurrentOrder(caster) == String2OrderIdBJ("cripple")) then
            damage = damage * effectIncrease
            healing = healing * effectIncrease
            areaOfEffect = areaOfEffect * effectIncrease
            stormEffectSize = stormEffectSize * effectIncrease
            circleEffectSize = circleEffectSize * effectIncrease
            
            endChannel = Cause_Storm_Wing_Effect(caster, casterLoc, areaOfEffect, healing, damage, sharkhideMultiplier, stormEffect, stormEffectSize, circleEffect, circleEffectSize)
        else
            endChannel = true
        end

        if endChannel then
            BlzSetSpecialEffectAlpha(stormEffect, 1)
            BlzSetSpecialEffectScale(stormEffect, 0.01)
            BlzSetSpecialEffectAlpha(circleEffect, 1)
            BlzSetSpecialEffectScale(circleEffect, 0.01)
            DestroyEffect(stormEffect)
            DestroyEffect(circleEffect)

            RemoveLocation(casterLoc)
            DestroyTimer(stormTimer)
        end
    end)

end

function Cause_Storm_Wing_Effect(caster, casterLoc, areaOfEffect, healing, damage, sharkhideMultiplier, stormEffect, stormEffectSize, circleEffect, circleEffectSize)
    local units = GetUnitsInRange_FriendlyTargetable(caster, casterLoc, areaOfEffect)
    for i = 1, #units do
        if not (IsUnitType(units[i], UNIT_TYPE_MECHANICAL)) then
            if (GetUnitAbilityLevel(units[i], FourCC('A094')) > 0) then
                CauseHeal(caster, units[i], healing * sharkhideMultiplier)
            else
                CauseHeal(caster, units[i], healing)
            end
            
        end
    end

    local foundUnits = false
    units = GetUnitsInRange_EnemyTargetable(caster, casterLoc, areaOfEffect)
    for i = 1, #units do
        CauseNormalDamage(caster, units[i], damage)
        foundUnits = true
    end

    BlzSetSpecialEffectScale(circleEffect, circleEffectSize)
    BlzSetSpecialEffectScale(stormEffect, stormEffectSize)

    return (not foundUnits)

end