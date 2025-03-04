VagabondMultishotHashtable = nil

RegInit(function()
    VagabondMultishotHashtable = InitHashtable()
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, AbilityTrigger_Vagabond_Multishot)
    --TriggerAddCondition(trigger, Condition(function() return GetUnitAbilityLevel(GetAttacker(), FourCC('A0A8')) > 0 end))
    TriggerRegisterAnyUnitEventBJ(trigger, EVENT_PLAYER_UNIT_ATTACKED)
    print("tigger registered")
end)

function AbilityTrigger_Vagabond_Multishot()
    print("multishot attack")
    local attacker = GetAttacker()
    local target = GetAttackedUnitBJ()
    local internalCooldown = 0.2

    local id = GetHandleId(attacker)
    local cdTime = LoadReal(VagabondMultishotHashtable, id, 0)
    if cdTime > udg_ElapsedTime then
        return
    end

    SaveReal(VagabondMultishotHashtable, id, 0, internalCooldown)

    local timer = CreateTimer()
    TimerStart(timer, 0.2, false, function()
        local attackDamage = GetHeroDamageTotal(attack)
        local targetLoc = GetUnitLoc(target)
        local potentialTargets = GetUnitsInRange_EnemyTargetablePhysical(attacker, targetLoc, 300.00)
        local group = CreateGroup()
        local targetA = GetClosestUnitInTableFromPoint_NotInGroup(potentialTargets, targetLoc, group)
        GroupAddUnit(group, targetA)
        local targetB = GetClosestUnitInTableFromPoint_NotInGroup(potentialTargets, targetLoc, group)

        if targetA ~= nil then
            AbilityTrigger_Vagabond_Multishot(attacker, targetA, attackDamage * 0.3)
        end

        if targetA ~= nil then
            AbilityTrigger_Vagabond_Multishot(attacker, targetA, attackDamage * 0.3)
        end
    end)
end

function AbilityTrigger_Vagabond_Multishot(caster, target, damage)
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetUnitLoc(target)
    FireProjectile_PointToPoint(casterLoc, endPoint, "Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdl", 1750, 0.06, function()
        CausePhysicalDamage_Hero(caster, target, damage)
    end, math.pi/2 * 0.08, 0.08)
end