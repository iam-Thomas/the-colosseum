function Skewer_KB_Callback(target)
    local dmg = 60.00 + (30.00 * GetUnitAbilityLevel( udg_Hoplite, FourCC('A02X') ) )
    MakeVulnerable( target, 10.00 )
    CauseStun1s( udg_Hoplite, target )
    CauseMagicDamage( udg_Hoplite, target, dmg )
end