AbilityTrigger_BEST_KillingSpree_Hashtable = nil
AbilityTrigger_BEST_KillingSpree = nil
AbilityTrigger_BEST_KillingSpree_Kill = nil

RegInit(function()
    AbilityTrigger_BEST_KillingSpree_Hashtable = InitHashtable()
    AbilityTrigger_BEST_KillingSpree = AddAbilityCastTrigger('A08A', AbilityTrigger_BEST_KillingSpree_Actions)
    AbilityTrigger_BEST_KillingSpree_Kill = AddKillEventTrigger_KillerHasAbility(FourCC('A08A'), AbilityTrigger_BEST_KillingSpree_Kill_Actions)
end)

function AbilityTrigger_BEST_KillingSpree_Kill_Actions()
    local caster = GetKillingUnit()
    --print("kill with killing spree")
    --print("got herer")
    local id = GetHandleId(caster)
    local duration = 8.0
    SaveReal(AbilityTrigger_BEST_KillingSpree_Hashtable, id, 0, udg_ElapsedTime + duration)
end

function AbilityTrigger_BEST_KillingSpree_Actions()
    local caster = GetSpellAbilityUnit()
    local id = GetHandleId(caster)
    local duration = 8.0

    ApplyManagedBuff(caster, FourCC('S002'), FourCC('B01A'), 600.0, nil, nil)
    CreateEffectOnUnitByBuff("hand left", caster, "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl", FourCC('B01A'))
    CreateEffectOnUnitByBuff("hand right", caster, "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl", FourCC('B01A'))
    CreateEffectOnUnitByBuff("chest", caster, "war3mapImported\\Windwalk Blood.mdl", FourCC('B01A'))

    SaveReal(AbilityTrigger_BEST_KillingSpree_Hashtable, id, 0, udg_ElapsedTime + duration)
    local timer = CreateTimer()
    TimerStart(timer, 0.5, true, function()
        local targetTime = LoadReal(AbilityTrigger_BEST_KillingSpree_Hashtable, id, 0)
        if (targetTime < udg_ElapsedTime) then
            DestroyTimer(timer)
            RemoveManagedBuff(caster, FourCC('S002'), FourCC('B01A'))
        end
    end)

    SetRoundCooldown_R(caster, 3)
end