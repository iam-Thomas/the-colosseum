AbilityTrigger_BM_PreciseStrike_Damaging = nil

RegInit(function()
    AbilityTrigger_BM_PreciseStrike_Damaging = AddDamagingEventTrigger_CasterHasBuff(FourCC('B000'), AbilityTrigger_BM_PreciseStrike_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_BM_PreciseStrike_Damaging, FourCC('O000'))
end)

function AbilityTrigger_BM_PreciseStrike_Actions()
    local caster = GetEventDamageSource()
    local damage = GetEventDamage()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A005'))

    local factor = 2.00
    if abilityLevel > 3 then
        factor = 3.00
    end

    BlzSetEventDamage(damage * factor)
    UnitRemoveBuffBJ(FourCC('B000'), caster)
end