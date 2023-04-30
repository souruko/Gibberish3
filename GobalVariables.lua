
--===================================================================================
--             Name:    GobalVariables
-------------------------------------------------------------------------------------
--      Description:    Declaration of all Global Variables
--===================================================================================






-------------------------------------------------------------------------------------
--      Description:    Folder structure and functions   
-------------------------------------------------------------------------------------
Folder = {}


-------------------------------------------------------------------------------------
--      Description:    Group structure and functions   
-------------------------------------------------------------------------------------
Group = {}
Group.Defaults = {}
Group.Types = {}



-------------------------------------------------------------------------------------
--      Description:    Timer structure and functions    
-------------------------------------------------------------------------------------
Timer = {}
Timer.Defaults = {}
Timer.Types = {}


-------------------------------------------------------------------------------------
--      Description:    Trigger structure and functions    
-------------------------------------------------------------------------------------
Trigger = {}
Trigger.Defaults = {}
Trigger.Types = {}


-------------------------------------------------------------------------------------
--      Description:    Data structure and functions   
-------------------------------------------------------------------------------------
Data = {}


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
TimerTextOptions = {}
TimerTextOptions.No_Text = 1
TimerTextOptions.Token = 2
TimerTextOptions.Custom_Text = 3
TimerTextOptions.Let_the_plugin_decide = 4


-------------------------------------------------------------------------------------
--      Description:    Orientation 
-------------------------------------------------------------------------------------
Orientation = {}
Orientation.Horizontal = true
Orientation.Vertical = false


-------------------------------------------------------------------------------------
--      Description:    Direction 
-------------------------------------------------------------------------------------
Direction = {}
Direction.Ascending = true
Direction.Descending = false


-------------------------------------------------------------------------------------
--      Description:    NumberFormat 
-------------------------------------------------------------------------------------
NumberFormat = {}
NumberFormat.Seconds = 1
NumberFormat.Minutes = 2


-------------------------------------------------------------------------------------
--      Description:    LocalPlayer 
-------------------------------------------------------------------------------------
LocalPlayer = Turbine.Gameplay.LocalPlayer:GetInstance()


-------------------------------------------------------------------------------------
--      Description:    AnimationType 
-------------------------------------------------------------------------------------
AnimationType = {}
AnimationType.Flashing = 1
AnimationType.Dotted_Border = 2
AnimationType.Activation_Border = 3
AnimationType.New_Activation_Border = 4
AnimationType.New_Dotted_Border = 5