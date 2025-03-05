AbilityTrigger_Meatgrinder = nil

RegInit(function()
    AbilityTrigger_Meatgrinder = AddAbilityCastTrigger(MeatgrinderSID, AbilityTrigger_Meatgrinder_Actions)
end)

function AbilityTrigger_Meatgrinder_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local baseDamage = 150
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local totalDistance = 1400
    local speed = 700
    local maxTime = 5
    local tickrate = 0.03

    local distance = 0.00
    local time = 0.00
    local timer = CreateTimer()
    TimerStart(timer, tickrate, true, function()
        time = time + tickrate

        local stopCharge = false
        if not IsUnitAliveBJ(caster) then
            stopCharge = true
        end

        if time > maxTime then
            stopCharge = true
        end

        if distance > maxDistance then
            stopCharge = true
        end

        local orderString = OrderId2String(GetUnitCurrentOrder(caster))
        if orderString ~= "militia" then
            stopCharge = true
        end

        if (stopCharge) then
            RemoveLocation(casterLoc)
            RemoveLocation(targetLoc)
            DestroyGroup(unitGroup)
            DestroyTimer(timer)
            DestroyEffect(shockwaveEffect)
            return
        end

        local chargeLoc = GetUnitLoc(caster)
        local newLoc = PolarProjectionBJ(chargeLoc, speed * tickrate, angle)
        SetUnitX(caster, GetLocationX(newLoc))
        SetUnitY(caster, GetLocationY(newLoc))

        distance = distance + (speed * tickrate)

        local targets = GetUnitsInRange_EnemyGroundTargetable(caster, newLoc, 130)
        for i = 1, #targets do
            local unitLoc = GetUnitLoc(targets[i])
            if (not IsUnitInGroup(targets[i], unitGroup)) then
                local remainingDistance = maxDistance - distance
                GroupAddUnit(unitGroup, targets[i])
                CauseDefensiveDamage(caster, targets[i], baseDamage)
                Knockback_Angled(targets[i], angle, remainingDistance + 50)
            end
        end

        RemoveLocation(chargeLoc)
        RemoveLocation(newLoc)
    end)
end