RegInit(function()
    local trig = AddAbilityCastTrigger('A007', AbilityTrigger_Warden_DancingShadow)
    
    RegisterTriggerEnableById(trig, FourCC('E002'))
end)

function AbilityTrigger_Warden_DancingShadow()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A007'))

    local posX = GetLocationX(targetLoc)
    local posY = GetLocationY(targetLoc)
    SetUnitX(caster, posX)
    SetUnitY(caster, posY)
    RemoveLocation(targetLoc)

    UnitAddAbility(caster, FourCC('Avul'))    
    local ticks = 6 + (1 * abilityLevel)

    local timer = CreateTimer()
    TimerStart(timer, 0.37, true, function()
        ticks = ticks - 1
        local casterLoc = GetUnitLoc(caster)
        local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, casterLoc, 500)

        if #targets < 1 or ticks < 0 then
            UnitRemoveAbility(caster, FourCC('Avul'))
            DestroyTimer(timer)
            RemoveLocation(casterLoc)
            return
        end

        Warden_SummonAnimatedShadow_AtCasterLoc(caster, 5.0)

        local indeces = SelectRandomIndeces(#targets, 1)
        local index = indeces[1]
        local target = targets[index]

        local jumpTargetLoc = GetUnitLoc(target)
        local facing = GetUnitFacing(target)
        local jumpLoc = PolarProjectionBJ(jumpTargetLoc, 110, facing + 180)
        posX = GetLocationX(jumpLoc)
        posY = GetLocationY(jumpLoc)
        SetUnitX(caster, posX)
        SetUnitY(caster, posY)

        UnitAddAbility(caster, FourCC('A004'))
        IssueTargetOrderBJ(caster, "attack", target)

        RemoveLocation(jumpTargetLoc)
        RemoveLocation(jumpLoc)
        RemoveLocation(casterLoc)
    end)

    SetRoundCooldown_R(caster, 2)
end