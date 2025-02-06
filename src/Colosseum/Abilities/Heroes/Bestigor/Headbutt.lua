AbilityTrigger_BEST_Headbutt = nil

RegInit(function()
    AbilityTrigger_BEST_Headbutt = AddAbilityCastTrigger('A02J', AbilityTrigger_BEST_Headbutt_Actions)
end)

function AbilityTrigger_BEST_Headbutt_Actions()
    local caster = GetSpellAbilityUnit()
    local strength = GetHeroStr(caster, true)
    local baseDamage = strength * 0.75

    local kbDir = GetUnitFacing(caster)

    local unitGroup = CreateGroup()
    local timer = CreateTimer()
    local iteration = 0
    TimerStart(timer, 0.15, true, function()
        if (iteration >= 4) then
            DestroyGroup(unitGroup)
            DestroyTimer(timer)
            return
        end

        local casterLoc = GetUnitLoc(caster)
        local kbLoc = PolarProjectionBJ(casterLoc, 40, kbDir)
        local targets = GetUnitsInRange_EnemyGroundTargetable(caster, kbLoc, 160)
        for i = 1, #targets do
            if (not IsUnitInGroup(targets[i], unitGroup)) then
                GroupAddUnit(unitGroup, targets[i])
                CauseDefensiveDamage(caster, targets[i], baseDamage)
                Knockback_Angled(targets[i], kbDir, 280 - (40 * iteration))
            end
        end

        iteration = iteration + 1
        RemoveLocation(casterLoc)
        RemoveLocation(kbLoc)
    end)
    Knockback_Angled(caster, kbDir, 250)

    --Knockback_Angled()
end