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
        local manaTimer = CreateTimer()
        TimerStart(manaTimer, 1.0, true, function()
            if not IsUnitAliveBJ(unit) then
                DestroyTimer(manaTimer)
                return
            end
            if not UnitHasBuffBJ(unit, FourCC('B01E')) then
                DestroyTimer(manaTimer)
                return
            end
            local mana = GetUnitState(unit, UNIT_STATE_MANA)
            SetUnitState(unit, UNIT_STATE_MANA, mana + 1.0)
        end)

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

function MakeTenacious(unit, t)
    local hasBuff = false
    if UnitHasBuffBJ(unit, FourCC('B01O')) then
        hasBuff = true
    end

    ApplyManagedBuff(unit, FourCC('S007'), FourCC('B01O'), t, nil, nil)
    CreateEffectOnUnit("origin", unit, "Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl", 3.0)

    if (UnitHasBuffBJ(unit, FourCC('BSTN'))) then
        UnitRemoveBuffBJ(FourCC('BSTN'), unit)
    end

    if UnitHasBuffBJ(unit, FourCC('BPSE')) then
        UnitRemoveBuffBJ(FourCC('BPSE'), unit)
    end

    if not hasBuff then
        CreateEffectOnUnitByBuff("overhead", unit, "Abilities\\Spells\\Items\\AIda\\AIdaTarget.mdl", FourCC('B01O'))
    end
end

function MakeReckless(unit, t)
    local hasBuff = false
    if UnitHasBuffBJ(unit, FourCC('B021')) then
        hasBuff = true
    end

    ApplyManagedBuff(unit, FourCC('S00C'), FourCC('B021'), t, nil, nil)

    if not hasBuff then
        CreateEffectOnUnitByBuff("origin", unit, "war3mapImported\\Windwalk Fire.mdl", FourCC('B021'))
    end
end

function MakeBurnt(unit, t)
    ApplyManagedBuff_Magic(unit, FourCC('A03N'), FourCC('B00Q'), t, "overhead", "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl")
end

function IsUnitResistant(unit)
    return IsUnitType(unit, UNIT_TYPE_HERO) or (GetUnitAbilityLevel(unit, FourCC('A06X')) > 0)
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

function IsUnitTenacious(unit)
    return UnitHasBuffBJ(unit, FourCC('B01O'))
end

function IsUnitTenacious(unit)
    return UnitHasBuffBJ(unit, FourCC('B01O'))
end

function IsUnitReckless(unit)
    return UnitHasBuffBJ(unit, FourCC('B021'))
end

function IsUnitBurnt(unit)
    return UnitHasBuffBJ(unit, FourCC('B00Q'))
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