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
        BlzSetSpecialEffectScale(rdEffect, 2.70)
        BlzSetSpecialEffectTimeScale(rdEffect, 0.60)
    end)
end