AbilityTrigger_Organ_Cannon_Fire = nil

RegInit(function()
    AbilityTrigger_Organ_Cannon_Fire = AddAbilityCastTrigger('A08P', AbilityTrigger_Organ_Cannon_Fire_Actions)
end)

function AbilityTrigger_Organ_Cannon_Fire_Actions()
    local fireRate = 1
    local totalCannonballs = 12
    local damage = 100
    local cannonballRange = 1500
    local unitKnockbackDistance = 500
    local cannonballSpeed = 800

    local caster = GetTriggerUnit()
    local targetPoint = GetSpellTargetLoc()
    local startPoint = GetUnitLoc(caster)
    local castAngle = AngleBetweenPoints(startPoint, targetPoint)
    local inFrontPoint = PolarProjectionBJ(startPoint, 25, castAngle)

    local widthOfCannon = 150
    local farOffset = (widthOfCannon/4.0) * 1.5
    local closeOffset = (widthOfCannon/4.0) * 0.5

    local cannonballStartPoint = {
        PolarProjectionBJ(inFrontPoint, farOffset, castAngle-90),
        PolarProjectionBJ(inFrontPoint, closeOffset, castAngle-90),
        PolarProjectionBJ(inFrontPoint, closeOffset, castAngle+90),
        PolarProjectionBJ(inFrontPoint, farOffset, castAngle+90),
    }

    local cannonballTargetPoint = {
        PolarProjectionBJ(cannonballStartPoint[1], cannonballRange, castAngle),
        PolarProjectionBJ(cannonballStartPoint[2], cannonballRange, castAngle),
        PolarProjectionBJ(cannonballStartPoint[3], cannonballRange, castAngle),
        PolarProjectionBJ(cannonballStartPoint[4], cannonballRange, castAngle),
    }

    local cannonballs = 0
    local cannonTimer = CreateTimer()
    TimerStart(cannonTimer, fireRate, true, function()

        cannonballs = cannonballs + 1
        local cannonballModulo = ModuloInteger((cannonballs-1), 4) + 1

        local animationIndex = 2 + cannonballModulo
        SetUnitAnimationByIndex( caster, animationIndex )

        print("here")
        PlaySoundAtPoint(CannonTowerMissileLaunch2, 100, inFrontPoint, 65)
        print("here2")

        FireShockwaveProjectile_SingleHit(caster, cannonballStartPoint[cannonballModulo], cannonballTargetPoint[cannonballModulo], "war3mapImported\\Cannonball.mdl", cannonballSpeed, 65, function(hitUnit, projectile)
    
            if( IsUnit_EnemyTargetablePhysical(caster, hitUnit)) then
                -- should be mini-stun of 0.3 or so seconds --
                CauseStun1s(caster, hitUnit)
                if UnitHasBuffBJ(caster, FourCC('B018')) then
                    CauseNormalDamage(caster, hitUnit, damage*1.25)
                else
                    CauseNormalDamage(caster, hitUnit, damage)
                end
                Knockback_Angled(hitUnit, castAngle, unitKnockbackDistance, nil)

                return true
            end
            if( GetUnitTypeId(hitUnit) == FourCC('o00H')) then
                KillUnit(hitUnit)
                return true
            end

            return false
    
        end)

        if cannonballs >= totalCannonballs or (not (GetUnitCurrentOrder(caster) == String2OrderIdBJ("cripple"))) then
            DestroyTimer(cannonTimer)
            RemoveLocation(cannonballStartPoint[1])
            RemoveLocation(cannonballStartPoint[2])
            RemoveLocation(cannonballStartPoint[3])
            RemoveLocation(cannonballStartPoint[4])
            RemoveLocation(cannonballTargetPoint[1])
            RemoveLocation(cannonballTargetPoint[2])
            RemoveLocation(cannonballTargetPoint[3])
            RemoveLocation(cannonballTargetPoint[4])
            RemoveLocation(startPoint)
            RemoveLocation(targetPoint)
            RemoveLocation(inFrontPoint)
            unitCallback = nil
        end

    end)

end
