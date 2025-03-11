RegInit(function()
    AddAbilityCastTrigger('A0AI', AbilityTrigger_Sef_BallLightning)
end)

function AbilityTrigger_Sef_BallLightning()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()
    local startPoint = GetUnitLoc(caster)
    local angle = AngleBetweenPoints(startPoint, targetLoc)

    local baseDamage = 20
    local sparkDamage = 50
    
    SetUnitInvulnerable(caster, true)
    ShowUnit(caster, false)

    local time = 0.00
    local data = FireShockwaveProjectile(caster, startPoint, targetLoc, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", 450, 175, function(unit)
        if IsUnit_EnemyTargetable(caster, unit) then
            local damage = baseDamage * (1.00 + time)
            CauseMagicDamage(caster, unit, damage)
            local damageEffect = AddSpecialEffectTarget("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", unit, "chest")
            DestroyEffect(damageEffect)
        elseif GetUnitTypeId(unit) == FourCC('n015') then
            MakeEmpowered(unit, 10.0)
        end
    end, function()
        time = time + 0.03
    end, function()
        ShowUnit(caster, true)
        SetUnitInvulnerable(caster, false)
        local moveLoc = GetUnitValidLoc(targetLoc)
        SetUnitX(caster, GetLocationX(moveLoc))
        SetUnitY(caster, GetLocationY(moveLoc))
        RemoveLocation(targetLoc)
        RemoveLocation(moveLoc)
        RemoveLocation(startPoint)
    end)

    BlzSetSpecialEffectScale(data.projectileEffect, 2.5)
end