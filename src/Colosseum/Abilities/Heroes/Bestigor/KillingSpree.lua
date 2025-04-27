AbilityTrigger_BEST_KillingSpree = nil
AbilityTrigger_BEST_KillingSpree_Kill = nil

RegInit(function()
    AbilityTrigger_BEST_KillingSpree = AddAbilityCastTrigger('A08A', AbilityTrigger_BEST_KillingSpree_Actions)
    AbilityTrigger_BEST_KillingSpree_Kill = AddKillEventTrigger_KillerHasAbility(FourCC('A08A'), AbilityTrigger_BEST_KillingSpree_Kill_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_BEST_KillingSpree, FourCC('O004'))
    RegisterTriggerEnableById(AbilityTrigger_BEST_KillingSpree_Kill, FourCC('O004'))
end)

function AbilityTrigger_BEST_KillingSpree_Kill_Actions()
    local caster = GetKillingUnit()
    if not UnitHasBuffBJ(caster, FourCC('B01A')) then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A08A'))
    local duration = 10.0
    local buffAbilityCode = AbilityTrigger_BEST_KillingSpree_GetBuffAbilityId(abilityLevel)
    ApplyManagedBuff(caster, buffAbilityCode, FourCC('B01A'), duration, nil, nil)
    MakeTenacious(caster, duration)
end

function AbilityTrigger_BEST_KillingSpree_Actions()
    local caster = GetSpellAbilityUnit()
    local id = GetHandleId(caster)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A08A'))
    local duration = 10.0 + (2.0 * abilityLevel)
    local buffAbilityCode = AbilityTrigger_BEST_KillingSpree_GetBuffAbilityId(abilityLevel)

    ApplyManagedBuff(caster, buffAbilityCode, FourCC('B01A'), duration, nil, nil)
    MakeTenacious(caster, duration)
    CreateEffectOnUnitByBuff("hand left", caster, "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl", FourCC('B01A'))
    CreateEffectOnUnitByBuff("hand right", caster, "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl", FourCC('B01A'))
    CreateEffectOnUnitByBuff("chest", caster, "war3mapImported\\Windwalk Blood.mdl", FourCC('B01A'))

    local timer = CreateTimer()
    TimerStart(timer, 0.2, true, function()
        if IsUnitAliveBJ(caster) and UnitHasBuffBJ(caster, FourCC('B01A')) then
            if not IsUnitVulnerable(caster) then
                local lifePercent = GetUnitLifePercent(caster)
                SetUnitLifePercentBJ(caster, lifePercent - 2.0 * 0.2)
            end
        else
            DestroyTimer(timer)
        end        
    end)

    SetRoundCooldown_R(caster, 3)
end

function AbilityTrigger_BEST_KillingSpree_GetBuffAbilityId(abilityLevel)
    if abilityLevel > 2 then
        return FourCC('S00A')
    elseif abilityLevel > 1 then
        return FourCC('S009')
    else
        return FourCC('S002')
    end
end