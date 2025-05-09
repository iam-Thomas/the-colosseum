ItemTrigger_OrbOfLightning = nil
ItemTrigger_OrbOfLightning_Damaged = nil

RegInit(function()
    ItemTrigger_OrbOfLightning = AddDamagingEventTrigger_CasterHasItem(FourCC('I013'), ItemTrigger_OrbOfLightning_Actions)
end)

function ItemTrigger_OrbOfLightning_Actions()
    if not Event_IsHitEffect() then
        return
    end

    local caster = GetEventDamageSource()

    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A0A9'))
    if cooldownRemaining > 0 then
        return
    end

    if GetRandomReal(0.00, 1.00) < 0.80 then
        return
    end
    
    BlzStartUnitAbilityCooldown(caster, FourCC('A0A9'), 1.00)

    local damage = 70.00
    local target = BlzGetEventDamageTarget()
    local sourceUnit = caster
    local targetsGroup = CreateGroup()
    GroupAddUnit(targetsGroup, target)

    ItemTrigger_OrbOfLightning_LightningBolt(caster, sourceUnit, target, damage)
    damage = damage * 0.85
    sourceUnit = target

    local nTargets = 2
    local timer = CreateTimer()
    TimerStart(timer, 0.12, true, function()
        if nTargets <= 0 then
            DestroyGroup(targetsGroup)
            DestroyTimer(timer)
        end
        nTargets = nTargets - 1

        local sourceLoc = GetUnitLoc(sourceUnit)
        local units = GetUnitsInRange_EnemyTargetable(caster, sourceLoc, 350)
        target = GetClosestUnitInTableFromPoint_NotInGroup(units, sourceLoc, targetsGroup)
        RemoveLocation(sourceLoc)
        if target == nil then
            nTargets = 0
            return
        end
        GroupAddUnit(targetsGroup, target)

        ItemTrigger_OrbOfLightning_LightningBolt(caster, sourceUnit, target, damage)
        damage = damage * 0.85
        sourceUnit = target
    end)  
end

function ItemTrigger_OrbOfLightning_LightningBolt(caster, sourceUnit, target, damage)
    local pointtmp1 = OffsetLocation(GetUnitLoc(sourceUnit), 0, 50.00)
    local pointtmp2 = OffsetLocation(GetUnitLoc(target), 0, 50.00)
    AddLightningLoc( "CLPB", pointtmp1, pointtmp2 )
    ConditionalTriggerExecute( gg_trg_LFX_Cleanup )
    CreateEffectAtPoint(pointtmp2, "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", 2.0)
    RemoveLocation(pointtmp1)
    RemoveLocation(pointtmp2)
    CauseMagicDamage(caster, target, damage)
end