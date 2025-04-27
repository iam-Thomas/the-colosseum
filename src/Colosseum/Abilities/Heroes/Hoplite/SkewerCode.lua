RegInit(function()
    local trig = AddAbilityCastTrigger('A02X', AbilityTrigger_Hoplite_Skewer_Actions)
    
    RegisterTriggerEnableById(trig, FourCC('O005'))
end)

function AbilityTrigger_Hoplite_Skewer_Actions()
    local caster = GetSpellAbilityUnit()
    local startPoint = GetUnitLoc(caster)
    local targetPoint = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(startPoint, targetPoint)
    local endPoint = PolarProjectionBJ(startPoint, 1350, angle)

    local abilityLevel = GetUnitAbilityLevel( udg_Hoplite, FourCC('A02X'))
    local dmg = 40.00 + (40.00 * GetUnitAbilityLevel( udg_Hoplite, FourCC('A02X') ) )
    local attackDamage = GetHeroDamageTotal(caster)
    local damageFinal = dmg + (attackDamage * 1.5)
    

    FireShockwaveProjectile(caster, startPoint, endPoint, "war3mapImported\\SpearOfMars.mdx", 1200, 140, function(target)
        if not IsUnitEnemy(target, GetOwningPlayer(caster)) then
            return
        end

        if not IsUnit_TargetablePhysical(target) then
            return
        end

        CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", 2.00)
        Knockback_Angled(target, angle, 400, function()
            MakeVulnerable( target, 10.00 )
            CauseStun3s( udg_Hoplite, target )
            CausePhysicalDamage_Hero(caster, target, damageFinal / 2)
        end )
        CausePhysicalDamage_Hero(caster, target, damageFinal)
    end, nil)
end

function Skewer_KB_Callback(target)
    local dmg = 60.00 + (30.00 * GetUnitAbilityLevel( udg_Hoplite, FourCC('A02X') ) )
    MakeVulnerable( target, 10.00 )
    CauseStun1s( udg_Hoplite, target )
    CauseMagicDamage( udg_Hoplite, target, dmg )
end