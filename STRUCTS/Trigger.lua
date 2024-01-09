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
    trigger.value           = Trigger[type].Defaults.value
    trigger.listOfTargets   = Trigger[type].Defaults.listOfTargets
    trigger.source          = Trigger[type].Defaults.source

    return trigger

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- copy trigger struct and return it
---------------------------------------------------------------------------------------------------
function Trigger.Copy( data )

    local trigger = {}

    trigger.id              = Turbine.Engine.GetGameTime()
    trigger.enabled         = data.enabled      
    trigger.sortIndex       = data.sortIndex    
    trigger.type            = data.type         
    trigger.token           = data.token        
    trigger.useRegex        = data.useRegex     
    trigger.description     = data.description  
    trigger.action          = data.action       
    trigger.value           = data.value        
    trigger.listOfTargets   = data.listOfTargets
    trigger.source          = data.source       

    return trigger

end
---------------------------------------------------------------------------------------------------