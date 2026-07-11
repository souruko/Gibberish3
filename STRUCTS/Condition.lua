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
function Condition.CheckAll( timerData, triggerType, matchFn, duration )

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

                        if condition.permanent == true then
                            condition.tod = math.huge
                        elseif condition.useCustomDuration == true then
                            condition.tod = gameTime + condition.duration
                        elseif duration ~= nil then
                            condition.tod = gameTime + duration
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
