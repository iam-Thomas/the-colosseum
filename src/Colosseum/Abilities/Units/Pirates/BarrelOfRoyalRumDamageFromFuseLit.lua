AbilityTrigger_Barrel_Of_Royal_Rum_Damage_From_Fuse_Lit = nil

RegInit(function()
    AbilityTrigger_Barrel_Of_Royal_Rum_Damage_From_Fuse_Lit = AddDamagingEventTrigger_CasterHasAbility(FourCC('A08Z'), AbilityTrigger_Barrel_Of_Royal_Rum_Damage_From_Fuse_Lit_Actions)
end)

function AbilityTrigger_Barrel_Of_Royal_Rum_Damage_From_Fuse_Lit_Actions()
    local damageTarget = BlzGetEventDamageTarget()
    local damageSource = GetEventDamageSource()
    if( GetUnitTypeId(damageTarget) == FourCC('o00H')) then
        KillUnit(damageTarget)
    end
end