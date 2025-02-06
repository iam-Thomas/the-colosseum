AbilityTrigger_Raider_Ensnare = nil

RegInit(function()
    AbilityTrigger_Raider_Ensnare = AddAbilityCastTrigger('A049', AbilityTrigger_Raider_Ensnare_Actions)
end)

function AbilityTrigger_Raider_Ensnare_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local startPoint = GetUnitLoc(caster)
    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl", 1250.00, 0.04, function()
        RemoveLocation(startPoint)

        if not IsUnit_Targetable(target) then
            return
        end

        MakeVulnerable(target, 4.00)

        --Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl
        local netEffect = AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Ensnare\\ensnare_AirTarget.mdl", target, "chest")

        local timer = CreateTimer()
        local t = 0.00
        TimerStart(timer, 0.03, true, function()
            t = t + 0.03
            if t >= 3.99 then
                DestroyTimer(timer)
                DestroyEffect(netEffect)
                return
            end

            local stopEffect = false
            
            local casterLoc = GetUnitLoc(caster)
            local targetLoc = GetUnitLoc(target)
            -- conditions

            if not IsUnit_Targetable(target) then
                stopEffect = true
            end

            -- drag check
            local distance = DistanceBetweenPoints(casterLoc, targetLoc)

            if distance > 400 then
                stopEffect = true
            end

            if stopEffect then
                DestroyTimer(timer)
                DestroyEffect(netEffect)
                return
            end

            if distance < 160.00 then
                return
            end

            -- drag
            local dragAngle = AngleBetweenPoints(targetLoc, casterLoc)
            local moveLoc = PolarProjectionBJ(targetLoc, 650 * 0.03, dragAngle)
            local x = GetLocationX(moveLoc)
            local y = GetLocationY(moveLoc)
            SetUnitX(target, x)
            SetUnitY(target, y)
        end)
    end)    
end