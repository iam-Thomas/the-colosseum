AbilityTrigger_BEST_Headbutt = nil

RegInit(function()
    AbilityTrigger_BEST_Headbutt = AddAbilityCastTrigger('A02J', AbilityTrigger_BEST_Headbutt_Actions)
end)

function AbilityTrigger_BEST_Headbutt_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local strength = GetHeroStr(caster, true)
    local strengthFactor = 0.75
    if IsUnitTenacious(caster) then
        strengthFactor = strengthFactor * 2.25
        -- local cdTimer = CreateTimer()
        -- TimerStart(cdTimer, 0.1, false, function()
        --     BlzStartUnitAbilityCooldown(caster, FourCC('A02J'), 1, 4.0)
        --     DestroyTimer(cdTimer)
        -- end)
    end
    local cdTimer = CreateTimer()
    TimerStart(cdTimer, 0.1, false, function()
        BlzStartUnitAbilityCooldown(caster, FourCC('A02J'), 1, 8.0)
        DestroyTimer(cdTimer)
    end)
    local baseDamage = strength * strengthFactor
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local distance = DistanceBetweenPoints(casterLoc, targetLoc)
    local speed = 700
    local maxTime = 1.1
    distance = math.min(distance, speed * maxTime)
    maxTime = distance / speed    

    local shockwaveEffect = AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl", caster, "origin")
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
        if orderString ~= "militia" then -- The order string of the headbutt ability is "militia"
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
                Knockback_Angled(targets[i], knockDir, 100 + (240.00 * ((maxTime - time) / maxTime)))
            end
        end

        RemoveLocation(chargeLoc)
        RemoveLocation(newLoc)
    end)
end