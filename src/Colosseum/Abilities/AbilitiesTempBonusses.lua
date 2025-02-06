AbilitiesStatBonusses_HT = nil
AbilitiesStatBonusses_Trigger = nil

KEYS_STAT_ARMOR = 1
KEYS_STAT_DAMAGE = 2
KEYS_STAT_STR = 3

RegInit(function()
    AbilitiesStatBonusses_HT = InitHashtable()
    AbilitiesStatBonusses_Trigger = CreateTrigger_Periodic(0.10, Trig_BS_Lightning_ShieldPeriodic_Actions)
end)

function ModuloInteger_Negatives(dividend, divisor)
    local isNegative = dividend < 0
    if (isNegative) then
        dividend = dividend * -1
    end

    local result = ModuloInteger(dividend, divisor)
    
    if (isNegative) then
        result = result * -1
    end
    return result
end

function GrantTempArmor(unit, amount, duration)
    local n = math.ceil(amount)
    local timer = CreateTimer()
    local timerId = GetHandleId(timer)    
    local unitId = GetHandleId(unit)

    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR)
    local targetBonus = currentBonus + n

    SaveUnitHandle(udg_TimerHashtable, timerId, 0, unit)
    SaveInteger(udg_TimerHashtable, timerId, 1, n)

    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR, targetBonus)

    GrantTempArmor_Apply(unit)

    TimerStart(timer, duration, false, GrantTempArmor_Callback)
end

function GrantTempArmor_Callback()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)

    local unit = LoadUnitHandle(udg_TimerHashtable, timerId, 0)
    local grantedAmount = LoadInteger(udg_TimerHashtable, timerId, 1)
    local unitId = GetHandleId(unit)
    
    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR)
    local targetBonus = currentBonus - grantedAmount
    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR, targetBonus)

    GrantTempArmor_Apply(unit)

    FlushChildHashtable(udg_TimerHashtable, timerId)
    DestroyTimer(timer)
end

function GrantTempArmorByBuff(unit, amount, buffId)
    local n = math.ceil(amount)
    local timer = CreateTimer()
    local timerId = GetHandleId(timer)    
    local unitId = GetHandleId(unit)

    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR)
    local targetBonus = currentBonus + n

    SaveUnitHandle(udg_TimerHashtable, timerId, 0, unit)
    SaveInteger(udg_TimerHashtable, timerId, 1, n)

    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR, targetBonus)

    GrantTempArmor_Apply(unit)

    TimerStart(timer, 0.2, true, function()
        if UnitHasBuffBJ(unit, buffId) then
            return
        end

        local cbCurrentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR)
        local cbTargetBonus = cbCurrentBonus - amount
        SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR, cbTargetBonus)
        GrantTempArmor_Apply(unit)
        DestroyTimer(timer)
    end)
end

function GrantTempArmor_Apply(unit)
    local unitId = GetHandleId(unit)
    local bonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_ARMOR)

    local isNegative = bonus < 0
    if (isNegative) then
        bonus = bonus * -1
    end
    
    local bonusOfSingles = ModuloInteger_Negatives(bonus, 10)
    local bonusOfTens = math.floor(ModuloInteger_Negatives(bonus - bonusOfSingles, 100) / 10)
    local bonusOfHundreds = math.floor(ModuloInteger_Negatives(bonus - bonusOfSingles - bonusOfTens, 1000) / 100)

    if (isNegative) then
        bonusOfSingles = bonusOfSingles * -1
        bonusOfTens = bonusOfTens * -1
        bonusOfHundreds = bonusOfHundreds * -1
    end

    SetUnitAbilityLevel(unit, FourCC('A028'), bonusOfSingles + 10)
    SetUnitAbilityLevel(unit, FourCC('A029'), bonusOfTens + 10)
    SetUnitAbilityLevel(unit, FourCC('A02A'), bonusOfHundreds + 10)
end

function GrantTempDamage(unit, amount, duration)
    local n = math.ceil(amount)
    local timer = CreateTimer()
    local timerId = GetHandleId(timer)    
    local unitId = GetHandleId(unit)

    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_DAMAGE)
    local targetBonus = currentBonus + n

    SaveUnitHandle(udg_TimerHashtable, timerId, 0, unit)
    SaveInteger(udg_TimerHashtable, timerId, 1, n)

    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_DAMAGE, targetBonus)

    GrantTempDamage_Apply(unit)

    TimerStart(timer, duration, false, GrantTempDamage_Callback)
end

function GrantTempDamage_Callback()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)

    local unit = LoadUnitHandle(udg_TimerHashtable, timerId, 0)
    local grantedAmount = LoadInteger(udg_TimerHashtable, timerId, 1)
    local unitId = GetHandleId(unit)
    
    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_DAMAGE)
    local targetBonus = currentBonus - grantedAmount
    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_DAMAGE, targetBonus)

    GrantTempDamage_Apply(unit)

    FlushChildHashtable(udg_TimerHashtable, timerId)
    DestroyTimer(timer)
end

function GrantTempDamage_Apply(unit)
    local unitId = GetHandleId(unit)
    local bonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_DAMAGE)

    local isNegative = bonus < 0
    if (isNegative) then
        bonus = bonus * -1
    end
    
    local bonusOfSingles = ModuloInteger_Negatives(bonus, 10)
    local bonusOfTens = math.floor(ModuloInteger_Negatives(bonus - bonusOfSingles, 100) / 10)
    local bonusOfHundreds = math.floor(ModuloInteger_Negatives(bonus - bonusOfSingles - bonusOfTens, 1000) / 100)

    if (isNegative) then
        bonusOfSingles = bonusOfSingles * -1
        bonusOfTens = bonusOfTens * -1
        bonusOfHundreds = bonusOfHundreds * -1
    end

    SetUnitAbilityLevel(unit, FourCC('A02K'), bonusOfSingles + 10)
    SetUnitAbilityLevel(unit, FourCC('A02L'), bonusOfTens + 10)
    SetUnitAbilityLevel(unit, FourCC('A02M'), bonusOfHundreds + 10)
end

function GrantTempStr(unit, amount, duration)
    local n = math.ceil(amount)
    local timer = CreateTimer()
    local timerId = GetHandleId(timer)    
    local unitId = GetHandleId(unit)

    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_STR)
    local targetBonus = currentBonus + n

    SaveUnitHandle(udg_TimerHashtable, timerId, 0, unit)
    SaveInteger(udg_TimerHashtable, timerId, 1, n)

    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_STR, targetBonus)

    GrantTempStr_Apply(unit)

    TimerStart(timer, duration, false, GrantTempStr_Callback)
end

function GrantTempStr_Callback()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)

    local unit = LoadUnitHandle(udg_TimerHashtable, timerId, 0)
    local grantedAmount = LoadInteger(udg_TimerHashtable, timerId, 1)
    local unitId = GetHandleId(unit)
    
    local currentBonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_STR)
    local targetBonus = currentBonus - grantedAmount
    SaveInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_STR, targetBonus)

    GrantTempStr_Apply(unit)

    FlushChildHashtable(udg_TimerHashtable, timerId)
    DestroyTimer(timer)
end

function GrantTempStr_Apply(unit)
    local unitId = GetHandleId(unit)
    local bonus = LoadInteger(AbilitiesStatBonusses_HT, unitId, KEYS_STAT_STR)

    local isNegative = bonus < 0
    if (isNegative) then
        bonus = bonus * -1
    end
    
    local bonusOfSingles = ModuloInteger_Negatives(bonus, 10)
    local bonusOfTens = math.floor(ModuloInteger_Negatives(bonus - bonusOfSingles, 100) / 10)
    local bonusOfHundreds = math.floor(ModuloInteger_Negatives(bonus - bonusOfSingles - bonusOfTens, 1000) / 100)

    if (isNegative) then
        bonusOfSingles = bonusOfSingles * -1
        bonusOfTens = bonusOfTens * -1
        bonusOfHundreds = bonusOfHundreds * -1
    end

    SetUnitAbilityLevel(unit, FourCC('A02K'), bonusOfSingles + 10)
    SetUnitAbilityLevel(unit, FourCC('A02Q'), bonusOfTens + 10)
    SetUnitAbilityLevel(unit, FourCC('A02M'), bonusOfHundreds + 10)
end