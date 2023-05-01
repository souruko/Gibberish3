

import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"


import "Gibberish3.GobalVariables"
import "Gibberish3.UTILS"


import "Gibberish3.STRUCTS"
import "Gibberish3.ELEMENTS"

import "Gibberish3.TRIGGER"


-------------------------------------------------------------------------------------
--      Description:    TOBEDELETED 
-------------------------------------------------------------------------------------
Data.New()

local testIndex = Group.New("hi", 1)

Data.group[testIndex].timerList[1] = Timer.New(1)
Data.group[testIndex].timerList[1].useCustomTimer = true
Data.group[testIndex].timerList[1].timerValue = "&1"
Data.group[testIndex].timerList[1].textOption = TimerTextOptions.CustomText
Data.group[testIndex].timerList[1].textValue = "Text: &2"

Data.group[testIndex].timerList[1].chatTrigger[1] = Trigger.New(Trigger.Types.CHAT)
Data.group[testIndex].timerList[1].chatTrigger[1].useRegex = true
Data.group[testIndex].timerList[1].chatTrigger[1].token = "pull in &1 &2"

Group[testIndex] = Group.Create(Group.Types.LISTBOX, testIndex, Data.group[testIndex])

testIndex = Group.New("bye", 1)
Data.group[testIndex].top = 0.5

Group[testIndex] = Group.Create(Group.Types.LISTBOX, testIndex, Data.group[testIndex])

-------------------------------------------------------------------------------------
--      Description:    TOBEDELETED   
-------------------------------------------------------------------------------------

import "Gibberish3.Save"
import "Gibberish3.Load"




import "Gibberish3.OPTIONS"
import "Gibberish3.ChatCommand"