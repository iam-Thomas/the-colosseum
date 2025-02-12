AbilityTrigger_Abom_Hook = nil

RegInit(function()
    AbilityTrigger_Abom_Hook = AddAbilityCastTrigger('A06N', AbilityTrigger_Abom_Hook_Actions)
end)

function AbilityTrigger_Abom_Hook_Actions()
    local caster = GetSpellAbilityUnit()
    local castLoc = GetUnitLoc(caster)
    local loc = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(castLoc, loc)
    local hookLoc = PolarProjectionBJ(castLoc, 100, angle)
    local target = nil
    RemoveLocation(loc)

    local damage = 150.00

    AddSpecialEffectLocBJ(hookLoc, "war3mapImported\\Hook.mdl") 
    local hookEffect = GetLastCreatedEffectBJ()
    BlzSetSpecialEffectYaw(hookEffect, angle / 57.2958)
    local nChainEffects = 10
    local chainEffects = {}
    for i = 1, nChainEffects do
        AddSpecialEffectLocBJ(hookLoc, "abilities\\weapons\\wyvernspear\\wyvernspearmissile.mdl")
        local ce = GetLastCreatedEffectBJ()
        BlzSetSpecialEffectPosition(ce, GetLocationX(hookLoc), GetLocationY(hookLoc), 90.00)
        BlzSetSpecialEffectYaw(ce, angle / 57.2958)
        table.insert( chainEffects, ce )
    end

    --FireProjectile_PointToPoint(startPoint, endPoint, model, speed, arcHeight, callback)

    local hookLocX = GetLocationX(hookLoc)
    local hookLocY = GetLocationY(hookLoc)
    local returning = false
    local hit = false

    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        local currentCasterLoc = GetUnitLoc(caster)
        local currentHookLoc = Location(hookLocX, hookLocY)

        local hookDistance = DistanceBetweenPoints(currentCasterLoc, currentHookLoc)
        if hookDistance > 1450.00 then
            returning = true
        end
        local newAngle = AngleBetweenPoints(currentCasterLoc, currentHookLoc)

        if hookDistance < 128.00 and returning then
            DestroyTimer(timer)
            RemoveLocation(currentCasterLoc)
            RemoveLocation(currentHookLoc)
            for i = 1, #chainEffects do
                DestroyEffect(chainEffects[i])
            end
            chainEffects = nil
            BlzSetSpecialEffectPosition(hookEffect, 0, 0, -100)
            DestroyEffect(hookEffect)
            return
        end

        for i = 1, #chainEffects do
            local chainProgress = (i) / (nChainEffects * 1.00 + 1.00)
            local targetChainLoc = PolarProjectionBJ(currentCasterLoc, hookDistance * chainProgress, newAngle)
            local chainX = GetLocationX(targetChainLoc)
            local chainY = GetLocationY(targetChainLoc)
            RemoveLocation(targetChainLoc)
            BlzSetSpecialEffectPosition(chainEffects[i], chainX, chainY, GetLocationZ(targetChainLoc) + 40)
            BlzSetSpecialEffectYaw(chainEffects[i], newAngle / 57.2958)
        end

        local angleTurn = angle
        if returning then 
            angleTurn = AngleBetweenPoints(currentHookLoc, currentCasterLoc)
        end

        local newLoc = PolarProjectionBJ(currentHookLoc, 750.00 * 0.03, angleTurn)
        local hookX = GetLocationX(newLoc)
        local hookY = GetLocationY(newLoc)
        BlzSetSpecialEffectPosition(hookEffect, hookX, hookY, GetLocationZ(newLoc) + 40)
        local hookEffectAngle = AngleBetweenPoints(currentHookLoc, currentCasterLoc)
        BlzSetSpecialEffectYaw(hookEffect, hookEffectAngle / 57.2958)
        hookLocX = GetLocationX(newLoc)
        hookLocY = GetLocationY(newLoc)

        if hit and target ~= nil then
            if IsUnit_ProjectileTargetable(target) then
                SetUnitX(target, hookX)
                SetUnitY(target, hookY)
            else
                target = nil
            end
        elseif not hit then
            local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, newLoc, 100.00)
            if #targets > 0 then
                returning = true
                hit = true
                if (IsUnit_Targetable(targets[1])) then
                    target = targets[1]
                    CauseMagicDamage(caster, target, damage)
                    CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", 3.0)
                end
            end
        end        

        RemoveLocation(currentCasterLoc)
        RemoveLocation(currentHookLoc)
    end)

    RemoveLocation(castLoc)
    RemoveLocation(hookLoc)
end