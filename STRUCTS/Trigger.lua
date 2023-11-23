--=================================================================================================
--= Trigger Struct        
--= ===============================================================================================
--= trigger struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create new trigger struct and return it
---------------------------------------------------------------------------------------------------
function Trigger.New(type)

    local trigger = {}

    trigger.id              = Turbine.Engine.GetGameTime()
    trigger.enabled         = true
    trigger.sortIndex       = 0
    trigger.type            = type
    trigger.token           = Trigger[type].Defaults.token
    trigger.useRegex        = Trigger[type].Defaults.useRegex
    trigger.description     = Trigger[type].Defaults.description
    trigger.action          = Trigger[type].Defaults.action
    trigger.listOfTargets   = Trigger[type].Defaults.listOfTargets

    return trigger

end
---------------------------------------------------------------------------------------------------