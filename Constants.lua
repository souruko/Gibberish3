--=================================================================================================
--= Constants        
--= ===============================================================================================
--= definitions for globaly used constants
--=================================================================================================



---------------------------------------------------------------------------------------------------
Language = {}

-- used language
Language.Local = 1

-- determine used language by checking for existence of commands
if Turbine.Shell.IsCommand("hilfe") then
    Language.Local = 2
elseif Turbine.Shell.IsCommand("aide") then
    Language.Local = 3
end

-- language constants
Language.English = 1
Language.German  = 2
Language.French  = 3
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger action times
Actions          = {}
Actions.Add      = 1
Actions.Remove   = 2
Actions.Reset    = 3
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- option defaults
Options.Defaults                        = {}
-- delay until tooltip ist displayed
Options.Defaults.tooltipActivationDelay = 1
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger source
Source              = {}
Source.Any          = 0
Source.CombatStart  = 1
Source.CombatEnd    = 2

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer text options
TimerTextOptions                = {}
TimerTextOptions.NoText         = 1
TimerTextOptions.Token          = 2
TimerTextOptions.CustomText     = 3
TimerTextOptions.Target         = 4
---------------------------------------------------------------------------------------------------