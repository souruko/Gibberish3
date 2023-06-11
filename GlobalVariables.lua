
--===================================================================================
--             Name:    GobalVariables
-------------------------------------------------------------------------------------
--      Description:    Declaration of all Global Variables
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    LocalPlayer 
-------------------------------------------------------------------------------------
LocalPlayer = Turbine.Gameplay.LocalPlayer:GetInstance()


-------------------------------------------------------------------------------------
--      Description:    Folder structure and functions   
-------------------------------------------------------------------------------------
Folder = {}
Folder.Options = {}


-------------------------------------------------------------------------------------
--      Description:    Group structure and functions   
-------------------------------------------------------------------------------------
Group                   = {}
Group.Defaults          = {}
Group.Types             = {}
Group.Constructor       = {}
Group.GetAllowedTimer   = {}
Group.Options           = {}

-------------------------------------------------------------------------------------
--      Description:    Timer structure and functions    
-------------------------------------------------------------------------------------
Timer                   = {}
Timer.Defaults          = {}
Timer.Types             = {}
Timer.Constructor       = {}
Timer.Options           = {}


-------------------------------------------------------------------------------------
--      Description:    Trigger structure and functions    
-------------------------------------------------------------------------------------
Trigger                 = {}
Trigger.Defaults        = {}
Trigger.Types           = {}
Trigger.Init            = {}
Trigger.Options           = {}


-------------------------------------------------------------------------------------
--      Description:    Data structure and functions   
-------------------------------------------------------------------------------------
Data = {}


-------------------------------------------------------------------------------------
--      Description:    Data structure and functions   
-------------------------------------------------------------------------------------
Options = {}
Options.Move = {}
Options.Collection = {}
Options.MainWindow = {}
Options.CopyCache  = {}

Options.Move.Window = nil
Options.Collection.Window = nil
Options.MainWindow.Window = nil

Options.Constructor = {}
-------------------------------------------------------------------------------------
--      Description:    Data structure and functions   
-------------------------------------------------------------------------------------
Utils = {}



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------

Options.Collection.CollectEffects = false
Options.Collection.CollectChat = false

-------------------------------------------------------------------------------------
--      Description:    Language 
-------------------------------------------------------------------------------------
Language = {}
Language.Local = 1
if Turbine.Shell.IsCommand("hilfe") then
    Language.Local = 2
elseif Turbine.Shell.IsCommand("aide") then
    Language.Local = 3
end

Language.English = 1
Language.German  = 2
Language.French  = 3


-------------------------------------------------------------------------------------
--      Description:    Localisation 
-------------------------------------------------------------------------------------
L = {}
L[Language.English] = {}
L[Language.German] = {}
L[Language.French] = {}


-------------------------------------------------------------------------------------
--      Description:    screenResolution 
-------------------------------------------------------------------------------------
ScreenWidth , ScreenHeight = Turbine.UI.Display:GetSize()


-------------------------------------------------------------------------------------
--      Description:    TimerTextOptions 
-------------------------------------------------------------------------------------
TimerTextOptions                = {}
TimerTextOptions.NoText         = 1
TimerTextOptions.Token          = 2
TimerTextOptions.CustomText     = 3
TimerTextOptions.Target         = 4


-------------------------------------------------------------------------------------
--      Description:    Orientation 
-------------------------------------------------------------------------------------
Orientation             = {}
Orientation.Horizontal  = true
Orientation.Vertical    = false


-------------------------------------------------------------------------------------
--      Description:    Direction 
-------------------------------------------------------------------------------------
Direction               = {}
Direction.Ascending     = true
Direction.Descending    = false


-------------------------------------------------------------------------------------
--      Description:    NumberFormat 
-------------------------------------------------------------------------------------
NumberFormat            = {}
NumberFormat.Seconds    = 1
NumberFormat.Minutes    = 2
NumberFormat.OneDecimal = 3



-------------------------------------------------------------------------------------
--      Description:    AnimationType 
-------------------------------------------------------------------------------------
AnimationType                       = {}
AnimationType.Flashing              = 1
AnimationType.Dotted_Border         = 2
AnimationType.Activation_Border     = 3
AnimationType.New_Activation_Border = 4
AnimationType.New_Dotted_Border     = 5


-------------------------------------------------------------------------------------
--      Description:    CopyCache 
-------------------------------------------------------------------------------------
Options.CopyCache.ActionTypes      = {}
Options.CopyCache.ActionTypes.Copy = 1
Options.CopyCache.ActionTypes.Cut  = 2

Options.CopyCache.ItemTypes                 = {}
Options.CopyCache.ItemTypes.FolderAndGroup  = 1
Options.CopyCache.ItemTypes.Timer           = 2
Options.CopyCache.ItemTypes.Trigger         = 3

Options.CopyCache.content   = nil

Options.CopyCache.actionType   = nil
Options.CopyCache.itemType     = nil

-------------------------------------------------------------------------------------
--      Description:    Action 
-------------------------------------------------------------------------------------
Actions          = {}
Actions.Add      = 1
Actions.Remove   = 2
Actions.Reset    = 3

-------------------------------------------------------------------------------------
--      Description:    fonts
-------------------------------------------------------------------------------------

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



-------------------------------------------------------------------------------------
--      Description:    icon id types
-------------------------------------------------------------------------------------

IconID                       = {}
IconID.Type                  = {}
IconID.Type.Shadow           = 1
IconID.Type.DottedBorder = 2
IconID.Type.ActivationBorder = 3
IconID.Type.NewActivationBorder = 4
IconID.Type.NewDottedBorder = 5

-------------------------------------------------------------------------------------
--      Description:    Defaults
-------------------------------------------------------------------------------------
Defaults = {}