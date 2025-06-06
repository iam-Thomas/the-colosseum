RegInit(function()
    local trigger = AddAbilityCastTrigger('A03G', AbilityTrigger_Vagabond_TumbleShot)
    
    RegisterTriggerEnableById(trigger, FourCC('H00U'))
end)

function AbilityTrigger_Vagabond_TumbleShot()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local distance = 470.00
    local targetPoint = PolarProjectionBJ(casterLoc, distance, angle)
    local speed = 900.00
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A03G'))

    local arrowDamage = 25.00 + (25.00 * abilityLevel)
    local collisionDamage = 40.00 + (40.00 * abilityLevel)

    MakeElusive(caster, 1.0)
    CauseInvisStun(caster, caster)
    SetUnitAnimationByIndex(caster, 13)
    SetUnitTimeScale(caster, 3.0)

    -- practice range integration
    if UnitHasBuffBJ(caster, FourCC('B026')) then
        local prTimer = CreateTimer()
        TimerStart(prTimer, 0.1, false, function()
            DestroyTimer(prTimer)
    
            local mana = GetUnitState(caster, UNIT_STATE_MANA)
            SetUnitState(caster, UNIT_STATE_MANA, mana + 40.00)
            BlzStartUnitAbilityCooldown(caster, FourCC('A03G'), 3.0)
        end)
    end

    local totalTicks = math.floor((distance / speed) / 0.03)
    local ticks = 0
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        ticks = ticks + 1
        local stop = false
        if ticks > totalTicks then
            stop = true
        end

        if not IsUnitAliveBJ(caster) then
            stop = true
        end

        local currentLoc = GetUnitLoc(caster)
        local moveLoc = PolarProjectionBJ(currentLoc, speed * 0.03, angle)
        local pathingX = GetLocationX(moveLoc)
        local pathingY = GetLocationY(moveLoc)
        if IsTerrainPathable(pathingX, pathingY, PATHING_TYPE_WALKABILITY) then
            stop = true
        end
        
        if stop then
            DestroyTimer(timer)
            SetUnitTimeScale(caster, 1.0)

            if IsUnitAliveBJ(caster) then
                -- remove the stun
                RevokeInvisStun(caster)

                -- shoot the tumble shot
                local potentialTargets = GetUnitsInRange_EnemyTargetablePhysical(caster, currentLoc, 500)
                if #potentialTargets > 0 then
                    local target = GetClosestUnitInTableFromPoint(potentialTargets, currentLoc)
                    AbilityTrigger_Vagabond_TumbleShot_Shot(caster, currentLoc, target, arrowDamage, collisionDamage)
                end
                -- reset animation
                SetUnitAnimation(caster, "stand")

                -- valid loc
                local finalLoc = GetUnitValidLoc(currentLoc)
                SetUnitX(caster, GetLocationX(finalLoc))
                SetUnitY(caster, GetLocationY(finalLoc))
                RemoveLocation(finalLoc)
            end
            
            RemoveLocation(casterLoc)
            RemoveLocation(targetLoc)
            RemoveLocation(targetPoint)
            return
        end

        SetUnitX(caster, pathingX)
        SetUnitY(caster, pathingY)
    end)
end

function AbilityTrigger_Vagabond_TumbleShot_Shot(caster, location, target, damage, wallDamage)
    local targetLoc = GetUnitLoc(target)
    local angle = AngleBetweenPoints(location, targetLoc)
    FireHomingProjectile_PointToUnit(location, target, "Abilities\\Weapons\\BallistaMissile\\BallistaMissile.mdl", 1400, 0.01, function()
        CausePhysicalDamage_Hero(caster, target, damage)
        Knockback_Angled(target, angle, 450, function()
            CauseMagicDamage(caster, target, wallDamage)
            CauseStun2s(caster, target)
        end)
    end)
end