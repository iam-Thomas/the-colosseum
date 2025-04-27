abilityTrigger_D_MountainShard = nil
abilityTrigger_D_MountainPassage = nil

RegInit(function()
    abilityTrigger_D_MountainShard = AddAbilityCastTrigger('A01V', Ability_D_MountainShard)
    abilityTrigger_D_MountainPassage = AddAbilityCastTrigger('A025', Ability_D_MountainPassage)
    
    RegisterTriggerEnableById(abilityTrigger_D_MountainShard, FourCC('H005'))
    RegisterTriggerEnableById(abilityTrigger_D_MountainPassage, FourCC('H005'))
end)

function Ability_D_MountainShard()
    local caster = GetSpellAbilityUnit()
    local point = GetSpellTargetLoc()
    local casterLoc = GetUnitLoc(caster)

    local damage = 30.00 + (20.00 * GetUnitAbilityLevel(caster, FourCC('A01V')))

    local effect = AddSpecialEffectLoc("abilities\\weapons\\catapult\\catapultmissile.mdl", point)
    BlzSetSpecialEffectScale(effect, 1.4)
    DestroyEffect(effect)

    Knockback_Explosion_EnemyGroundTargetable(caster, point, 150, 150, damage)

    RemoveLocation(point)
    RemoveLocation(casterLoc)
end

function Ability_D_MountainPassage()
    local caster = GetSpellAbilityUnit()
    local id = GetHandleId(caster)

    local summoner = LoadUnitHandle(udg_Summons_HT, id, 0)

    if (summoner == nil) then
        return
    end

    local summonerLoc = GetUnitLoc(summoner)
    local effect = AddSpecialEffectLoc("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", summonerLoc)
    DestroyEffect(effect)

    local pos = GetUnitLoc(caster)
    local posX = GetLocationX(pos)
    local posY = GetLocationY(pos)
    KillUnit(caster)
    
    SetUnitX(summoner, posX)
    SetUnitY(summoner, posY)

    local effect = AddSpecialEffectLoc("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", pos)
    DestroyEffect(effect)

    RemoveLocation(summonerLoc)
    RemoveLocation(pos)
end