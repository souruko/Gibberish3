

import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"


import "Gibberish3.GobalVariables"
import "Gibberish3.UTILS"


import "Gibberish3.STRUCTS"
import "Gibberish3.ELEMENTS"


import "Gibberish3.Save"
import "Gibberish3.Load"


import "Gibberish3.TRIGGER"

-------------------------------------------------------------------------------------
--      Description:    TOBEDELETED 
-------------------------------------------------------------------------------------

Data.New()

local testIndex = Group.New("hi", 1)

Data.group[testIndex].timerList[1] = Timer.New(Timer.Types.BAR)
Data.group[testIndex].timerList[1].useCustomTimer = true
Data.group[testIndex].timerList[1].timerValue = "&1"
Data.group[testIndex].timerList[1].textOption = TimerTextOptions.CustomText
Data.group[testIndex].timerList[1].textValue = "Text: &2"
Data.group[testIndex].timerList[1].unique = true

Data.group[testIndex].timerList[1].chatTrigger[1] = Trigger.New(Trigger.Types.CHAT)
Data.group[testIndex].timerList[1].chatTrigger[1].useRegex = true
Data.group[testIndex].timerList[1].chatTrigger[1].token = "pull in &1 &2"

Data.group[testIndex].timerList[2] = Timer.New(Timer.Types.BAR)
Data.group[testIndex].timerList[2].useCustomTimer = false
Data.group[testIndex].timerList[2].textOption = TimerTextOptions.CustomText
Data.group[testIndex].timerList[2].textValue = "Text: &2"
Data.group[testIndex].timerList[2].unique = true

Data.group[testIndex].timerList[2].effectSelfTrigger[1] = Trigger.New(Trigger.Types.EFFECT_SELF)
Data.group[testIndex].timerList[2].effectSelfTrigger[1].useRegex = false
Data.group[testIndex].timerList[2].effectSelfTrigger[1].token = "Soliloquy of Spirit"
Data.group[testIndex].timerList[2].icon = nil

Data.group[testIndex].timerList[3] = Timer.New(Timer.Types.BAR)
Data.group[testIndex].timerList[3].useCustomTimer = false
Data.group[testIndex].timerList[3].textOption = TimerTextOptions.Token
Data.group[testIndex].timerList[3].textValue = "Text: &2"
Data.group[testIndex].timerList[3].unique = true

Data.group[testIndex].timerList[3].skillTrigger[1] = Trigger.New(Trigger.Types.SKILL)
Data.group[testIndex].timerList[3].skillTrigger[1].useRegex = false
Data.group[testIndex].timerList[3].skillTrigger[1].token = "Chord of Salvation"
Data.group[testIndex].timerList[3].icon = nil
Data.group[testIndex].timerList[3].permanent = true
Data.group[testIndex].opacityPassiv = 0.2


Group[testIndex] = Group.Constructor[ Group.Types.LISTBOX ](testIndex, Data.group[testIndex])

local testIndex2 = Group.New("bye", 1)
Data.group[testIndex2].top = 0.5

Group[testIndex2] = Group.Constructor[ Group.Types.LISTBOX ](testIndex2, Data.group[testIndex2])

-------------------------------------------------------------------------------------
--      Description:    TOBEDELETED   
-------------------------------------------------------------------------------------

Trigger.InitAll()



import "Gibberish3.OPTIONS"
import "Gibberish3.ChatCommand"