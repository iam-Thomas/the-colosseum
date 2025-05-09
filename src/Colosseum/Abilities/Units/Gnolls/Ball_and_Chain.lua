AbilityTrigger_Ball_and_Chain = nil

RegInit(function()
    AbilityTrigger_Ball_and_Chain = AddDamagingEventTrigger_CasterHasAbility(FourCC(BallAndChainSID), AbilityTrigger_Ball_and_Chain_Actions)
end)

function AbilityTrigger_Ball_and_Chain_Actions()
    if not BlzGetEventIsAttack() then
        return
    end

    local caster = GetEventDamageSource()
    local casterPoint = GetUnitLoc(caster)
    local target = BlzGetEventDamageTarget()
    local targetPoint = GetUnitLoc(target)

    local random = GetRandomReal(0.00, 1.00)
    local chance = 0.20

    local damage = GetEventDamage()
    if random <= chance then
        Knockback_Angled(target, AngleBetweenPoints(casterPoint, targetPoint), 75)
    end
end