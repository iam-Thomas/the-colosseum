ItemTrigger_PlatedLeatherBoots_Damaging = nil

RegInit(function()
    ItemTrigger_PlatedLeatherBoots_Damaging = AddDamagingEventTrigger_TargetHasItem(FourCC('I00P'), ItemTrigger_PlatedLeatherBoots_Damaging_Actions)
end)

function ItemTrigger_PlatedLeatherBoots_Damaging_Actions()
    local caster = BlzGetEventDamageTarget()
    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A076'))

    if cooldownRemaining > 0 then
        return
    end

    local damage = GetEventDamage()
    local maxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    if damage < maxLife * 0.08 then
        return
    end

    local casterLoc = GetUnitLoc(caster)
    BlzSetEventDamage(GetEventDamage() * 0.70)
    BlzStartUnitAbilityCooldown(caster, FourCC('A076'), 15.00)
    MakeElusive(caster, 1.0)
end