AbilityTrigger_Chainwind = nil

RegInit(function()
    AbilityTrigger_Chainwind = AddAbilityCastTrigger(ChainwindSID, AbilityTrigger_Chainwind_Actions)
end)

function AbilityTrigger_Chainwind_Actions()
    local caster = GetTriggerUnit()

    local timerInterval = 0.5
    local duration = 5.00
    local aoe = 225
    local damage = 40

    StartChainwindEffect(caster)

    DealChainwindDamage(caster, aoe, damage)

    local tick = 0
    local timer = CreateTimer()
    TimerStart(timer, timerInterval, true, function()
        tick = tick + timerInterval

        DealChainwindDamage(caster, aoe, damage)

        if (ChainwindIsOver(caster, tick, duration)) then
            FinishChainwindEffect(caster)
            DestroyTimer(timer)
        end
        
    end)

end

function StartChainwindEffect(unit)
    BlzSetUnitWeaponBooleanFieldBJ( unit, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false )
    AddUnitAnimationPropertiesBJ( true, "spin", unit )
end

function FinishChainwindEffect(unit)
    if not (unit == nil) then
        BlzSetUnitWeaponBooleanFieldBJ( unit, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, true )
        AddUnitAnimationPropertiesBJ( false, "spin", unit )
    end
end

function ChainwindIsOver(unit, tick, duration)
    local orderString = OrderId2String(GetUnitCurrentOrder(cunit))
    if orderString == "militia" then
        return true
    end

    if tick >= duration then
        return true
    end

    if not(IsUnitAliveBJ(unit)) then
        return true
    end

    return false
end

function DealChainwindDamage(caster, aoe, damage)
    if not IsUnitAliveBJ(caster) then
        return
    end

    local casterpoint = GetUnitLoc(caster)
    local targets = GetUnitsInRange_EnemyGroundTargetable(caster, casterpoint, aoe)
    
    for i = 1, #targets do
        local targetpoint = GetUnitLoc(targets[i])
        CauseNormalDamage(caster, targets[i], damage)
        Knockback_Angled(targets[i], AngleBetweenPoints(casterpoint, targetpoint), 300, nil)
        RemoveLocation(targetpoint)
    end

    RemoveLocation(casterpoint)
end
