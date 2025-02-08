RegInit(function()
    DefUnitGroups()
end)

function DefUnitGroups()
    udg_UnitTypesN = 0

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00B')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtm0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00A')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtm1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00E')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtm2"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00D')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtr0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00F')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtr1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00M')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtr2"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00J')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtc0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h00H')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtc1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('h001')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "bandtc2"

    -- Creepers Phase

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n004')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepm0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n00C')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepm1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n00A')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepm2"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n007')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepr0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n00D')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepr1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n009')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepc0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n008')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepb0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n00B')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepb1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n00J')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "creepb2"

    -- Horde Phase

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('o006')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordem0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('o007')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordem1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('o00A')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordec0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('n00K')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordec1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('o009')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordeb0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('o00B')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordeb1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('o00F')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "hordeb2"

    -- undeads
    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u001')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udm0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u004')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udm1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u008')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udr0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u002')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udc0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u003')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udc1"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u005')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udb0"

    udg_UnitTypesN = udg_UnitTypesN + 1
    udg_UnitTypesArray[udg_UnitTypesN ] = FourCC('u007')
    udg_UnitLabelsArray[udg_UnitTypesN ] = "udb1"
end

function GetUnitTypeFromUnitString(unitString)
    for i = 1, udg_UnitTypesN do
        if (udg_UnitLabelsArray[i] == unitString) then
            return udg_UnitTypesArray[i]
        end
    end

    -- set chicken default default
    return FourCC('h004')
end