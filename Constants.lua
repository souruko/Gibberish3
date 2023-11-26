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

---------------------------------------------------------------------------------------------------
-- direction
Direction               = {}
Direction.Ascending     = true
Direction.Descending    = false
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- orientation
Orientation             = {}
Orientation.Horizontal  = true
Orientation.Vertical    = false
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- number format
NumberFormat            = {}
NumberFormat.Seconds    = 1
NumberFormat.Minutes    = 2
NumberFormat.OneDecimal = 3
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- option defaults
Options.Defaults                         = {}

-- tooltip
Options.Defaults.tooltip                 = {}
Options.Defaults.tooltip.ActivationDelay = 1

-- moveLabel
Options.Defaults.move               = {}
Options.Defaults.move.TextAlignment = Turbine.UI.ContentAlignment.MiddleCenter
Options.Defaults.move.Font          = Turbine.UI.Lotro.Font.Verdana12
Options.Defaults.move.FontStyle     = Turbine.UI.FontStyle.Outline
Options.Defaults.move.FrameSize     = 2
Options.Defaults.move.seleced       = Turbine.UI.Color.LimeGreen
Options.Defaults.move.notSeleced    = Turbine.UI.Color.White
Options.Defaults.move.sbackground   = Turbine.UI.Color( 0.3, 0.3, 0.3 )
Options.Defaults.move.nbackground   = Turbine.UI.Color( 0.1, 0.1, 0.1 )
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- screen size
Options.ScreenWidth, Options.ScreenHeight = Turbine.UI.Display:GetSize()
---------------------------------------------------------------------------------------------------
