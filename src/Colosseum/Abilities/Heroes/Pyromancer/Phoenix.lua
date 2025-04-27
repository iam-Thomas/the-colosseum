AbilityTrigger_Pyro_Phoenix_Summoning = nil

RegInit(function()
    AbilityTrigger_Pyro_Phoenix_Summoning = CreateTrigger()
    TriggerAddAction(AbilityTrigger_Pyro_Phoenix_Summoning, AbilityTrigger_Pyro_Heartfire_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Pyro_Phoenix_Summoning, EVENT_PLAYER_UNIT_SUMMON)
    
    RegisterTriggerEnableById(AbilityTrigger_Pyro_Phoenix_Summoning, FourCC('H00X'))
end)

function AbilityTrigger_Pyro_Heartfire_Actions()
    local caster = GetSummoningUnit()
    local target = GetSummonedUnit()
    
    if not (GetUnitTypeId(target) == FourCC('h00Y')) then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A03S'))

    local casterMaxLife = BlzGetUnitMaxHP(caster)
    BlzSetUnitMaxHP(target, casterMaxLife)
    SetUnitLifePercentBJ(target, 100.00)

    local baseDamage = 70 + (20 * abilityLevel)
    local factor = GetUnitIntMultiplier(caster)
    BlzSetUnitBaseDamage(target, math.floor((baseDamage * factor) + 0.5), 0)
end