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
    condition.enabled     = false
    condition.description = ""
    condition.sortIndex   = 0
    condition.duration    = 30
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
    condition.description = data.description
    condition.sortIndex   = data.sortIndex
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
function Condition.CheckAll( timerData, triggerType, matchFn )

    if timerData.conditionList == nil then
        return
    end

    local gameTime = Turbine.Engine.GetGameTime()

    for _, condition in ipairs( timerData.conditionList ) do

        if condition.enabled == true then

            for _, condTriggerData in ipairs( condition[triggerType] ) do

                local result = matchFn( condTriggerData )

                if result ~= nil then

                    if condTriggerData.action == Action.Add then

                        if condition.duration > 0 then
                            condition.tod = gameTime + condition.duration
                        else
                            condition.tod = math.huge
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
