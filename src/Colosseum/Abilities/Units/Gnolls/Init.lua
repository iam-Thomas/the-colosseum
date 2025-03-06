--new unit CarrionFleshPileUID = 'h018'
--new ability for GnollFeast (also includes a buff) GnollFeastDummySID = 'A039'
--change tooltip of Carrion Feast to ATTACK SPEED instead of attack damage
--change meatgrinder tooltip to dealing 150 damage flat, instead of doing 25 damage per second
--increase castrange of meatgrinder to 1400 instead of 1000

SpikeyUID = 'o00J'
MeatWagonUID = 'u00D'
PoacherUID = 'n010'
GnasherUID = 'n00Z'
BruteUID = 'n011'

ClaptrapUID = 'h017'
GnollExplosiveUID = 'h019'
CarrionFleshPileUID = 'h018'

HoggerUID = 'n013'
TrapperUID = 'n012'

BoulderbashSID = 'A09N'
CarrionFeastSID = 'A09K'
ChainwindSID = 'A09Q'
GnollExplosiveSID = 'A03B'
GnollExplosiveDummySID = 'A09W'
GreatCarrionFeastSID = 'A09S'
GnollLeashSID = 'A09V'
MeatgrinderSID = 'A09P'
ProvideFeastSID = 'A09O'
ClaptrapSID = 'A09L'
FastClaptrapSID = 'A09T'
MadDashSID = 'A09R'
BallAndChainSID = 'A09J'
SpikeySpikesSID = 'A09I'
GnollFeastDummySID = 'A039'

-- set this to true for the pillar boss round
IsPillarBossRound = false

function UnitIsAGnoll(target)
    return GetUnitTypeId(target) == FourCC(GnasherUID) or
    GetUnitTypeId(target) == FourCC(HoggerUID) or
    GetUnitTypeId(target) == FourCC(PoacherUID) or
    GetUnitTypeId(target) == FourCC(TrapperUID) or
    GetUnitTypeId(target) == FourCC(BruteUID)
end