

import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"


import "Gibberish3.GobalVariables"
import "Gibberish3.UTILS"
import "Gibberish3.STRUCTS"


import "Gibberish3.ELEMENTS"
import "Gibberish3.TRIGGER"

import "Gibberish3.OPTIONS"

import "Gibberish3.ChatComand"




Data.New()
testIndex = Group.New("hi", 1)
Data.group[testIndex].timerList[1] = Timer.New(1)
Data.group[testIndex].timerList[1].chatTrigger[1] = Trigger.New(Trigger.Types.CHAT)
Data.group[testIndex].timerList[1].chatTrigger[1].useRegex = true
Data.group[testIndex].timerList[1].chatTrigger[1].token = "pull in &1 &2"