RegInit(function()
    local trg = AddAbilityCastTrigger('A09Z', AbilityTrigger_Knight_MarkOfChaos_Actions)
    
    RegisterTriggerEnableById(trg, FourCC('H012'))
end)

function AbilityTrigger_Knight_MarkOfChaos_Actions()
    local caster = GetSpellAbilityUnit()
    local startPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A09Z'))

    local initialDamage = 25.00 + (25.00 * abilityLevel)
    local dotDps = 4.00 + (4.00 * abilityLevel)
    local dotDpsSelf = dotDps * 0.2
    local interval = 1.00    

    local data = FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl", 700, 0.26, function()
        local areaLoc = GetUnitLoc(target)
        local targets = GetUnitsInRange_Targetable(caster, areaLoc, 190)

        CauseMagicDamage_Fire(caster, damageTarget, initialDamage)

        for i = 1, #targets do
            local damageTarget = targets[i]

            local hasBuff = IsUnitBurnt(damageTarget)
            MakeBurnt(damageTarget, 10.10)
            
            if not hasBuff then
                local timer = CreateTimer()
                TimerStart(timer, interval, true, function()
                    if not IsUnitBurnt(damageTarget) then
                        DestroyTimer(timer)
                        return
                    end
                    if IsUnitEnemy(damageTarget, GetOwningPlayer(caster)) then
                        CauseMagicDamage_Fire(caster, damageTarget, dotDps * interval)
                    else
                        CauseMagicDamage_Fire(caster, damageTarget, dotDpsSelf * interval)
                    end
                    
                end)
            else
                CauseMagicDamage_Fire(caster, damageTarget, initialDamage)
            end
    
            RemoveLocation(areaLoc)
        end
    end)

    BlzSetSpecialEffectScale(data.projectileEffect, 1.7)

    RemoveLocation(startPoint)
end