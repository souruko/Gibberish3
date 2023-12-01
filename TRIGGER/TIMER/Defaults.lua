--=================================================================================================
--= Timer Defaults      
--= ===============================================================================================
--= timer trigger option defaults
--=================================================================================================



---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.TimerEnd ].Defaults                    = {}
Trigger[ Trigger.Types.TimerEnd ].Defaults.token              = ""
Trigger[ Trigger.Types.TimerEnd ].Defaults.useRegex           = false
Trigger[ Trigger.Types.TimerEnd ].Defaults.action             = Action.Add
Trigger[ Trigger.Types.TimerEnd ].Defaults.source             = nil
Trigger[ Trigger.Types.TimerEnd ].Defaults.description        = ""
Trigger[ Trigger.Types.TimerEnd ].Defaults.listOfTargets      = {}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.TimerStart ].Defaults                    = {}
Trigger[ Trigger.Types.TimerStart ].Defaults.token              = ""
Trigger[ Trigger.Types.TimerStart ].Defaults.useRegex           = false
Trigger[ Trigger.Types.TimerStart ].Defaults.action             = Action.Add
Trigger[ Trigger.Types.TimerStart ].Defaults.source             = nil
Trigger[ Trigger.Types.TimerStart ].Defaults.description        = ""
Trigger[ Trigger.Types.TimerStart ].Defaults.listOfTargets      = {}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.TimerThreshold ].Defaults                    = {}
Trigger[ Trigger.Types.TimerThreshold ].Defaults.token              = ""
Trigger[ Trigger.Types.TimerThreshold ].Defaults.useRegex           = false
Trigger[ Trigger.Types.TimerThreshold ].Defaults.action             = Action.Add
Trigger[ Trigger.Types.TimerThreshold ].Defaults.source             = nil
Trigger[ Trigger.Types.TimerThreshold ].Defaults.description        = ""
Trigger[ Trigger.Types.TimerThreshold ].Defaults.listOfTargets      = {}
---------------------------------------------------------------------------------------------------