AbilityTrigger_Jinada = nil

RegInit(function()
    AbilityTrigger_Jinada = AddAbilityCastTrigger(JinadaSID, AbilityTrigger_Jinada_Actions)
end)


function AbilityTrigger_Jinada_Actions()
    LastRoninCast = GetSpellAbilityId()
    LastMirajuCast = GetSpellAbilityId()
    local caster = GetTriggerUnit()
    local point = GetUnitLoc(caster)

    AddSpecialEffectLocBJ( point, "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl" )
    DestroyEffectBJ( GetLastCreatedEffectBJ() )

    local jinadaLevel = GetUnitAbilityLevelSwapped(FourCC(JinadaSID), caster)

    CastDummyAbilityOnTarget(caster, caster, FourCC(JinadaBuffSID), jinadaLevel, "bloodlust")
    MakeElusive(caster, 8)

    local illusion = GetRoninIllusion(caster, point)
    if (not (illusion == nil)) then
        CastDummyAbilityOnTarget(caster, illusion, FourCC(JinadaBuffSID), jinadaLevel, "bloodlust")
        MakeElusive(illusion, 8)
    end

    RemoveLocation( point )
end

AbilityTrigger_Jinada_Extra_Damage_Dealer = nil

RegInit(function()
    AbilityTrigger_Jinada_Extra_Damage_Dealer = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ( AbilityTrigger_Jinada_Extra_Damage_Dealer, EVENT_PLAYER_UNIT_DAMAGED )
    TriggerAddAction( AbilityTrigger_Jinada_Extra_Damage_Dealer, Trig_Jinada_Extra_Damage_Dealer_Actions )
end)

function Trig_Jinada_Extra_Damage_Dealer_Actions()
    local source = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    if ( UnitHasBuffBJ(source, FourCC(JinadaBID)) ) then
        local abilityLevel = GetUnitAbilityLevel(source, FourCC(JinadaSID))
        local damageFactor = 1.09 + 0.03 * abilityLevel
        BlzSetEventDamage( ( GetEventDamage() * damageFactor ) )
    end

    if ( UnitHasBuffBJ(target, FourCC(JinadaBID)) ) then
        BlzSetEventDamage( ( GetEventDamage() * 1.25 ) )
    end
end