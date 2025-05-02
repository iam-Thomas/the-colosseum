AbilityTrigger_Bandit_Dirty_Nade = nil

RegInit(function()
    AbilityTrigger_Bandit_Dirty_Nade = AddAbilityCastTrigger('A03X', AbilityTrigger_Bandit_Dirty_Nade_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Bandit_Dirty_Nade, FourCC('h00E'))
end)

function AbilityTrigger_Bandit_Dirty_Nade_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    
    FireProjectile_PointToPoint(casterLoc, targetLoc, "units\\creeps\\GoblinLandMine\\GoblinLandMine.mdl", 650, 0.22, function()
        local units = GetUnitsInRange_GroundTargetable(caster, targetLoc, 200)

        local timer = CreateTimer()        
        AddSpecialEffectLocBJ(targetLoc, "units\\creeps\\GoblinLandMine\\GoblinLandMine.mdl")
        local mineModel = GetLastCreatedEffectBJ()
        TimerStart(timer, 2.00, false, function()
            local targets = GetUnitsInRange_EnemyGroundTargetable(caster, targetLoc, 120)
            for i = 1, #targets do
                CauseMagicDamage(caster, targets[i], 60)
            end
            
            AddSpecialEffectLocBJ(targetLoc, "Abilities\\Weapons\\Mortar\\MortarMissile.mdl")
            DestroyEffect(GetLastCreatedEffectBJ())

            DestroyTimer(timer)
            RemoveLocation(casterLoc)
            RemoveLocation(targetLoc)
            DestroyEffect(mineModel)
        end)      
    end)
end