AbilityTrigger_Arashi = nil

RegInit(function()
    AbilityTrigger_Arashi = AddAbilityCastTrigger(ArashiSID, AbilityTrigger_Arashi_Actions)
end)

function AbilityTrigger_Arashi_Actions()
    LastRoninCast = GetSpellAbilityId()
    LastMirajuCast = GetSpellAbilityId()
    local thisAbilityId = GetSpellAbilityId()

    local caster = GetTriggerUnit()
    local point = GetUnitLoc(caster)

    local timerInterval = 0.33
    local arashiDuration = 5.00
    local arashiAoe = 225

    local damage = GetHeroDamageTotal(caster)
    local arashiLevel = GetUnitAbilityLevelSwapped(FourCC(ArashiSID), caster)
    local arashiDamagePerSecond = 15 + (15 * arashiLevel) + (0.5 * (damage))

    StartArashiEffect(caster)

    local illusion = GetRoninIllusion(caster, point)
    if (not (illusion == nil)) then
        StartArashiEffect(illusion)
    end

    RemoveLocation( point )

    DealArashiDamage(caster, illusion, arashiAoe, arashiDamagePerSecond * timerInterval)

    local tick = 0
    local timer = CreateTimer()
    TimerStart(timer, timerInterval, true, function()
        tick = tick + timerInterval

        DealArashiDamage(caster, illusion, arashiAoe, arashiDamagePerSecond * timerInterval)

        if (ArashiIsOver(caster, illusion, tick, arashiDuration, thisAbilityId)) then
            FinishArashiEffect(caster)
            FinishArashiEffect(illusion)
            DestroyTimer(timer)
        end
        
    end)

end

function StartArashiEffect(unit)
    BlzSetUnitWeaponBooleanFieldBJ( unit, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false )
    AddUnitAnimationPropertiesBJ( true, "spin", unit )
end

function FinishArashiEffect(unit)
    if not (unit == nil) then
        BlzSetUnitWeaponBooleanFieldBJ( unit, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, true )
        AddUnitAnimationPropertiesBJ( false, "spin", unit )
    end
end

function ArashiIsOver(ronin, illusion, tick, arashiDuration, thisAbilityId)
    if (thisAbilityId ~= LastRoninCast) then
        return true
    end

    if tick >= arashiDuration then
        return true
    end

    if not(IsUnitAliveBJ(illusion)) and not(IsUnitAliveBJ(ronin)) then
        return true
    end

    return false
end

function DealArashiDamage(caster, illusion, arashiAoe, arashiDamagePerSecond)
    local group = CreateGroup()
    local targets = nil

    if IsUnitAliveBJ(illusion) then
        local illupoint = GetUnitLoc(illusion)
        targets = GetUnitsInRange_EnemyGroundTargetable(caster, illupoint, arashiAoe)
        
        for i = 1, #targets do
            GroupAddUnit(group, targets[i])
        end

        RemoveLocation(illupoint)
    end


    if IsUnitAliveBJ(caster) then
        local casterpoint = GetUnitLoc(caster)
        targets = GetUnitsInRange_EnemyGroundTargetable(caster, casterpoint, arashiAoe)
        
        for i = 1, #targets do
            GroupAddUnit(group, targets[i])
        end

        RemoveLocation(casterpoint)
    end

    ForGroup(group, function()
        CauseNormalDamage(caster, GetEnumUnit(), arashiDamagePerSecond)
    end)

    DestroyGroup(group)
end
