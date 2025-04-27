AbilityTrigger_BM_CriticalStrike_Damaging = nil

RegInit(function()
    AbilityTrigger_BM_CriticalStrike_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A001'), AbilityTrigger_BM_CriticalStrike_Damaging_Actions)

    RegisterTriggerEnableById(AbilityTrigger_BM_CriticalStrike_Damaging, FourCC('O000'))
end)

function AbilityTrigger_BM_CriticalStrike_Damaging_Actions()
    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    local random = math.random()
    local chance = 0.20
    local isvul = IsUnitVulnerable(target)

    local cdRemain = BlzGetUnitAbilityCooldownRemaining(unit, FourCC('A00N'))
    local abilityLevel = GetUnitAbilityLevel(target, FourCC('A00N'))

    if isvul then
        chance = 1.00
    end

    local damage = GetEventDamage()
    if random <= chance then
        BlzSetEventDamage(damage * 2.00)
    end
end