function MakeVulnerable(unit, t)
    local hasBuff = false
    if UnitHasBuffBJ(unit, FourCC('B01D')) then
        hasBuff = true
    end

    ApplyManagedBuff(unit, FourCC('A08I'), FourCC('B01D'), t, nil, nil)

    if not hasBuff then
        CreateEffectOnUnitByBuff("overhead", unit, "Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl", FourCC('B01D'))
    end
end

function MakeEmpowered(unit, t)
    local hasBuff = false
    if UnitHasBuffBJ(unit, FourCC('B01E')) then
        hasBuff = true
    end

    ApplyManagedBuff(unit, FourCC('S003'), FourCC('B01E'), t, nil, nil)

    if not hasBuff then
        CreateEffectOnUnitByBuff("hand left", unit, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", FourCC('B01E'))
        CreateEffectOnUnitByBuff("hand right", unit, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", FourCC('B01E'))
    end
end

function MakeElusive(unit, t)
    local hasBuff = false
    if UnitHasBuffBJ(unit, FourCC('B01C')) then
        hasBuff = true
    end

    ApplyManagedBuff(unit, FourCC('S004'), FourCC('B01C'), t, nil, nil)

    if not hasBuff then
        CreateEffectOnUnitByBuff("origin", unit, "war3mapImported\\Windwalk.mdl", FourCC('B01C'))
    end
end

function IsUnitVulnerable(unit)
    return UnitHasBuffBJ(unit, FourCC('B01D'))
end

function IsUnitEmpowered(unit)
    return UnitHasBuffBJ(unit, FourCC('B01E'))
end

function IsUnitElusive(unit)
    return UnitHasBuffBJ(unit, FourCC('B01C'))
end

StatusTrigger_Fear = nil

RegInit(function()
    StatusTrigger_Fear = AddDamagingEventTrigger_CasterHasBuff(FourCC('B00X'), StatusTrigger_Fear_Function)
end)

function StatusTrigger_Fear_Function()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local damage = GetEventDamage()
    BlzSetEventDamage(damage * 0.20)
end