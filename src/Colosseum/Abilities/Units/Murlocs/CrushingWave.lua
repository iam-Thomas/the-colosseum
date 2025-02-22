AbilityTrigger_Murloc_CrushingWave = nil

RegInit(function()
    AbilityTrigger_Murloc_CrushingWave = AddAbilityCastTrigger('A08F', AbilityTrigger_Murloc_CrushingWave_Actions)
end)

function AbilityTrigger_Murloc_CrushingWave_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local endPoint = PolarProjectionBJ(casterLoc, 1200, angle)

    local baseDamage = BlzGetUnitBaseDamage(caster, 0)

    --Abilities\Spells\Other\CrushingWave\CrushingWaveMissile.mdl
    local data = FireShockwaveProjectile(caster, casterLoc, endPoint, "Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl", 370, 220,
    function(target)
        if IsUnitEnemy(target, GetOwningPlayer(caster)) then
            CauseMagicDamage(caster, target, baseDamage * 3.5)
        end
    end, nil)

    BlzSetSpecialEffectTimeScale(data.projectileEffect, 0.3)
end