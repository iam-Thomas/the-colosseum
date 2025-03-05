AbilityTrigger_Gnoll_Explosive = nil

RegInit(function()
    AbilityTrigger_Gnoll_Explosive = AddAbilityCastTrigger(GnollExplosiveSID, AbilityTrigger_Gnoll_Explosive_Actions)
end)

function AbilityTrigger_Gnoll_Explosive_Actions()
    local caster = GetTriggerUnit()
    local castPoint = GetSpellTargetLoc()
    local timerInterval = 0.05
    local blowUpTime = 6

    local scaling = 2.00
    local targetScaling = 3.00
    local color = 1
    local targetColor = 0

    local colorChangePerTick = (targetcolor - color) * (timerInterval / blowUpTime)
    local scalingChangePerTick = (targetScaling - scaling) * (timerInterval / blowUpTime)

    local explosive = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC(GnollExplosiveUID), castPoint, 0)

    local timer = CreateTimer()
    TimerStart(timer, timerInterval, true, function()
        tick = tick + timerInterval

        color = color + colorChangePerTick
        scaling = scaling + scalingChangePerTick

        SetUnitVertexColor(explosive, 1, color, color, 1)
        SetUnitScale(explosive, scaling, scaling, scaling)

        if (tick > blowUpTime or IsUnitDeadBJ(explosive)) then
            KillUnit(explosive)
            CastDummyAbilityOnPoint(GetOwningPlayer(caster), castPoint, FourCC(GnollExplosiveDummySID), 1, "flamestrike", castPoint)
            RemoveLocation(castPoint)
            DestroyTimer(timer)
        end
        
    end)

end