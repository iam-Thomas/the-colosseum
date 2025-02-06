function BehemothSting()
    local caster = GetTriggerUnit()
    local target = GetSpellTargetUnit()
    local damage = 15.00

    if ( UnitHasBuffBJ(target, FourCC('B009')) == true ) then
        return
    end

    PolledWait( 1.00 )
    while UnitHasBuffBJ(target, FourCC('B009')) == true do
        PolledWait( 1.00 )
        UnitDamageTargetBJ( caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC )
    end
end

trg_BehemothSting = nil
RegInit(function()
    trg_BehemothSting = AddAbilityCastTrigger('A01F', BehemothSting)
end)