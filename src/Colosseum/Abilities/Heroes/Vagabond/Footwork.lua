AbilityTrigger_Vaga_FootworkHashtable = nil

RegInit(function()
    AbilityTrigger_Vaga_FootworkHashtable = InitHashtable()
    local trigger = AddPeriodicPassiveAbility_Interval_CasterHasAbility(FourCC('A0A8'), 0.20, AbilityTrigger_Vaga_Footwork_Periodic)

    local attackTrigger = CreateTrigger()
    TriggerAddAction(attackTrigger, AbilityTrigger_Vaga_Footwork_Attack)
    TriggerAddCondition(attackTrigger, Condition(function()
        return GetUnitAbilityLevel(GetAttacker(), FourCC('A0A8')) > 0
    end))
    TriggerRegisterAnyUnitEventBJ(attackTrigger, EVENT_PLAYER_UNIT_ATTACKED)
end)

function AbilityTrigger_Vaga_Footwork_Periodic(caster, tick)
    if not IsUnitAliveBJ(caster) then
        return
    end

    if UnitHasBuffBJ(unit, FourCC('BSTN')) or UnitHasBuffBJ(unit, FourCC('BPSE')) then
        return
    end

    local id = GetHandleId(caster)
    local cooldownUntil = LoadReal(AbilityTrigger_Vaga_FootworkHashtable, id, 0)

    if udg_ElapsedTime < cooldownUntil then
        return
    end

    AbilityTrigger_Vaga_Footwork_InvokeCooldown(caster)

    local target = AbilityTrigger_Vaga_Footwork_FindTarget(caster, 750)
    if target == nil then
        return
    end

    local attackDamage = GetHeroDamageTotal(caster)
    AbilityTrigger_Vagabond_SimulateAttack(caster, target, attackDamage * 0.7)

    -- multishot integration
    if GetUnitAbilityLevel(caster, FourCC('A03E')) > 0 then
        local nMultishotTargets = AbilityTrigger_Vagabond_Multishot_GetNMultishotTargets(caster)
        AbilityTrigger_Vagabond_Multishot_TriggerMultishot(caster, target, nMultishotTargets, attackDamage * 0.7)
    end
end

function AbilityTrigger_Vaga_Footwork_InvokeCooldown(caster)
    local id = GetHandleId(caster)
    local agi = GetHeroAgi(caster, true)
    -- should be agi * [attack speed increase per agility point]
    local targetCooldown = 2.00 / (1.00 + ((agi * 1.5) / 100.00))
    SaveReal(AbilityTrigger_Vaga_FootworkHashtable, id, 0, udg_ElapsedTime + targetCooldown + 0.05)
end

function AbilityTrigger_Vaga_Footwork_Attack()
    local caster = GetAttacker()
    local target = GetAttackedUnitBJ()
    local id = GetHandleId(caster)
    SaveUnitHandle(AbilityTrigger_Vaga_FootworkHashtable, id, 1, target)
    AbilityTrigger_Vaga_Footwork_InvokeCooldown(caster)
end

function AbilityTrigger_Vaga_Footwork_FindTarget(caster, range)
    local id = GetHandleId(caster)
    local target = LoadUnitHandle(AbilityTrigger_Vaga_FootworkHashtable, id, 1)
    local casterPoint = GetUnitLoc(caster)

    if IsUnitAliveBJ(target) then
        local targetPoint = GetUnitLoc(target)
        local distance = DistanceBetweenPoints(casterPoint, targetPoint)
        RemoveLocation(targetPoint)
        if distance < range then            
            RemoveLocation(casterPoint)
            return target
        end
    end

    local units = GetUnitsInRange_EnemyTargetablePhysical(caster, casterPoint, range)
    target = GetClosestUnitInTableFromPoint(units, casterPoint)
    if target ~= nil then
        SaveUnitHandle(AbilityTrigger_Vaga_FootworkHashtable, id, 1, target)
    end

    RemoveLocation(casterPoint)
    return target
end
