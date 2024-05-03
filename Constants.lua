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

Language[ Language.English ] = "en"
Language[ Language.German ] = "de"
Language[ Language.French ] = "fr"

-- localisation table
L = {}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- option defaults
Options.Defaults                    = {}
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
Action.SetTo    = 8
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- animation types
AnimationType                       = {}
AnimationType.Flashing              = 1
AnimationType.Dotted_Border         = 2
AnimationType.Activation_Border     = 3
AnimationType.New_Activation_Border = 4
AnimationType.New_Dotted_Border     = 5
AnimationType.Zoom                  = 6
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
-- trigger source
ImportType            = {}
ImportType.Window     = 1
ImportType.Timer      = 2
ImportType.Trigger    = 3
ImportType.Folder     = 4
ImportType.WindowList = 5
ImportType.TimerList  = 6
ImportType.TriggerList= 7
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
-- Alignment
Alignment               = {}
Alignment.TopLeft        = Turbine.UI.ContentAlignment.TopLeft
Alignment.TopCenter      = Turbine.UI.ContentAlignment.TopCenter
Alignment.TopRight       = Turbine.UI.ContentAlignment.TopRight
Alignment.MiddleLeft     = Turbine.UI.ContentAlignment.MiddleLeft
Alignment.MiddleCenter   = Turbine.UI.ContentAlignment.MiddleCenter
Alignment.MiddleRight    = Turbine.UI.ContentAlignment.MiddleRight
Alignment.BottomLeft     = Turbine.UI.ContentAlignment.BottomLeft
Alignment.BottomCenter   = Turbine.UI.ContentAlignment.BottomCenter
Alignment.BottomRight    = Turbine.UI.ContentAlignment.BottomRight
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ChatChannel
ChatChannel               = {}
-- ChatChannel.Admin       = Turbine.ChatType.Admin       
ChatChannel.Advancement = Turbine.ChatType.Advancement 
ChatChannel.Death	    = Turbine.ChatType.Death	    
ChatChannel.Emote	    = Turbine.ChatType.Emote	    
ChatChannel.EnemyCombat = Turbine.ChatType.EnemyCombat 
ChatChannel.Error	    = Turbine.ChatType.Error	    
ChatChannel.FellowLoot  = Turbine.ChatType.FellowLoot  
ChatChannel.Fellowship  = Turbine.ChatType.Fellowship  
ChatChannel.Kinship	    = Turbine.ChatType.Kinship	    
ChatChannel.LFF         = Turbine.ChatType.LFF         
-- ChatChannel.Localized1  = Turbine.ChatType.Localized1  
-- ChatChannel.Localized2  = Turbine.ChatType.Localized2  
-- ChatChannel.Narration   = Turbine.ChatType.Narration   
ChatChannel.Officer     = Turbine.ChatType.Officer     
ChatChannel.OOC         = Turbine.ChatType.OOC         
ChatChannel.PlayerCombat= Turbine.ChatType.PlayerCombat
ChatChannel.Quests      = Turbine.ChatType.Quests      
ChatChannel.Raid	    = Turbine.ChatType.Raid	    
ChatChannel.Regional    = Turbine.ChatType.Regional    
-- ChatChannel.Roleplay    = Turbine.ChatType.Roleplay    
ChatChannel.Say	        = Turbine.ChatType.Say	        
ChatChannel.SelfLoot	= Turbine.ChatType.SelfLoot	
ChatChannel.Standard	= Turbine.ChatType.Standard	
ChatChannel.Tell        = Turbine.ChatType.Tell        
ChatChannel.Trade	    = Turbine.ChatType.Trade	    
ChatChannel.Tribe       = Turbine.ChatType.Tribe       
-- ChatChannel.Undef	    = Turbine.ChatType.Undef	    
ChatChannel.Unfiltered  = Turbine.ChatType.Unfiltered  
ChatChannel.UserChat1	= Turbine.ChatType.UserChat1	
ChatChannel.UserChat2	= Turbine.ChatType.UserChat2	
ChatChannel.UserChat3   = Turbine.ChatType.UserChat3   
ChatChannel.UserChat4	= Turbine.ChatType.UserChat4	
ChatChannel.UserChat5   = Turbine.ChatType.UserChat5   
ChatChannel.UserChat6	= Turbine.ChatType.UserChat6	
ChatChannel.UserChat7	= Turbine.ChatType.UserChat7	
ChatChannel.UserChat8	= Turbine.ChatType.UserChat8	
ChatChannel.World       = Turbine.ChatType.World       
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- screen size
Options.ScreenWidth, Options.ScreenHeight = Turbine.UI.Display:GetSize()
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