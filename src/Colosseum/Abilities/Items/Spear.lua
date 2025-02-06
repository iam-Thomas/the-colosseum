ItemTrigger_Spear = nil

RegInit(function()
    ItemTrigger_Spear = AddAbilityCastTrigger('A05J', ItemTrigger_Spear_Actions)
end)

function ItemTrigger_Spear_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local damage = 100.00
    --abilities\weapons\wyvernspear\wyvernspearmissile.mdl

    local startPoint = GetUnitLoc(caster)

    FireHomingProjectile_PointToUnit(startPoint, target, "abilities\\weapons\\wyvernspear\\wyvernspearmissile.mdl", 1250.00, 0.06, function()
        RemoveLocation(startPoint)
        CauseMagicDamage_Enhanced(caster, target, damage)
        MakeVulnerable(target, 12.00)
    end)
end