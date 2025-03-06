AbilityTrigger_Gnoll_Explosive = nil

RegInit(function()
    AbilityTrigger_Gnoll_Explosive = AddAbilityCastTrigger(GnollExplosiveSID, AbilityTrigger_Gnoll_Explosive_Actions)
end)

function AbilityTrigger_Gnoll_Explosive_Actions()
    local caster = GetSpellAbilityUnit()
    local castPoint = GetSpellTargetLoc()
    local timerInterval = 0.05
    local blowUpTime = 6
    local explosionDamage = 200

    local scaling = 2.00
    local targetScaling = 3.00
    local color = 255
    local targetColor = 0

    -- local colorChangePerTick = (targetcolor - color) * (timerInterval / blowUpTime)
    -- local scalingChangePerTick = (targetScaling - scaling) * (timerInterval / blowUpTime)

    local explosive = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC(GnollExplosiveUID), castPoint, 0)

    DangerCountdownAt(castPoint, blowUpTime, function() return not IsUnitAliveBJ(explosive) end)

    local time = 0.00
    local timer = CreateTimer()
    TimerStart(timer, timerInterval, true, function()
        time = time + timerInterval

        -- color = color + colorChangePerTick
        -- scaling = scaling + scalingChangePerTick

        -- SetUnitVertexColor(explosive, 255, color, color, 255)
        -- SetUnitScale(explosive, scaling, scaling, scaling)

        if time > blowUpTime then
            KillUnit(explosive)
            local targets = GetUnitsInRange_EnemyTargetable(caster, castPoint, 350)
            for i = 1, #targets do
                local target = targets[i]
                local targetLoc = GetUnitLoc(targets[i])
                local angle = AngleBetweenPoints(castPoint, targetLoc)
                CauseMagicDamage(caster, target, explosionDamage)
                Knockback_Angled(target, angle, 340, nil)
            end
            local effect = AddSpecialEffectLoc("Abilities\\Weapons\\Mortar\\MortarMissile.mdl", castPoint)
            BlzSetSpecialEffectTimeScale(effect, 0.4)
            BlzSetSpecialEffectScale(effect, 2.00)
            DestroyEffect(effect)

            --CastDummyAbilityOnPoint(GetOwningPlayer(caster), castPoint, FourCC(GnollExplosiveDummySID), 1, "flamestrike", castPoint)
            RemoveLocation(castPoint)
            DestroyTimer(timer)
        end
        
    end)

end