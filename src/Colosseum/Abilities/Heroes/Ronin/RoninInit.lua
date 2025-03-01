MirajuSID = 'A099'
JinadaSID = 'A09A'
ArashiSID = 'A098'
KazeSID = 'A09E'
BushidoSID = 'A09B'

KazeIncapacitateSID = 'A09C'
JinadaBuffSID = 'A09D'

JinadaBID = 'B01W'

LastRoninCast = nil
LastMirajuCast = nil

function GetRoninIllusion(ronin, point)

    local illusion = nil
    
    local units = GetUnitsInRange_FriendlyGroundTargetable(ronin, point, 2000)
    for i = 1, #units do
        if ( IsUnitIllusionBJ(units[i]) and GetUnitTypeId(units[i]) == GetUnitTypeId(ronin) ) then
            illusion = units[i]
        end
    end

    return illusion
end
