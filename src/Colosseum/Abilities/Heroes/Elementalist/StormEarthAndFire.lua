AbilityTrigger_BS_StormEarthFire = nil
AbilityTrigger_BS_StormEarthFire_Hashtable = nil

RegInit(function()
    AbilityTrigger_BS_StormEarthFire_Hashtable = InitHashtable()
    AbilityTrigger_BS_StormEarthFire = AddAbilityCastTrigger('A063', AbilityTrigger_BS_StormEarthFire_Actions)
end)

function AbilityTrigger_BS_StormEarthFire_Actions()
    local caster = GetSpellAbilityUnit()
    local id = GetHandleId(caster)

    BlzStartUnitAbilityCooldown( caster, FourCC('A05Y'), 20.00 )
    BlzStartUnitAbilityCooldown( caster, FourCC('A062'), 20.00 )
    BlzStartUnitAbilityCooldown( caster, FourCC('A00Y'), 20.00 )

    AbilityTrigger_BS_ChannelStorm_StartUnrestricted(caster, 20.00)
    AbilityTrigger_BS_ChannelEarth_StartUnrestricted(caster, 20.00)
    AbilityTrigger_BS_ChannelFire_StartUnrestricted(caster, 20.00)

    MakeEmpowered(caster, 20.00)

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A063'))
    local roundCds = 5 - abilityLevel
    SetRoundCooldown_R(caster, roundCds)
end