
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


-------------------------------------------------------------------------------------
--      Description:    Group structure and functions   
-------------------------------------------------------------------------------------
Group                   = {}
Group.Defaults          = {}
Group.Types             = {}
Group.Constructor       = {}
Group.GetAllowedTimer   = {}

-------------------------------------------------------------------------------------
--      Description:    Timer structure and functions    
-------------------------------------------------------------------------------------
Timer                   = {}
Timer.Defaults          = {}
Timer.Types             = {}
Timer.Constructor       = {}


-------------------------------------------------------------------------------------
--      Description:    Trigger structure and functions    
-------------------------------------------------------------------------------------
Trigger                 = {}
Trigger.Defaults        = {}
Trigger.Types           = {}
Trigger.Init            = {}


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
Options.Window = {}


-------------------------------------------------------------------------------------
--      Description:    Data structure and functions   
-------------------------------------------------------------------------------------
Utils = {}


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
--      Description:    Action 
-------------------------------------------------------------------------------------
Action          = {}
Action.Add      = 1
Action.Remove   = 2
Action.Reset    = 3

-------------------------------------------------------------------------------------
--      Description:    fonts
-------------------------------------------------------------------------------------

Font        = {}
Font[1]     = Turbine.UI.Lotro.Font.Arial12
Font[2]     = Turbine.UI.Lotro.Font.TrajanPro13
Font[3]     = Turbine.UI.Lotro.Font.TrajanPro14
Font[4]     = Turbine.UI.Lotro.Font.TrajanPro15
Font[5]     = Turbine.UI.Lotro.Font.TrajanPro16
Font[6]     = Turbine.UI.Lotro.Font.TrajanPro18
Font[7]     = Turbine.UI.Lotro.Font.TrajanPro19
Font[8]     = Turbine.UI.Lotro.Font.TrajanPro20
Font[9]     = Turbine.UI.Lotro.Font.TrajanPro21
Font[10]    = Turbine.UI.Lotro.Font.TrajanPro23
Font[11]    = Turbine.UI.Lotro.Font.TrajanPro24
Font[12]    = Turbine.UI.Lotro.Font.TrajanPro25
Font[13]    = Turbine.UI.Lotro.Font.TrajanPro26
Font[14]    = Turbine.UI.Lotro.Font.TrajanPro28

Font[15]    = Turbine.UI.Lotro.Font.TrajanProBold16
Font[16]    = Turbine.UI.Lotro.Font.TrajanProBold22
Font[17]    = Turbine.UI.Lotro.Font.TrajanProBold24
Font[18]    = Turbine.UI.Lotro.Font.TrajanProBold25
Font[19]    = Turbine.UI.Lotro.Font.TrajanProBold30
Font[20]    = Turbine.UI.Lotro.Font.TrajanProBold36

Font[20]    = Turbine.UI.Lotro.Font.Verdana10
Font[21]    = Turbine.UI.Lotro.Font.Verdana12
Font[22]    = Turbine.UI.Lotro.Font.Verdana14
Font[23]    = Turbine.UI.Lotro.Font.Verdana16
Font[24]    = Turbine.UI.Lotro.Font.Verdana18
Font[25]    = Turbine.UI.Lotro.Font.Verdana20
Font[26]    = Turbine.UI.Lotro.Font.Verdana22
Font[27]    = Turbine.UI.Lotro.Font.Verdana23

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
--      Description:    icon ids
-------------------------------------------------------------------------------------