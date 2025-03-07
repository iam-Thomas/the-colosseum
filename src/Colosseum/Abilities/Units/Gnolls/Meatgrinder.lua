AbilityTrigger_Meatgrinder = nil

RegInit(function()
    AbilityTrigger_Meatgrinder = AddAbilityCastTrigger(MeatgrinderSID, AbilityTrigger_Meatgrinder_Actions)
end)

function AbilityTrigger_Meatgrinder_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local baseDamage = 150
    local speed = 500
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local kbMax = 400

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
    local unitGroup = CreateGroup()

    local shockwaveEffect = AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl", caster, "origin")
    BlzSetSpecialEffectScale(shockwaveEffect, 0.6)
    local tickrate = 0.03
    local distance = 0.00
    local timer = CreateTimer()
    print("start charge")
    TimerStart(timer, tickrate, true, function()
        local stopCharge = false
        if not IsUnitAliveBJ(caster) then
            stopCharge = true
        end

        local orderString = OrderId2String(GetUnitCurrentOrder(caster))
        if orderString ~= "militia" then
            stopCharge = true
        end

        if (stopCharge) then
            print("stop charge")
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
            -- local unitLoc = GetUnitLoc(targets[i])
            if (not IsUnitInGroup(targets[i], unitGroup)) then
                GroupAddUnit(unitGroup, targets[i])
                CauseDefensiveDamage(caster, targets[i], baseDamage)
                Knockback_Angled(targets[i], angle, math.max(100, kbMax - (distance / 3) + 100))
                CreateEffectOnUnit("chest", targets[i], "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", 2.00)
            end
        end

        RemoveLocation(chargeLoc)
        RemoveLocation(newLoc)
    end)
end