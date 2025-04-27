VagabondMultishotHashtable = nil
VagabondMultishotTrigger = nil

RegInit(function()
    VagabondMultishotHashtable = InitHashtable()
    VagabondMultishotTrigger = CreateTrigger()
    TriggerAddAction(VagabondMultishotTrigger, AbilityTrigger_Vagabond_Multishot_Attack)
    TriggerAddCondition(VagabondMultishotTrigger, Condition(function()
        return GetUnitAbilityLevel(GetAttacker(), FourCC('A03E')) > 0
    end))
    TriggerRegisterAnyUnitEventBJ(VagabondMultishotTrigger, EVENT_PLAYER_UNIT_ATTACKED)
    local castTrigger = AddAbilityCastTrigger('A03E', AbilityTrigger_Vagabond_Multishot)

    RegisterTriggerEnableById(VagabondMultishotTrigger, FourCC('H00U'))
    RegisterTriggerEnableById(castTrigger, FourCC('H00U'))
end)

function AbilityTrigger_Vagabond_Multishot()
    local caster = GetSpellAbilityUnit()
    ApplyManagedBuff(caster, FourCC('S00D'), FourCC('B025'), 10.0, nil, nil)
end

function AbilityTrigger_Vagabond_Multishot_Attack()
    local attacker = GetAttacker()
    local target = GetAttackedUnitBJ()
    local internalCooldown = 0.2

    local n = AbilityTrigger_Vagabond_Multishot_GetNMultishotTargets(attacker)

    local timer = CreateTimer()
    TimerStart(timer, 0.2, false, function()
        DestroyTimer(timer)
        local attackDamage = GetHeroDamageTotal(attacker)
        AbilityTrigger_Vagabond_Multishot_TriggerMultishot(attacker, target, n, attackDamage)
    end)
end

function AbilityTrigger_Vagabond_Multishot_GetNMultishotTargets(caster)
    local id = GetHandleId(caster)
    local internalCooldown = 0.2

    local id = GetHandleId(caster)
    local cdTime = LoadReal(VagabondMultishotHashtable, id, 0)
    if cdTime > udg_ElapsedTime then
        return 0
    end

    local hasMultishotBuff = UnitHasBuffBJ(caster, FourCC('B025'))
        or UnitHasBuffBJ(caster, FourCC('B026')) -- Target practice integration
    local index = LoadInteger(VagabondMultishotHashtable, id, 1)
    if index == 0 and not hasMultishotBuff then
        SaveInteger(VagabondMultishotHashtable, id, 1, 1)
        return 0
    end
    SaveInteger(VagabondMultishotHashtable, id, 1, 0)

    SaveReal(VagabondMultishotHashtable, id, 0, udg_ElapsedTime + internalCooldown)
    local n = 1
    if hasMultishotBuff then
        n = 3
    end
    return n
end

function AbilityTrigger_Vagabond_Multishot_TriggerMultishot(caster, primaryTarget, n, damage)
    if n < 1 then
        return
    end

    local damageFactor = 0.2 + (0.1 * GetUnitAbilityLevel(caster, FourCC('A03E')))

    local targetLoc = GetUnitLoc(primaryTarget)
    local potentialTargets = GetUnitsInRange_EnemyTargetablePhysical(caster, targetLoc, 320.00)
    local group = CreateGroup()
    GroupAddUnit(group, primaryTarget)

    for i = 1, n do
        local multishotTarget = GetClosestUnitInTableFromPoint_NotInGroup(potentialTargets, targetLoc, group)
        if multishotTarget ~= nil then
            AbilityTrigger_Vagabond_SimulateAttack(caster, multishotTarget, damage * damageFactor)
            GroupAddUnit(group, multishotTarget)
        end
    end

    DestroyGroup(group)
    RemoveLocation(targetLoc)
end