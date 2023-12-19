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

-- localisation table
L = {}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger action times
Action          = {}
Action.Add      = 1
Action.Remove   = 2
Action.Subtract = 3
Action.Reset    = 4
Action.Clear    = 5
Action.Enable   = 6
Action.Disable  = 7
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- animation types
AnimationType                       = {}
AnimationType.Flashing              = 1
AnimationType.Dotted_Border         = 2
AnimationType.Activation_Border     = 3
AnimationType.New_Activation_Border = 4
AnimationType.New_Dotted_Border     = 5
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- direction
Direction               = {}
Direction.Ascending     = true
Direction.Descending    = false
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- number format
NumberFormat            = {}
NumberFormat.Seconds    = 1
NumberFormat.Minutes    = 2
NumberFormat.OneDecimal = 3
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- orientation
Orientation             = {}
Orientation.Horizontal  = true
Orientation.Vertical    = false
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger source
Source              = {}
Source.Any          = 0
Source.CombatStart  = 1
Source.CombatEnd    = 2
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger source
Stacking            = {}
Stacking.Single     = 0
Stacking.Multi      = 1
Stacking.PerTarget  = 2
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
-- screen size
Options.ScreenWidth, Options.ScreenHeight = Turbine.UI.Display:GetSize()
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

-- timer
Options.Defaults.timer               = {}
Options.Defaults.timer.fontStyle     = Turbine.UI.FontStyle.Outline
Options.Defaults.timer.labelSpacing  = 4

-- shortcut
Options.Defaults.shortcut            = {}
Options.Defaults.shortcut.size       = 50
Options.Defaults.shortcut.menu_width = 125


-- rightclick menu
Options.Defaults.rc_menu                    = {}
Options.Defaults.rc_menu.spacing            = 5
Options.Defaults.rc_menu.item_height        = 24
Options.Defaults.rc_menu.seperator_height   = 10
Options.Defaults.rc_menu.text_left          = 15
Options.Defaults.rc_menu.font               = Turbine.UI.Lotro.Font.Verdana12
Options.Defaults.rc_menu.back_color         = Turbine.UI.Color( 0.15, 0.15, 0.15 )
Options.Defaults.rc_menu.hover_color        = Turbine.UI.Color( 0.23, 0.23, 0.23)
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fonts
Font = {}

Font.Type                   = {}
Font.Type.Arial             = 1
Font.Type.TrajanPro         = 2
Font.Type.TrajanProBold     = 3
Font.Type.Verdana           = 4
Font.Type.VerdanaBold       = 5
Font.Type.BookAntiqua       = 6
Font.Type.BookAntiquaBold   = 7
Font.Type.FixedSys          = 8
Font.Type.LucidaConsole     = 9

Font[Font.Type.Arial]                   = {}
Font[Font.Type.Arial][12]               = Turbine.UI.Lotro.Font.Arial12

Font[Font.Type.TrajanPro]               = {}
Font[Font.Type.TrajanPro][13]           = Turbine.UI.Lotro.Font.TrajanPro13
Font[Font.Type.TrajanPro][14]           = Turbine.UI.Lotro.Font.TrajanPro14
Font[Font.Type.TrajanPro][15]           = Turbine.UI.Lotro.Font.TrajanPro15
Font[Font.Type.TrajanPro][16]           = Turbine.UI.Lotro.Font.TrajanPro16
Font[Font.Type.TrajanPro][18]           = Turbine.UI.Lotro.Font.TrajanPro18
Font[Font.Type.TrajanPro][19]           = Turbine.UI.Lotro.Font.TrajanPro19
Font[Font.Type.TrajanPro][20]           = Turbine.UI.Lotro.Font.TrajanPro20
Font[Font.Type.TrajanPro][21]           = Turbine.UI.Lotro.Font.TrajanPro21
Font[Font.Type.TrajanPro][23]           = Turbine.UI.Lotro.Font.TrajanPro23
Font[Font.Type.TrajanPro][24]           = Turbine.UI.Lotro.Font.TrajanPro24
Font[Font.Type.TrajanPro][25]           = Turbine.UI.Lotro.Font.TrajanPro25
Font[Font.Type.TrajanPro][26]           = Turbine.UI.Lotro.Font.TrajanPro26
Font[Font.Type.TrajanPro][28]           = Turbine.UI.Lotro.Font.TrajanPro28

Font[Font.Type.TrajanProBold]           = {}
Font[Font.Type.TrajanProBold][16]       = Turbine.UI.Lotro.Font.TrajanProBold16
Font[Font.Type.TrajanProBold][22]       = Turbine.UI.Lotro.Font.TrajanProBold22
Font[Font.Type.TrajanProBold][24]       = Turbine.UI.Lotro.Font.TrajanProBold24
Font[Font.Type.TrajanProBold][25]       = Turbine.UI.Lotro.Font.TrajanProBold25
Font[Font.Type.TrajanProBold][30]       = Turbine.UI.Lotro.Font.TrajanProBold30
Font[Font.Type.TrajanProBold][36]       = Turbine.UI.Lotro.Font.TrajanProBold36

Font[Font.Type.Verdana]                 = {}
Font[Font.Type.Verdana][10]             = Turbine.UI.Lotro.Font.Verdana10
Font[Font.Type.Verdana][12]             = Turbine.UI.Lotro.Font.Verdana12
Font[Font.Type.Verdana][14]             = Turbine.UI.Lotro.Font.Verdana14
Font[Font.Type.Verdana][16]             = Turbine.UI.Lotro.Font.Verdana16
Font[Font.Type.Verdana][18]             = Turbine.UI.Lotro.Font.Verdana18
Font[Font.Type.Verdana][20]             = Turbine.UI.Lotro.Font.Verdana20
Font[Font.Type.Verdana][22]             = Turbine.UI.Lotro.Font.Verdana22
Font[Font.Type.Verdana][23]             = Turbine.UI.Lotro.Font.Verdana23

Font[Font.Type.VerdanaBold]             = {}
Font[Font.Type.VerdanaBold][16]         = Turbine.UI.Lotro.Font.VerdanaBold16

Font[Font.Type.BookAntiqua]             = {}
Font[Font.Type.BookAntiqua][12]         = Turbine.UI.Lotro.Font.BookAntiqua12
Font[Font.Type.BookAntiqua][14]         = Turbine.UI.Lotro.Font.BookAntiqua14
Font[Font.Type.BookAntiqua][16]         = Turbine.UI.Lotro.Font.BookAntiqua16
Font[Font.Type.BookAntiqua][18]         = Turbine.UI.Lotro.Font.BookAntiqua18
Font[Font.Type.BookAntiqua][20]         = Turbine.UI.Lotro.Font.BookAntiqua20
Font[Font.Type.BookAntiqua][22]         = Turbine.UI.Lotro.Font.BookAntiqua22
Font[Font.Type.BookAntiqua][24]         = Turbine.UI.Lotro.Font.BookAntiqua24
Font[Font.Type.BookAntiqua][26]         = Turbine.UI.Lotro.Font.BookAntiqua26
Font[Font.Type.BookAntiqua][28]         = Turbine.UI.Lotro.Font.BookAntiqua28
Font[Font.Type.BookAntiqua][32]         = Turbine.UI.Lotro.Font.BookAntiqua32
Font[Font.Type.BookAntiqua][36]         = Turbine.UI.Lotro.Font.BookAntiqua36

Font[Font.Type.BookAntiquaBold]         = {}
Font[Font.Type.BookAntiquaBold][12]     = Turbine.UI.Lotro.Font.BookAntiquaBold12
Font[Font.Type.BookAntiquaBold][14]     = Turbine.UI.Lotro.Font.BookAntiquaBold14
Font[Font.Type.BookAntiquaBold][18]     = Turbine.UI.Lotro.Font.BookAntiquaBold18
Font[Font.Type.BookAntiquaBold][19]     = Turbine.UI.Lotro.Font.BookAntiquaBold19
Font[Font.Type.BookAntiquaBold][22]     = Turbine.UI.Lotro.Font.BookAntiquaBold22
Font[Font.Type.BookAntiquaBold][24]     = Turbine.UI.Lotro.Font.BookAntiquaBold24

Font[Font.Type.FixedSys]                = {}
Font[Font.Type.FixedSys][15]            = Turbine.UI.Lotro.Font.FixedSys15

Font[Font.Type.LucidaConsole]           = {}
Font[Font.Type.LucidaConsole][12]       = Turbine.UI.Lotro.Font.LucidaConsole12
---------------------------------------------------------------------------------------------------