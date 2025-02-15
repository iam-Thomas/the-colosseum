AbilityTrigger_Murloc_CrawlerAttack_Damaging = nil
AbilityTrigger_Murloc_CrawlerAttack_Damaging_Victim = nil

RegInit(function()
    AbilityTrigger_Murloc_CrawlerAttack_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A07X'), AbilityTrigger_Murloc_CrawlerAttack_Damaging_Actions)
    AbilityTrigger_Murloc_CrawlerAttack_Damaging_Victim = AddDamagedEventTrigger_TargetHasAbility(FourCC('A07X'), AbilityTrigger_Murloc_CrawlerAttack_Damaging_Victim_Actions)
end)

function AbilityTrigger_Murloc_CrawlerAttack_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local manaBurnOnAttack = 20.00
    local damageFactor = 2.50

    local caster = GetEventDamageSource()
    local mana = GetUnitState(caster, UNIT_STATE_MANA)
    if mana < manaBurnOnAttack then
        return
    end

    SetUnitState(caster, UNIT_STATE_MANA, mana - manaBurnOnAttack)
    BlzSetEventDamage(GetEventDamage() * damageFactor)
end

function AbilityTrigger_Murloc_CrawlerAttack_Damaging_Victim_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    print("Victim attacked")

    local caster = BlzGetEventDamageTarget()
    local mana = GetUnitState(caster, UNIT_STATE_MANA)
    SetUnitState(caster, UNIT_STATE_MANA, mana - 25)
end