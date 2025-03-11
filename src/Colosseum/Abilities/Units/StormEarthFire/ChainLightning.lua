    RegInit(function()
        AddAbilityCastTrigger('A0AJ', AbilityTrigger_Sef_ChainLightning)
    end)

    function AbilityTrigger_Sef_ChainLightning()
        local caster = GetSpellAbilityUnit()
        local damage = 40.00
        local target = GetSpellTargetUnit()
        local sourceUnit = caster
        local targetsGroup = CreateGroup()
        GroupAddUnit(targetsGroup, target)
        
        AbilityTrigger_Sef_ChainLightning_LightningBolt(caster, sourceUnit, target, damage)
        sourceUnit = target
        
        local nTargets = 30
        local timer = CreateTimer()
        TimerStart(timer, 0.66, true, function()
            if nTargets <= 0 then
                DestroyGroup(targetsGroup)
                DestroyTimer(timer)
                return
            end
            nTargets = nTargets - 1

            target = AbilityTrigger_Sef_ChainLightning_GetNearTarget(caster, sourceUnit, targetsGroup)
            if target == nil then
                nTargets = 0
                return
            end
            GroupAddUnit(targetsGroup, target)
            if GetUnitTypeId(target) == FourCC('n017') then
                AbilityTrigger_Sef_ChainLightning_LightningBoltPillar(caster, sourceUnit, target, damage)
            else
                AbilityTrigger_Sef_ChainLightning_LightningBolt(caster, sourceUnit, target, damage)
            end
            sourceUnit = target
        end)  
    end

    function AbilityTrigger_Sef_ChainLightning_GetNearTarget(caster, sourceUnit, group)
        local sourceLoc = GetUnitLoc(sourceUnit)
        local units = GetUnitsInRange_EnemyTargetable(caster, sourceLoc, 700)
        units = FilterUnits_NotElusive(units)
        local pillars = GetUnitsInRange_FriendlyTargetable(caster, sourceLoc, 700)
        pillars = FilterUnits_Predicate(pillars, function(u) return GetUnitTypeId(u) == FourCC('n017') end)
        print(#pillars)
        local allUnits = {}
        for i = 1, #units do
            if sourceUnit ~= units[i] then
                allUnits[#allUnits + 1] = units[i]
            end
        end
        for i = 1, #pillars do
            if sourceUnit ~= pillars[i] then
                allUnits[#allUnits + 1] = pillars[i]
            end
        end
        local target = GetClosestUnitInTableFromPoint(allUnits, sourceLoc)
        RemoveLocation(sourceLoc)
        return target
    end

    function AbilityTrigger_Sef_ChainLightning_LightningBolt(caster, sourceUnit, target, damage)
        local pointtmp1 = OffsetLocation(GetUnitLoc(sourceUnit), 0, 50.00)
        local pointtmp2 = OffsetLocation(GetUnitLoc(target), 0, 50.00)
        AddLightningLoc( "CLPB", pointtmp1, pointtmp2 )
        ConditionalTriggerExecute( gg_trg_LFX_Cleanup )
        CreateEffectAtPoint(pointtmp2, "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", 2.0)
        RemoveLocation(pointtmp1)
        RemoveLocation(pointtmp2)
        CauseMagicDamage(caster, target, damage)
    end

    function AbilityTrigger_Sef_ChainLightning_LightningBoltPillar(caster, sourceUnit, target, damage)
        local pointtmp1 = OffsetLocation(GetUnitLoc(sourceUnit), 0, 50.00)
        local pointtmp2 = OffsetLocation(GetUnitLoc(target), 0, 50.00)
        AddLightningLoc( "CLPB", pointtmp1, pointtmp2 )
        ConditionalTriggerExecute( gg_trg_LFX_Cleanup )
        local clapEffect = CreateEffectAtPoint(pointtmp2, "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 2.0)
        BlzSetSpecialEffectScale(clapEffect, 1.9)
        CreateEffectAtPoint(pointtmp2, "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", 2.0)
        local enemies = GetUnitsInRange_EnemyTargetable(caster, pointtmp2, 575)
        for i = 1, #enemies do
            CauseMagicDamage(caster, enemies[i], damage)
        end
        RemoveLocation(pointtmp1)
        RemoveLocation(pointtmp2)
    end
