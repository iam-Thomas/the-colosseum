AbilityTrigger_Lich_DeathTouch_Damaging = nil

RegInit(function()
    AbilityTrigger_Lich_DeathTouch_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A05B'), AbilityTrigger_Lich_DeathTouch_Damaging_Actions)
end)

function AbilityTrigger_Lich_DeathTouch_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    if not UnitHasBuffBJ(target, FourCC('Bfro')) then
        return
    end

    local intFactor = 0.5

    local damage = GetEventDamage()
    local int = GetHeroInt(caster, true)
    local bonusDamage = int * intFactor
    damage = damage + bonusDamage
    BlzSetEventDamage(damage)
    CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Other\\FrostBolt\\FrostBoltMissile.mdl", 0.0)
end