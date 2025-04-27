AbilityTrigger_Kaze = nil

RegInit(function()
    AbilityTrigger_Kaze = AddAbilityCastTrigger(KazeSID, AbilityTrigger_Kaze_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Kaze, FourCC('O00I'))
end)

function AbilityTrigger_Kaze_Actions()
    LastRoninCast = GetSpellAbilityId()
    LastMirajuCast = GetSpellAbilityId()
    local caster = GetTriggerUnit()
    local point = GetUnitLoc(caster)
    local targetPoint = GetSpellTargetLoc()

    local illusion = GetRoninIllusion(caster, point)
    if (not (illusion == nil)) then
        IssueImmediateOrderBJ( illusion, "stop" )
        SetUnitFacingToFaceLocTimed( illusion, targetPoint, 0.10 )
    end

    CastDummyAbilityOnTarget(caster, caster, FourCC('A03J'), 1, "creepthunderbolt")

    local delaycount = 0
    local delay = CreateTimer()
    TimerStart(delay, 0.03, true, function()
        delaycount = delaycount + 1
        if (delaycount == 5) then
            if (IsUnitAliveBJ(illusion)) then
                SetUnitAnimation( illusion, "attack slam" )
                SetUnitTimeScalePercent( illusion, 50.00 )
            end
            if (IsUnitAliveBJ(caster)) then
                SetUnitAnimation( caster, "attack slam" )
                SetUnitTimeScalePercent( caster, 50.00 )
            end
        end

        if (delaycount == 8) then
 
            if (IsUnitAliveBJ(illusion)) then
                local illupoint = GetUnitLoc(illusion)
                FlyMove(illusion, illupoint, targetPoint, 240, 14, udg_EmptyTrigger)
                RemoveLocation( illupoint )
            end
            if (IsUnitAliveBJ(caster)) then
                FlyMove(caster, point, targetPoint, 240, 14,AbilityTrigger_Kaze_Callback )
            end

            RemoveLocation( point )
            RemoveLocation( targetPoint )
            DestroyTimer(delay)
        end

    end)
end