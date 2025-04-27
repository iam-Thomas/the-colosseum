AbilityTrigger_Kaze_Callback = nil

RegInit(function()
    AbilityTrigger_Kaze_Callback = CreateTrigger()
    TriggerAddAction( AbilityTrigger_Kaze_Callback, AbilityTrigger_Kaze_Callback_Actions )
    
    RegisterTriggerEnableById(AbilityTrigger_Kaze_Callback, FourCC('O00I'))
end)

function AbilityTrigger_Kaze_Callback_Actions()

    local caster = udg_FI_Hero[udg_fi]
    local point = GetUnitLoc(caster)

    local kazeAoe = 375.00
    local kazeLevel = GetUnitAbilityLevelSwapped(FourCC(KazeSID), caster)

    local point3 = PolarProjectionBJ(point, 150.00, GetUnitFacing(caster))
    local effect = CreateEffectAtPoint(point3, "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", 1)
    BlzSetSpecialEffectScale( effect, 4.00 )
    DestroyEffectBJ( effect )
    RemoveLocation( point3 )

    local targets = GetUnitsInRange_EnemyGroundTargetable(caster, point, kazeAoe)
    for i = 1, #targets do
        CastDummyAbilityOnTarget(caster, targets[i], FourCC(KazeIncapacitateSID), GetUnitAbilityLevelSwapped(FourCC(KazeSID), caster), "sleep")
    end

    RemoveLocation( point )

end
