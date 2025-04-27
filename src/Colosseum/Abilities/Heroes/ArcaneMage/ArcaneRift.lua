AbilityTrigger_Mage_ArcaneRift_Hashtable = nil
AbilityTrigger_Mage_ArcaneRift = nil
AbilityTrigger_Mage_ArcaneRift_Attacking = nil
AbilityTrigger_Mage_ArcaneRift_CastAny = nil

RegInit(function()
    AbilityTrigger_Mage_ArcaneRift_Hashtable = InitHashtable()
    AbilityTrigger_Mage_ArcaneRift = AddAbilityCastTrigger('A07M', AbilityTrigger_Mage_ArcaneRift_Actions)
    AbilityTrigger_Mage_ArcaneRift_Attacking = CreateTrigger()
    TriggerAddAction(AbilityTrigger_Mage_ArcaneRift_Attacking, AbilityTrigger_Mage_ArcaneRift_Attacking_Actions)
    TriggerAddCondition(AbilityTrigger_Mage_ArcaneRift_Attacking, Condition(function()
        return GetUnitAbilityLevel(GetAttacker(), FourCC('A07M')) > 0
    end))
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Mage_ArcaneRift_Attacking, EVENT_PLAYER_UNIT_ATTACKED)
    AbilityTrigger_Mage_ArcaneRift_CastAny = AddAbilityCastTrigger_CasterHasAbility(FourCC('A07M'), AbilityTrigger_Mage_ArcaneRift_CastAny_Actions)

    RegisterTriggerEnableById(AbilityTrigger_Mage_ArcaneRift, FourCC('H010'))
    RegisterTriggerEnableById(AbilityTrigger_Mage_ArcaneRift_Attacking, FourCC('H010'))
    RegisterTriggerEnableById(AbilityTrigger_Mage_ArcaneRift_CastAny, FourCC('H010'))
end)

function AbilityTrigger_Mage_ArcaneRift_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()
    local id = GetHandleId(caster)

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A07M'))
    local damage = 70.00 + (abilityLevel * 70.00)
    local storedTarget = LoadUnitHandle(AbilityTrigger_Mage_ArcaneRift_Hashtable, id, 0)

    if (storedTarget ~= nil) and (IsUnitAliveBJ(storedTarget)) then
        -- move the unit
        local touchId = GetHandleId(storedTarget)
        local touchCaster = LoadUnitHandle(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, touchId, 0)

        local isResistant = IsUnitResistant(storedTarget)
        local teleportLoc = Location(GetLocationX(targetLoc), GetLocationY(targetLoc))
        if isResistant then
            local unitLoc = GetUnitLoc(storedTarget)
            local angle = AngleBetweenPoints(unitLoc, teleportLoc)
            local distance = DistanceBetweenPoints(unitLoc, teleportLoc)
            local tempLoc = teleportLoc
            teleportLoc = PolarProjectionBJ(unitLoc, math.min(350, distance), angle)
            RemoveLocation(tempLoc)
        end

        -- damage
        local calculatedLoc = GetUnitValidLoc(teleportLoc)
        if GetUnitDefaultMoveSpeed(storedTarget) > 1.0 then
            SetUnitX(storedTarget, GetLocationX(calculatedLoc))
            SetUnitY(storedTarget, GetLocationY(calculatedLoc))
        end
        CauseMagicDamage(caster, storedTarget, damage)
        CauseStun3s(caster, storedTarget)
        RemoveLocation(teleportLoc)
        RemoveLocation(calculatedLoc)

        if touchCaster ~= nil then
            -- change the touch timer to 0.1 seconds after dealing damage to the target
            SaveReal(AbilityTrigger_Mage_TouchOfTheMagi_Hashtable, touchId, 1, udg_ElapsedTime + 0.1)
        end
    end

    RemoveLocation(targetLoc)
end

function AbilityTrigger_Mage_ArcaneRift_Attacking_Actions()
    local attacker = GetAttacker()
    local id = GetHandleId(attacker)
    local target = GetAttackedUnitBJ()
    SaveUnitHandle(AbilityTrigger_Mage_ArcaneRift_Hashtable, id, 0, target)
end

function AbilityTrigger_Mage_ArcaneRift_CastAny_Actions()
    local caster = GetSpellAbilityUnit()
    local id = GetHandleId(caster)
    local target = GetSpellTargetUnit()
    if target == nil then
        return
    end

    SaveUnitHandle(AbilityTrigger_Mage_ArcaneRift_Hashtable, id, 0, target)
end