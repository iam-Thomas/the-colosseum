abilityTrigger_D_Earthquake = nil
abilityHashTable_D_Earthquake = nil

RegInit(function()
    abilityHashTable_D_Earthquake = InitHashtable()
    abilityTrigger_D_Earthquake = AddAbilityCastTrigger('A026', Ability_D_Earthquake)
    
    RegisterTriggerEnableById(abilityTrigger_D_Earthquake, FourCC('H005'))
end)

function Ability_D_Earthquake()
    local timer = CreateTimer()
    local caster = GetSpellAbilityUnit()
    local id = GetHandleId(timer)
    SaveUnitHandle(abilityHashTable_D_Earthquake, id, 0, caster)
    TimerStart(timer, 0.89, true, Ability_D_Earthquake_Callback)

    Ability_D_Earthquake_Quake(caster)
    SetRoundCooldown_R(caster, 2)
end

function Ability_D_Earthquake_Callback()
    local timer = GetExpiredTimer()
    local id = GetHandleId(timer)
    local caster = LoadUnitHandle(abilityHashTable_D_Earthquake, id, 0)

    local order = OrderId2String(GetUnitCurrentOrder(caster))
    
    if (not (order == "starfall")) then
        FlushChildHashtable(abilityHashTable_D_Earthquake, id)
        DestroyTimer(timer)
        return
    end

    Ability_D_Earthquake_Quake(caster)
end

function Ability_D_Earthquake_Quake(caster)
    local damage = 25.0 + (10.00 * GetUnitAbilityLevel(caster, FourCC('A026')))

    local point = GetUnitLoc(caster)
    local targets = GetUnitsInRange_EnemyGroundTargetable(caster, point, 400)
    for i = 1, #targets do
        local u = targets[i]
        CastDummyAbilityOnTarget(caster, u, FourCC('A04A'), 1, "slow")
        CauseMagicDamage(caster, u, damage)
    end

    local effect = AddSpecialEffectLoc("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", GetUnitLoc(caster))
    BlzSetSpecialEffectTimeScale(effect, 0.30)
    BlzSetSpecialEffectScale(effect, 1.75)
    DestroyEffect(effect)

    RemoveLocation(point)
end