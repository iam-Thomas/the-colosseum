ItemTrigger_SpellBlade = nil
ItemTrigger_SpellBlade_Damaging = nil
ItemTrigger_SpellBlade_Hashtable = nil

RegInit(function()
    ItemTrigger_SpellBlade_Hashtable = InitHashtable()
    ItemTrigger_SpellBlade = AddAbilityCastTrigger_CasterHasItem(FourCC('I00S'), ItemTrigger_SpellBlade_Actions)
    ItemTrigger_SpellBlade_Damaging = AddDamagingEventTrigger_CasterHasItem(FourCC('I00S'), ItemTrigger_SpellBlade_Damaging_Actions)
end)

function ItemTrigger_SpellBlade_Actions()
    local caster = GetSpellAbilityUnit()

    ApplyManagedBuff(caster, FourCC('A07F'), FourCC('B012'), 20.00, "weapon", "Abilities\\Weapons\\DragonHawkMissile\\DragonHawkMissile.mdl")
end

function ItemTrigger_SpellBlade_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local mana = GetUnitState(caster, UNIT_STATE_MANA)
    SetUnitState(caster, UNIT_STATE_MANA, mana + 3.00)

    if not UnitHasBuffBJ(caster, FourCC('B012')) then
        return
    end

    local damage = 100.00
    RemoveManagedManagedBuff(caster, FourCC('A07F'), FourCC('B012'))

    local target = BlzGetEventDamageTarget()
    CauseMagicDamage(caster, target, damage)
    local effect = AddSpecialEffectTarget("Abilities\\Weapons\\DragonHawkMissile\\DragonHawkMissile.mdl", target, "chest")
    DestroyEffect(effect)
end