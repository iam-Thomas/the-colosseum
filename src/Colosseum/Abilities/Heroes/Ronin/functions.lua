
function FlyMove(unit, point, targetPoint, height, gravity, callbackTrigger)
    udg_point = Location(GetLocationX(point), GetLocationY(point))
    udg_point1 = Location(GetLocationX(targetPoint), GetLocationY(targetPoint))
    udg_FlyHeight = height
    udg_FlyGravity = gravity
    udg_FlyCallback = callbackTrigger
    udg_FlyHero = unit
    TriggerExecute(gg_trg_Fly_Setup)
    RemoveLocation(udg_point)
    RemoveLocation(udg_point1)
end