AbilityTrigger_Hoplite_ArenaVeteran_Damaging = nil

RegInit(function()
    AbilityTrigger_Hoplite_ArenaVeteran_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A0A4'), AbilityTrigger_Hoplite_ArenaVeteran_Damaging_Actions)
end)

function AbilityTrigger_Hoplite_ArenaVeteran_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local target = BlzGetEventDamageTarget()

    if math.random() > 0.85 then
        MakeVulnerable(target, 5.0)
    end

    if IsUnitVulnerable(target) then
        local caster = GetEventDamageSource()
        local armor = BlzGetUnitArmor(caster)
        BlzSetEventDamage(GetEventDamage() * (1.10 + (armor / 200)))
    end
end