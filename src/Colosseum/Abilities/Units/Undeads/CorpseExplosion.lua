AbilityTrigger_Undead_CorpseExplosion = nil

RegInit(function()
    AbilityTrigger_Undead_CorpseExplosion = AddAbilityCastTrigger('A04I', AbilityTrigger_Undead_CorpseExplosion_Actions)
end)

function AbilityTrigger_Undead_CorpseExplosion_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    CreateEffectOnUnit("origin", target, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", 3.0)

    SetUnitVertexColor(target, 255, 80, 80, 255)
    DelayedCallback(3.00, function()
        if not IsUnitAliveBJ(target) then
            return
        end

        local targetLoc = GetUnitLoc(target)
        ExplodeUnitBJ(target)
        local rdEffect = CreateEffectAtPoint(targetLoc, "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 3.00)
        BlzSetSpecialEffectScale(rdEffect, 3.70)
        BlzSetSpecialEffectTimeScale(rdEffect, 0.60)

        local affectedUnits = GetUnitsInRange_EnemyTargetable(caster, targetLoc, 300)
        for i = 1, #affectedUnits do
            local infestStrength = AbilityFunction_Undead_GetInfestStrengthOnUnit(affectedUnits[i])
            CauseMagicDamage(caster, affectedUnits[i], 35 + (infestStrength * 6))
        end
    end)
end