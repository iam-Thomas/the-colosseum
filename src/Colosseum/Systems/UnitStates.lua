function MakeVulnerable(unit, t)
    local currentTime = BlzGetUnitAbilityCooldownRemaining(udg_VulnerableTarget, FourCC('A00N'))
    if currentTime > t then
        return
    end
    BlzStartUnitAbilityCooldown( unit, FourCC('A00N'), t )
    CreateTextTagLocBJ( "TRIGSTR_1020", PolarProjectionBJ(GetUnitLoc(udg_VulnerableTarget), GetRandomReal(0.00, 0.00), GetRandomReal(0, 360.00)), 0, 7.00, 100, 100, 100, 0 )
    SetTextTagPermanentBJ( GetLastCreatedTextTag(), false )
    SetTextTagLifespanBJ( GetLastCreatedTextTag(), 1.20 )
    SetTextTagVelocityBJ( GetLastCreatedTextTag(), 32.00, 90.00 )
    AddSpecialEffectTargetUnitBJ( "overhead", unit, "Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl" )
    udg_SFXDurationArg = t
    TriggerExecute( gg_trg_SFX_Cleanup )
end

function MakeEmpowered(unit, t)
    local currentTime = BlzGetUnitAbilityCooldownRemaining(unit, FourCC('A00O'))
    if currentTime > t then
        return
    end
    BlzStartUnitAbilityCooldown( unit, FourCC('A00O'), t )
    AddSpecialEffectTargetUnitBJ( "hand right", unit, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl" )
    udg_SFXDurationArg = t
    TriggerExecute( gg_trg_SFX_Cleanup )
    AddSpecialEffectTargetUnitBJ( "hand left", unit, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl" )
    udg_SFXDurationArg = t
    TriggerExecute( gg_trg_SFX_Cleanup )
end

function MakeElusive(unit, t)
    local currentTime = BlzGetUnitAbilityCooldownRemaining(unit, FourCC('A06T'))
    if currentTime > t then
        return
    end
    BlzStartUnitAbilityCooldown( unit, FourCC('A06T'), t )
    -- AddSpecialEffectTargetUnitBJ( "hand right", unit, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl" )
    -- udg_SFXDurationArg = t
    -- TriggerExecute( gg_trg_SFX_Cleanup )
    -- AddSpecialEffectTargetUnitBJ( "hand left", unit, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl" )
    -- udg_SFXDurationArg = t
    --TriggerExecute( gg_trg_SFX_Cleanup )
    CreateEffectOnUnit("origin", unit, "war3mapImported\\Windwalk.mdl", t)
end

function IsUnitVulnerable(unit)
    return BlzGetUnitAbilityCooldownRemaining(unit, FourCC('A00N')) > 0.00
end

function IsUnitEmpowered(unit)
    return BlzGetUnitAbilityCooldownRemaining(unit, FourCC('A00O')) > 0.00
end

function IsUnitElusive(unit)
    return BlzGetUnitAbilityCooldownRemaining(unit, FourCC('A06T')) > 0.00
end