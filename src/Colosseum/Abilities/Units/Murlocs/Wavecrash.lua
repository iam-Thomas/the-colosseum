AbilityTrigger_Murloc_Wavecrash = nil

RegInit(function()
    AbilityTrigger_Murloc_Wavecrash = AddAbilityCastTrigger('A07V', AbilityTrigger_Murloc_Wavecrash_Actions)
end)

function AbilityTrigger_Murloc_Wavecrash_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()

    local delay = 4
    local damage = 450
    local aoe = 700
    local kb = 450

    DangerAreaAt(targetLoc, delay, aoe)
    DangerCountdownAt(targetLoc, delay)
    DelayedCallback(delay, function()
        Knockback_Explosion_EnemyTargetable(caster, targetLoc, aoe, kb, damage)

        local effect = CreateEffectAtPoint(targetLoc, "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", 3.0)
        BlzSetSpecialEffectScale(effect, 3.0)
        for i = 1, 12 do
            local waveAngle = (i - 1) * 360 / 12
            local endPoint = PolarProjectionBJ(targetLoc, aoe - 100, waveAngle)
            FireProjectile_PointToPoint(targetLoc, endPoint, "Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl", 1100, 0, function() end)
        end
        RemoveLocation(targetLoc)
    end)
end