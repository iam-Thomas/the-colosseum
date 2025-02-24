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

function Knockback_Explosion_EnemyTargetable(caster, point, range, distance, damage)
    units = GetUnitsInRange_EnemyTargetable(caster, point, range)

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

function GetUnitLonelyLoc(targetLoc, area)
    local loc = GetUnitValidLoc(targetLoc)

    for i = 1, 100 do
        if IsLocationEmpty(loc, area) then
            return loc
        end
        local angle = math.random() * 2 * math.pi
        local newX = GetLocationX(loc) + area * math.cos(angle)
        local newY = GetLocationY(loc) + area * math.sin(angle)
        RemoveLocation(loc)
        temploc = Location(newX, newY)
        loc = GetUnitValidLoc(temploc)
        RemoveLocation(temploc)
    end
    
    return loc
end

function IsLocationEmpty(loc, area)
    local group = CreateGroup()
    GroupEnumUnitsInRange(group, GetLocationX(loc), GetLocationY(loc), area, nil)
    local isEmpty = (FirstOfGroup(group) == nil)
    DestroyGroup(group)
    return isEmpty
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

        if not UnitHasBuffBJ(target, buffId) then
            flush = true
        end

        if udg_ElapsedTime > t then
            flush = true
        end

        if flush then
            UnitRemoveAbility(target, abilityId)
            --Cant flush child specific tables (child key), flushing (cleanup) should happens in AbilitiesCommonCleanup.lua
            --instead just set the time for the buff to 0.00
            SaveReal(ManagedBuffHashtable, id, abilityId, 0.00)
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

function RemoveManagedManagedBuff(target, abilityId, buffId)
    RemoveManagedBuff(target, abilityId, buffId)
end

function RemoveManagedBuff(target, abilityId, buffId)
    if GetUnitAbilityLevel(target, abilityId) < 1 then
        return
    end

    UnitRemoveAbility(target, abilityId)
    UnitRemoveBuffBJ(buffId, target)
end

function FireProjectile_PointToPoint(startPoint, endPoint, model, speed, arcHeight, callback, startingPitch, pitchRotation)
    return FireProjectile_PointHeightToPoint(startPoint, 50.00, endPoint, model, speed, arcHeight, callback, startingPitch, pitchRotation)
end

--startingPitch of 0 => it starts at normal pitch
--startingPitch of math.pi (180 degrees) => it starts upside down
--startingPitch of math.pi/2 (90 degrees) => it starts halfway pitched looking up
--startingPitch of (math.pi*3)/2 (270 degrees) => it starts halfwatch pitched looking down

--pitchRotation of 0 => it does not move its pitch
--pitchRotation of math.pi => it rotatates halfway around its axis (so from upside down back to rightside up)
--pitchRotation of 2*math.pi => it does a full rotation (so from upside down a full circle to upside down again)
--pitchRotation of 8*math.pi => it does a 4 full rotations, so looking as if its tumbling around
function FireProjectile_PointHeightToPoint(startPoint, startHeight, endPoint, model, speed, arcHeight, callback, startingPitch, pitchRotation)
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
    BlzSetSpecialEffectPosition( projectile, startX, startY, startHeight )

    local projectileData = { projectileEffect = projectile }

    if arcHeight == nil then
        arcHeight = 0
    end
    if startHeight == nil then
        startHeight = 0
    end

    if pitchRotation == nil then
        --assumption: a projectile usually rotates from looking 45 degrees up to 90 degrees down, so a rotation of 135 degrees = (math.pi*2)/3
        pitchRotation = (math.pi*2)/3
    end
    
    local currentPitch = 0
    if startingPitch == nil then
        --assumption: a projectile usually starts looking 45 degrees up = math.pi/4
        startingPitch = -(math.pi/4)
        currentPitch = GetStartingPitch(startHeight, arcHeightReal, pitchRotation, startingPitch)
    else
        currentPitch = startingPitch
    end

    BlzSetSpecialEffectOrientation( projectile, angle, currentPitch, 0.0 )

    local pitchIncrement = 0
    if totalTicks > 0 then
        pitchIncrement = (((startingPitch + pitchRotation) - currentPitch) / totalTicks)
    end

    local timer = CreateTimer()
    TimerStart(timer, tickRate, true, function()
        ticks = ticks + 1
        local progress = ticks / totalTicks
        local currentX = startX + (endX - startX) * progress
        local currentY = startY + (endY - startY) * progress
        local currentZ = startZ + (endZ - startZ) * progress + arcHeightReal * 4 * progress * (1 - progress) -- Parabolic arc

        BlzSetSpecialEffectPosition( projectile, currentX, currentY, currentZ )

        if (pitchIncrement > 0) then
            currentPitch = currentPitch + pitchIncrement
            BlzSetSpecialEffectOrientation( projectile, angle, currentPitch, 0.0 )
        end

        if ticks >= totalTicks then
            DestroyTimer(timer)
            callback(projectileData)
            DestroyEffect(projectile)
        end
    end)

    return projectileData
end

--startHeight = the height of the unit (usually 50)
--arcHeightReal = the maximum height the projectile will get to during travel
--pitchRotation = the amount of radians the projectile's pitch will rotate during its travel (usually math.pi)
--startingPitch = the amount of radians the projectile starts pre-angled, which differs per model (usually 0)
function GetStartingPitch(startHeight, arcHeightReal, pitchRotation, startingPitch)
    --if startHeight is 0, the projectile starts at the regular staringPitch
    --if the startHeight is 100, and the maximum height (arcHeightReal) is 200, it should start pre-pitched 25% of the way so startingPitch + 0.25*pitchRotation
    --if the startHeight is 200, and the maximum height (arcHeightReal) is 200, it should start pre-pitched 50% of the way so startingPitch + 0.5*pitchRotation
    --if the startHeight is 10000, and the maximum height (arcHeightReal) is 200, just keep it simple and stick to 50% pre-pitched maximum
    local pitchRatio = startHeight / (arcHeightReal * 2)
    local pitchRatio = math.min(0.5, pitchRatio)

    return startingPitch + (pitchRotation * pitchRatio)
end

function FireProjectile_PointToPoint_NoPitch(startPoint, endPoint, model, speed, arcHeight, callback)
    return FireProjectile_PointHeightToPoint(startPoint, 50.00, endPoint, model, speed, arcHeight, callback, 0, 0)
end

function FireProjectile_PointHeightToPoint_NoPitch(startPoint, startHeight, endPoint, model, speed, arcHeight, callback)
    return FireProjectile_PointHeightToPoint(startPoint, startHeight, endPoint, model, speed, arcHeight, callback, 0, 0)
end

function FireHomingProjectile_PointToUnit(startPoint, targetUnit, model, speed, arcHeight, callback)
    return FireHomingProjectile_PointToUnit_TimeLimit(startPoint, targetUnit, model, speed, arcHeight, callback, 999999.00)
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

    local data = { projectileEffect = projectile }

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
                callback(data)
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

    return data
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

function FireShockwaveProjectile_SingleHit(caster, startPoint, endPoint, model, speed, unitHitRange, unitCallback)
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
            unitCallback = nil
        end

        local pnt = Location(currentX, currentY)
        if unitCallback ~= nil then
            local units = GetUnitsInRange_Targetable(caster, pnt, unitHitRange)
            for i = 1, #units do
                if not IsUnitInGroup(units[i], hitGroup) then
                    GroupAddUnit(hitGroup, units[i])
                    local isHit = unitCallback(units[i], projectile)
                    if (isHit) then
                        ticks = 9999999
                        i = 9999999
                    end
                end
            end
        end

        RemoveLocation(pnt)
    end)
end