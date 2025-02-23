AbilityTrigger_Diveby = nil

RegInit(function()
    AbilityTrigger_Diveby = AddAbilityCastTrigger('A08M', AbilityTrigger_Diveby_Actions)
end)

function AbilityTrigger_Diveby_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local baseDamage = 150
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local distance = DistanceBetweenPoints(casterLoc, targetLoc)
    local speed = 700
    local maxTime = 10
    distance = math.min(distance, speed * maxTime)
    maxTime = distance / speed

    local defaultHeight = GetUnitFlyHeight(caster)
    SetUnitFlyHeight(caster, 15, 100)

    local shockwaveEffect = AddSpecialEffectTarget("war3mapImported\\Windwalk.mdl", caster, "origin")
    BlzSetSpecialEffectAlpha(shockwaveEffect, 80)
    local unitGroup = CreateGroup()
    local time = 0.00
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        time = time + 0.03

        local stopCharge = false
        if not IsUnitAliveBJ(caster) then
            stopCharge = true
        end

        if time > maxTime then
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
            SetUnitFlyHeight(caster, defaultHeight, 100)
            return
        end

        local chargeLoc = GetUnitLoc(caster)
        local newLoc = PolarProjectionBJ(chargeLoc, speed * 0.03, angle)
        SetUnitX(caster, GetLocationX(newLoc))
        SetUnitY(caster, GetLocationY(newLoc))

        local targets = GetUnitsInRange_EnemyGroundTargetable(caster, newLoc, 160)
        for i = 1, #targets do
            local unitLoc = GetUnitLoc(targets[i])
            local knockDir = AngleBetweenPoints(newLoc, unitLoc)
            if (not IsUnitInGroup(targets[i], unitGroup)) then
                GroupAddUnit(unitGroup, targets[i])
                CauseDefensiveDamage(caster, targets[i], baseDamage)
                Knockback_Angled(targets[i], knockDir, 500)
            end
        end

        RemoveLocation(chargeLoc)
        RemoveLocation(newLoc)
    end)
end