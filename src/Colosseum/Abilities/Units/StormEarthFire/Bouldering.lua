RegInit(function()
    AddAbilityCastTrigger('A0AO', AbilityTrigger_Sef_Bouldering)
end)

function AbilityTrigger_Sef_Bouldering()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local startLoc = PolarProjectionBJ(casterLoc, 100, angle)

    local speed = 900.00
    local speedIncrement = 100.00
    local damage = 50.00
    local damageIncrement = 25.00
    local aoe = 100.00
    local aoeIncrement = 20.00
    local scale = 2.00
    local scaleIncrement = 0.50
    local nBoulders = 8
    local nBouldersIncrement = 4
    
    -- Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl
    -- abilities\\weapons\\catapult\\catapultmissile.mdl
    local chargeEffect = AddSpecialEffectLoc("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", startLoc)
    BlzSetSpecialEffectYaw(chargeEffect, angle * bj_DEGTORAD)
    BlzSetSpecialEffectScale(chargeEffect, scale)

    local time = 0.00
    local interval = 0.03
    ChannelAbility(caster, interval, 6.0, "frostarmor", function()
        time = time + interval        
        BlzSetSpecialEffectScale(chargeEffect, scale + (scaleIncrement * time))
    end, function()
        DestroyEffect(chargeEffect)
        local speedFinal = speed + (speedIncrement * time)
        local damageFinal = damage + (damageIncrement * time)
        local endLoc = PolarProjectionBJ(startLoc, speedFinal, angle)
        local data = FireShockwaveProjectile_SingleHit(
            caster,
            startLoc,
            endLoc,
            "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl",
            speedFinal,
            aoe + (aoeIncrement * time),
            function(unit, data, loc)
                if GetUnitTypeId(unit) == FourCC('n017') then
                    AbilityTrigger_Sef_Bouldering_Shatter(caster, loc, angle, damageFinal, math.floor(nBoulders + (nBouldersIncrement * time)), speedFinal)
                    return true
                elseif IsUnit_EnemyTargetablePhysical(caster, unit) then
                    CauseNormalDamage(caster, unit, damageFinal)
                    Knockback_Angled(unit, angle, speed / 2, function() end)
                    return true
                end
            end,
            nil)
        BlzSetSpecialEffectScale(data.projectileEffect, scale + (scaleIncrement * time))

        RemoveLocation(casterLoc)
        RemoveLocation(targetLoc)
        RemoveLocation(startLoc)
        RemoveLocation(endLoc)
    end)
end

function AbilityTrigger_Sef_Bouldering_Shatter(caster, location, angle, damage, nBoulders, speed)
    for i = 1, nBoulders do
        local tmp = PolarProjectionBJ(location, math.floor(200 + (speed / 3)), angle)
        local targetLoc = PolarProjectionBJ(tmp, math.random(0, 350), math.random(0, 360))
        local distance = DistanceBetweenPoints(location, targetLoc)
        RemoveLocation(tmp)
        FireProjectile_PointToPoint(location, targetLoc, "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", 300 + (distance * 0.5), 0.4, function()
            local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, targetLoc, 140)
            RemoveLocation(targetLoc)
            for i = 1, #targets do
                CauseNormalDamage(caster, targets[i], damage / 10)
            end
        end, 0, 0)
    end
end