
function Event_IsHitEffect()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return true
    end

    local damageType = BlzGetEventDamageType()
    local attackType = BlzGetEventAttackType()
    return damageType == DAMAGE_TYPE_NORMAL and attackType == ATTACK_TYPE_HERO
end