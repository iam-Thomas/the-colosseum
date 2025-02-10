function Knockback_Angled(target, angle, force, collisionCallback)
    OrderStop(target)
    Knockback_AngledNoInterrupt(target, angle, force, collisionCallback)
end

function Knockback_AngledNoInterrupt(target, angle, force, collisionCallback)
    local velocity = force
    local timer = CreateTimer()
    local time = 0.00
    TimerStart(timer, 0.03, true, function()
        time = time + 0.03
        if time > 1.02 then
            DestroyTimer(timer)
            return
        end

        if not IsUnit_Targetable(target) then
            DestroyTimer(timer)
            return
        end

        local point = GetUnitLoc(target)
        local targetPoint = PolarProjectionBJ(point, velocity * 0.03 * 3.2, angle)
        local pathingPoint = PolarProjectionBJ(targetPoint, 50, angle)
        local x = GetLocationX(targetPoint)
        local y = GetLocationY(targetPoint)
        local pathingX = GetLocationX(pathingPoint)
        local pathingY = GetLocationY(pathingPoint)
        
        if IsTerrainPathable(pathingX, pathingY, PATHING_TYPE_WALKABILITY) then
            DestroyTimer(timer)
            if collisionCallback ~= nil then
                collisionCallback(target)
            end
            RemoveLocation(point)
            RemoveLocation(targetPoint)
            RemoveLocation(pathingPoint)
            return
        end

        SetUnitX(target, x)
        SetUnitY(target, y)
        velocity = velocity * 0.91
        RemoveLocation(point)
        RemoveLocation(targetPoint)
        RemoveLocation(pathingPoint)
    end)
end

function Knockback_Explosion_EnemyGroundTargetable(caster, point, range, distance, damage)
    units = GetUnitsInRange_EnemyGroundTargetable(caster, point, range)

    for i = 1, #units do
        local u = units[i]
        local unitPos = GetUnitLoc(u)
        local angle = AngleBetweenPoints(point, unitPos)

        Knockback_Angled(u, angle, distance)

        if (damage > 0) then
            CauseMagicDamage(caster, u, damage)
        end

        RemoveLocation(unitPos)
    end
end

ManagedBuffHashtable = InitHashtable()
function ApplyManagedBuff(target, abilityId, buffId, duration, effectAttachmentPoint, effect)
    ApplyManagedBuff_Predicate(target, abilityId, buffId, duration, effectAttachmentPoint, effect, function(target)
        return false
    end)
end

function ApplyManagedBuff_Magic(target, abilityId, buffId, duration, effectAttachmentPoint, effect)
    ApplyManagedBuff_Predicate(target, abilityId, buffId, duration, effectAttachmentPoint, effect, function(target)
        return not IsUnit_Targetable(target)
    end)
end

function ApplyManagedBuff_MagicElusive(target, abilityId, buffId, duration, effectAttachmentPoint, effect)
    ApplyManagedBuff_Predicate(target, abilityId, buffId, duration, effectAttachmentPoint, effect, function(target)
        return not IsUnit_ProjectileTargetable(target)
    end)
end

function ApplyManagedBuff_Predicate(target, abilityId, buffId, duration, effectAttachmentPoint, effect, evadePredicate)
    local id = GetHandleId(target)

    if evadePredicate(target) then
        return
    end

    local abilityLevelAtStart = GetUnitAbilityLevel(target, abilityId)
    UnitAddAbility(target, abilityId)
    local currentTargetTime = LoadReal(ManagedBuffHashtable, id, abilityId)
    SaveReal(ManagedBuffHashtable, id, abilityId, math.max(udg_ElapsedTime + duration, currentTargetTime))

    if abilityLevelAtStart > 0 then
        return
    end

    local sfx = nil
    if effect ~= nil then
        AddSpecialEffectTargetUnitBJ(effectAttachmentPoint, target, effect)
        sfx = GetLastCreatedEffectBJ()
    end

    local timer = CreateTimer()
    TimerStart(timer, 0.20, true, function()
        local flush = false
        local t = LoadReal(ManagedBuffHashtable, id, abilityId)

        if not IsUnitAliveBJ(target) then
            flush = true
        end

        if evadePredicate(target) then
            flush = true
        end

        if udg_ElapsedTime > t then
            flush = true
        end

        if flush then
            UnitRemoveAbility(target, abilityId)
            FlushChildHashtable(ManagedBuffHashtable, id)
            DestroyTimer(timer)
            UnitRemoveBuffBJ(buffId, target)

            if sfx ~= nil then
                local sfxTimer = CreateTimer()
                TimerStart(sfxTimer, 0.1, true, function()
                    if UnitHasBuffBJ(target, buffId) then
                        return
                    end
                    DestroyTimer(sfxTimer)
                    DestroyEffect(sfx)
                end)
            end
            return
        end
    end)
end

function FireProjectile_PointToPoint(startPoint, endPoint, model, speed, arcHeight, callback)
    FireProjectile_PointHeightToPoint(startPoint, 50.00, endPoint, model, speed, arcHeight, callback)
end

function FireProjectile_PointHeightToPoint(startPoint, startHeight, endPoint, model, speed, arcHeight, callback)
    local startX = GetLocationX(startPoint)
    local startY = GetLocationY(startPoint)
    local startZ = GetLocationZ(startPoint) + startHeight
    local endX = GetLocationX(endPoint)
    local endY = GetLocationY(endPoint)
    local endZ = GetLocationZ(endPoint)
    local angle = Atan2(endY - startY, endX - startX)
    local distance = SquareRoot((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY))
    local duration = distance / speed
    local arcHeightReal = distance * arcHeight
    local ticks = 0
    local tickRate = 0.03
    local totalTicks = duration / tickRate

    local projectile = AddSpecialEffect(model, startX, startY)
    BlzSetSpecialEffectYaw(projectile, angle)
    -- BlzSetSpecialEffectPitch(projectile, 90.00)
    -- BlzSetSpecialEffectScale(projectile, 0.50)

    local timer = CreateTimer()
    TimerStart(timer, tickRate, true, function()
        ticks = ticks + 1
        local progress = ticks / totalTicks
        local currentX = startX + (endX - startX) * progress
        local currentY = startY + (endY - startY) * progress
        local currentZ = startZ + (endZ - startZ) * progress + arcHeightReal * 4 * progress * (1 - progress) -- Parabolic arc

        BlzSetSpecialEffectPosition(projectile, currentX, currentY, currentZ)

        if ticks >= totalTicks then
            DestroyTimer(timer)
            DestroyEffect(projectile)
            callback()
        end
    end)
end

function FireHomingProjectile_PointToUnit(startPoint, targetUnit, model, speed, arcHeight, callback)
    FireHomingProjectile_PointToUnit_TimeLimit(startPoint, targetUnit, model, speed, arcHeight, callback, 999999.00)
end

function FireHomingProjectile_PointToUnit_TimeLimit(startPoint, targetUnit, model, speed, arcHeight, callback, timeLimit)
    local fizzled = false
    local fizzleLoc = GetUnitLoc(targetUnit)
    local startX = GetLocationX(startPoint)
    local startY = GetLocationY(startPoint)
    local startZ = GetLocationZ(startPoint) + 50.00
    local endX = GetUnitX(targetUnit)
    local endY = GetUnitY(targetUnit)
    local endZ = BlzGetUnitZ(targetUnit)
    local distance = SquareRoot((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY))
    local arcHeightReal = distance * arcHeight

    local projectile = AddSpecialEffect(model, startX, startY)
    
    local currentPoint = Location(startX, startY)
    local totalTime = 0.00
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        totalTime = totalTime + 0.03
        if not (IsUnit_ProjectileTargetable(targetUnit)) and not fizzled then
            fizzled = true
            RemoveLocation(fizzleLoc)
            fizzleLoc = GetUnitLoc(targetUnit)
        end

        local targetPoint = GetUnitLoc(targetUnit)
        if fizzled then
            RemoveLocation(targetPoint)
            targetPoint = Location(GetLocationX(fizzleLoc), GetLocationY(fizzleLoc))
        end
        local dist = DistanceBetweenPoints(currentPoint, targetPoint)
        if dist <= (speed * 0.04) or totalTime > timeLimit then
            DestroyTimer(timer)
            DestroyEffect(projectile)
            RemoveLocation(currentPoint)
            RemoveLocation(targetPoint)
            if not fizzled and totalTime <= timeLimit then
                callback()
            end

            if fizzled then
                RemoveLocation(fizzleLoc)
            end
            return
        end

        local currentPosX = GetLocationX(currentPoint)
        local currentPosY = GetLocationY(currentPoint)
        local currentPosZ = GetLocationZ(currentPoint)

        local newEndX = GetLocationX(targetPoint)
        local newEndY = GetLocationY(targetPoint)
        local newEndZ = GetLocationZ(targetPoint) + 50.00

        local angle = Atan2(newEndY - currentPosY, newEndX - currentPosX)
        local progress = (distance - dist) / distance
        progress = math.min(1, progress)
        progress = math.max(0, progress)
        
        local targetLoc = PolarProjectionBJ(currentPoint, speed * 0.03, angle * 57.2958)
        local currentX = GetLocationX(targetLoc)
        local currentY = GetLocationY(targetLoc)
        local currentZ = startZ + (endZ - startZ) * progress + arcHeightReal * 4 * progress * (1 - progress) -- Parabolic arc

        BlzSetSpecialEffectYaw(projectile, angle)
        BlzSetSpecialEffectPosition(projectile, currentX, currentY, currentZ)

        RemoveLocation(currentPoint)
        currentPoint = targetLoc
        RemoveLocation(targetPoint)
    end)
end

function FireShockwaveProjectile(caster, startPoint, endPoint, model, speed, unitHitRange, unitCallback, periodicCallback)
    local startX = GetLocationX(startPoint)
    local startY = GetLocationY(startPoint)
    local startZ = GetLocationZ(startPoint) + 50.00
    local endX = GetLocationX(endPoint)
    local endY = GetLocationY(endPoint)
    local endZ = GetLocationZ(endPoint) + 50.00
    local angle = Atan2(endY - startY, endX - startX)
    local distance = SquareRoot((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY))
    local duration = distance / speed
    local ticks = 0
    local tickRate = 0.03
    local totalTicks = duration / tickRate

    local projectile = AddSpecialEffect(model, startX, startY)
    BlzSetSpecialEffectYaw(projectile, angle)

    local hitGroup = CreateGroup()

    local timer = CreateTimer()
    TimerStart(timer, tickRate, true, function()
        ticks = ticks + 1
        local progress = ticks / totalTicks
        local currentX = startX + (endX - startX) * progress
        local currentY = startY + (endY - startY) * progress
        local currentZ = startZ + (endZ - startZ) * progress + 0 * 4 * progress * (1 - progress) -- Parabolic arc

        BlzSetSpecialEffectPosition(projectile, currentX, currentY, currentZ)

        if ticks >= totalTicks then
            DestroyTimer(timer)
            DestroyGroup(hitGroup)
            DestroyEffect(projectile)
            RemoveLocation(startPoint)
            RemoveLocation(endPoint)
            unitCallback = nil
        end

        local pnt = Location(currentX, currentY)
        if unitCallback ~= nil then
            local units = GetUnitsInRange_Targetable(caster, pnt, unitHitRange)
            for i = 1, #units do
                if not IsUnitInGroup(units[i], hitGroup) then
                    GroupAddUnit(hitGroup, units[i])
                    unitCallback(units[i])
                end
            end
        end

        if periodicCallback ~= nil then
            periodicCallback(pnt)
        end

        RemoveLocation(pnt)
    end)
end
