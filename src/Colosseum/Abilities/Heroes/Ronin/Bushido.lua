AbilityTrigger_Bushido = nil

RegInit(function()
    AbilityTrigger_Bushido = AddAbilityCastTrigger(BushidoSID, AbilityTrigger_Bushido_Actions)
end)

function AbilityTrigger_Bushido_Actions()
    LastRoninCast = GetSpellAbilityId()

    local caster = GetTriggerUnit()
    local point = GetUnitLoc(caster)
    local targetPoint = GetSpellTargetLoc()

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC(BushidoSID))
    local bushidoDistance = 900
    local bushidoSpeed = 50
    local bushidoAoe = 150
    local damage = GetHeroDamageTotal(caster)
    local damageFactor = 2.0 + (0.00 * abilityLevel)
    local bushidoDamageBaseDamage = 50 + (100 * abilityLevel)
    local bushidoDamage = bushidoDamageBaseDamage + (damage * damageFactor)

    SetRoundCooldown_R(caster, 1)

    local roninAngle = AngleBetweenPoints(point, targetPoint)
    
    CastDummyAbilityOnTarget(caster, caster, FourCC('A03J'), 1, "creepthunderbolt")
    SetUnitPathing(caster, false)

    local illusion = GetRoninIllusion(caster, point)
    local illusionAngle = 0
    local illuFirstPoint = nil
    if (not (illusion == nil)) then
        IssueImmediateOrderBJ( illusion, "stop" )
        SetUnitFacingToFaceLocTimed( illusion, targetPoint, 0.10 )
        SetUnitPathing(illusion, false)
        CastDummyAbilityOnTarget(illusion, illusion, FourCC('A03J'), 1, "creepthunderbolt")
        illuFirstPoint = GetUnitLoc(illusion)
        illusionAngle = AngleBetweenPoints(illuFirstPoint, targetPoint)
    end

    local illusionEffect = nil
    local roninEffect = nil

    local state = "cast animation"
    local roninHasFinished = false
    local illusionHasFinished = false

    local victims = CreateGroup()

    local roninDistanceTravelled = 0
    local illusionDistanceTravelled = 0
    local timercount = 0
    local targets = nil
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        timercount = timercount + 3
        if (state == "cast animation") then
            if (timercount == 3) then
                if (IsUnitAliveBJ(illusion)) then
                    SetUnitAnimationByIndex( illusion, 4 )
                    SetUnitTimeScalePercent( illusion, 120.00 )
                end
                if (IsUnitAliveBJ(caster)) then
                    SetUnitAnimationByIndex( caster, 4 )
                    SetUnitTimeScalePercent( caster, 120.00 )
                end
            end

            if (timercount == 66) then
                if (IsUnitAliveBJ(illusion)) then
                    SetUnitAnimationByIndex( illusion, 8 )
                    SetUnitTimeScalePercent( illusion, 135.00 )
                    illusionEffect = AddSpecialEffectTargetUnitBJ("weapon", illusion, "war3mapImported\\Windwalk Blood.mdx")
                end
                if (IsUnitAliveBJ(caster)) then
                    SetUnitAnimationByIndex( caster, 8 )
                    SetUnitTimeScalePercent( caster, 135.00 )
                    roninEffect = AddSpecialEffectTargetUnitBJ("weapon", caster, "war3mapImported\\Windwalk Blood.mdx")
                end
            end

            if (timercount >= 80) then
                if (IsUnitAliveBJ(illusion)) then
                    SetUnitTimeScalePercent( illusion, 25.00 )
                end
                if (IsUnitAliveBJ(caster)) then
                    SetUnitTimeScalePercent(caster, 25.00 )
                end
                timercount = 0
                state = "charge"
            end
        end

        if (state == "charge") then

            illusionDistanceTravelled = illusionDistanceTravelled + bushidoSpeed
            roninDistanceTravelled = roninDistanceTravelled + bushidoSpeed

            if (IsUnitAliveBJ(illusion) and not(illusionHasFinished)) then
                local illupoint = GetUnitLoc(illusion)
                local illumovepoint = PolarProjectionBJ(illupoint, bushidoSpeed, illusionAngle)
                
                if (PointIsBushidoEligible(illumovepoint)) then
                    SetUnitPositionLoc( illusion, illumovepoint )
                else
                    illusionDistanceTravelled = bushidoDistance
                end
                targets = GetUnitsInRange_EnemyGroundTargetable(illusion, illumovepoint, bushidoAoe)
                if (not(targets == nil)) then
                    for i = 1, #targets do
                        if (not IsUnitInGroup(targets[i], victims)) then
                            GroupAddUnit(victims, targets[i])
                        end
                    end
                end
                DestroyGroup(minigroup)
                RemoveLocation( illupoint )
                RemoveLocation( illumovepoint )
            end
        
            if (IsUnitAliveBJ(caster) and not(roninHasFinished)) then

                local casterpoint = GetUnitLoc(caster)
                local castermovepoint = PolarProjectionBJ(casterpoint, bushidoSpeed, roninAngle)
                if (PointIsBushidoEligible(castermovepoint)) then
                    SetUnitPositionLoc( caster, castermovepoint )
                else
                    roninDistanceTravelled = bushidoDistance
                end

                targets = GetUnitsInRange_EnemyGroundTargetable(caster, castermovepoint, bushidoAoe)
                if (not(targets == nil)) then
                    for i = 1, #targets do
                        if (not IsUnitInGroup(targets[i], victims)) then
                            GroupAddUnit(victims, targets[i])
                        end
                    end
                end

                RemoveLocation( casterpoint )
                RemoveLocation( castermovepoint )
            end

            if ((not(IsUnitAliveBJ(illusion))) or (illusionDistanceTravelled >= bushidoDistance)) and ( not illusionHasFinished) then
                illusionHasFinished = true
                if (IsUnitAliveBJ(illusion)) then
                    SetUnitAnimation( illusion, "stand cinematic" )
                    SetUnitTimeScalePercent( illusion, 180.00 )
                end
            end
            
            if (not(IsUnitAliveBJ(caster)) or roninDistanceTravelled >= bushidoDistance) and (not roninHasFinished) then
                roninHasFinished = true
                if (IsUnitAliveBJ(caster)) then
                    SetUnitAnimation( caster, "stand cinematic" )
                    SetUnitTimeScalePercent( caster, 180.00 )
                end

            end

            if illusionHasFinished and roninHasFinished then
                timercount = 0
                state = "final animation"
            end
            
        end

        if (state == "final animation") then
                
            if (timercount == 180) then
                if ((IsUnitAliveBJ(caster))) then
                    SetUnitTimeScalePercent( caster, 100.00 )
                    AddSpecialEffectTargetUnitBJ( "weapon", caster, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl" )
                    DestroyEffectBJ( GetLastCreatedEffectBJ() )
                    SetUnitPathing( caster, true )
                end
                if roninEffect ~= nil then
                    DestroyEffectBJ(roninEffect)
                end       
    
                if ((IsUnitAliveBJ(illusion))) then
                    SetUnitTimeScalePercent( illusion, 100.00 )
                    AddSpecialEffectTargetUnitBJ( "weapon", illusion, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl" )
                    DestroyEffectBJ( GetLastCreatedEffectBJ() )
                    SetUnitPathing( illusion, true )
                end
                if illusionEffect ~=  nil then
                    DestroyEffectBJ(illusionEffect)
                end

                ForGroup(victims, function()
                    local unit = GetEnumUnit()
                    if ( UnitHasBuffBJ(caster, FourCC(JinadaBID)) ) then
                        CauseNormalDamage(caster, unit, bushidoDamage * 1.15)
                    else
                        CauseNormalDamage(caster, unit, bushidoDamage)
                    end
                    local effect = AddSpecialEffectTargetUnitBJ("chest", unit, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
                    DestroyEffectBJ(effect)
                end)
                
            end

            if (timercount >= 200) then
                if (IsUnitAliveBJ(illusion)) then
                    ResetUnitAnimation( illusion )
                    UnitRemoveBuffBJ(FourCC('B00O'), illusion)
                end
                if (IsUnitAliveBJ(caster)) then
                    ResetUnitAnimation( caster )
                    UnitRemoveBuffBJ(FourCC('B00O'), caster)
                end
                DestroyGroup(victims)
                RemoveLocation( point )
                RemoveLocation( targetPoint )
                RemoveLocation( illuFirstPoint )
                DestroyTimer(timer)
            end
        end

    end)
end

function PointIsBushidoEligible(point)

    if (IsTerrainPathable(GetLocationX(point), GetLocationY(point), PATHING_TYPE_WALKABILITY)) then
        return false
    end

    return true
end
