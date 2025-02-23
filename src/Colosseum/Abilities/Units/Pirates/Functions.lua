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

function SetUnitAnimationByIndexAfterDelay(unit, index, delay)
    local animationTimer = CreateTimer()
    TimerStart(animationTimer, delay, false, function()
        SetUnitAnimationByIndex( unit, index )
        DestroyTimer(animationTimer)
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