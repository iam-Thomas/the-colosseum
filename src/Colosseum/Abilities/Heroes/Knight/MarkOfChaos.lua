RegInit(function()
    local trg = AddAbilityCastTrigger('A09Z', AbilityTrigger_Knight_MarkOfChaos_Actions)
end)

function AbilityTrigger_Knight_MarkOfChaos_Actions()
    local caster = GetSpellAbilityUnit()
    local startPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A09Z'))

    local initialDamage = 25.00 + (25.00 * abilityLevel)
    local dotDps = 4.00 + (4.00 * abilityLevel)
    local interval = 1.00    

    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", 1150, 0.06, function()
        local hasBuff = IsUnitBurnt(target)
        MakeBurnt(target, 15.10)
        
        CauseMagicDamage_Fire(caster, target, initialDamage)
        if not hasBuff then
            local timer = CreateTimer()
            TimerStart(timer, interval, true, function()
                if not IsUnitBurnt(target) then
                    DestroyTimer(timer)
                    return
                end
                CauseMagicDamage_Fire(caster, target, dotDps * interval)
            end)    
        end

        RemoveLocation(startPoint)
    end)
end