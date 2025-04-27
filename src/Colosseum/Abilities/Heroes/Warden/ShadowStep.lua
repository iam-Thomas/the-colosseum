RegInit(function()
    local trig = AddAbilityCastTrigger('A0A5', AbilityTrigger_Warden_Shadowstep)
    
    RegisterTriggerEnableById(trig, FourCC('E002'))
end)

function AbilityTrigger_Warden_Shadowstep()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A0A5'))
    local shadowDuration = 3.00 + (3.00 * abilityLevel)
    local shadeFacing = GetUnitFacing(caster)
    
    local casterLoc = GetUnitLoc(caster)

    local behindLoc = Warden_GetLocBehindTarget(target)
    local locFinal = GetUnitValidLoc(behindLoc)
    local casterFacing = Warden_GetFacingTowardsTarget(locFinal, target)

    MakeElusive(caster, 0.5)
    SetUnitX(caster, GetLocationX(locFinal))
    SetUnitY(caster, GetLocationY(locFinal))
    SetUnitFacing(caster, casterFacing)
    Warden_SummonAnimatedShadow(caster, casterLoc, shadowDuration, shadeFacing)
    if IsUnitEnemy(target, GetOwningPlayer(caster)) then
        CauseStunMini(caster, target)
        IssueTargetOrder(caster, "attack", target)
    end

    RemoveLocation(behindLoc)
    RemoveLocation(locFinal)
    RemoveLocation(behindLoc)
end
