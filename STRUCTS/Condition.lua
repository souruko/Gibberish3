--=================================================================================================
--= Condition Struct
--= ===============================================================================================
--= condition struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create new condition struct and return it
---------------------------------------------------------------------------------------------------
function Condition.New()

    local condition = {}

    condition.id          = Turbine.Engine.GetGameTime()
    condition.enabled     = true
    condition.collapsed   = false
    condition.description = ""
    condition.sortIndex   = 0
    condition.permanent   = false
    condition.useCustomDuration = false
    condition.duration    = 10
    condition.tod         = 0

    for index, triggerType in pairs( Trigger.Types ) do
        condition[triggerType] = {}
    end

    return condition

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- deep copy a condition struct and return it
---------------------------------------------------------------------------------------------------
function Condition.Copy( data )

    local condition = {}

    condition.id          = Turbine.Engine.GetGameTime()
    condition.enabled     = data.enabled
    condition.collapsed   = data.collapsed
    condition.description = data.description
    condition.sortIndex   = data.sortIndex
    condition.permanent   = data.permanent
    condition.useCustomDuration = data.useCustomDuration
    condition.duration    = data.duration
    condition.tod         = 0

    for index, triggerType in pairs( Trigger.Types ) do
        condition[triggerType] = {}
        for i, triggerData in ipairs( data[triggerType] ) do
            condition[triggerType][i] = Trigger.Copy( triggerData )
        end
    end

    return condition

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns true if timerData has no conditions, or all enabled ones are active
---------------------------------------------------------------------------------------------------
function Condition.AreAllMet( timerData )

    if timerData.conditionList == nil or #timerData.conditionList == 0 then
        return true
    end

    local gameTime = Turbine.Engine.GetGameTime()

    for _, condition in ipairs( timerData.conditionList ) do
        if condition.enabled == true then
            if condition.tod <= gameTime then
                return false
            end
        end
    end

    return true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- iterates conditionList and fires matchFn against each condition trigger; updates tod on match
---------------------------------------------------------------------------------------------------
-- cheap test callers use to skip building a match closure for a timer that has
-- no conditions, which is the common case
function Condition.HasAny( timerData )

    local list = timerData.conditionList

    return list ~= nil and #list > 0

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- effect, when given, supplies the duration only if a condition actually needs
-- it: reading it is a call into the game, and a match is the rare case.
function Condition.CheckAll( timerData, triggerType, matchFn, duration, effect )

    -- an empty list is the common case and used to cost a GetGameTime per timer
    -- per event, so leave before paying for it
    if not Condition.HasAny( timerData ) then
        return
    end

    -- both of these used to be read up front for every timer on every event.
    -- Nothing below needs either until a condition trigger matches.
    local gameTime = nil

    for _, condition in ipairs( timerData.conditionList ) do

        if condition.enabled == true then

            for _, condTriggerData in ipairs( condition[triggerType] ) do

                local result = matchFn( condTriggerData )

                if result ~= nil then

                    if gameTime == nil then
                        gameTime = Turbine.Engine.GetGameTime()
                    end

                    if condTriggerData.action == Action.Add then

                        if condition.permanent == true then
                            condition.tod = math.huge
                        elseif condition.useCustomDuration == true then
                            condition.tod = gameTime + condition.duration
                        else

                            if duration == nil and effect ~= nil then
                                duration = effect:GetDuration()
                                effect   = nil          -- resolve at most once
                            end

                            if duration ~= nil then
                                condition.tod = gameTime + duration
                            else
                                condition.tod = math.huge
                            end

                        end

                    elseif condTriggerData.action == Action.Remove then

                        condition.tod = 0

                    end

                end

            end

        end

    end

end
---------------------------------------------------------------------------------------------------
