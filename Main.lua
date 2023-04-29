

import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"


import "Gibberish3.GobalVariables"
import "Gibberish3.UTILS"
import "Gibberish3.STRUCTS"


import "Gibberish3.ELEMENTS"

import "Gibberish3.TRIGGER"






Data.New()

testIndex = Group.New("hi", 1)

Data.group[testIndex].timerList[1] = Timer.New()
Data.group[testIndex].timerList[1].chatTrigger[1] = Trigger.New()
Data.group[testIndex].timerList[1].chatTrigger[1].useRegex = true
Data.group[testIndex].timerList[1].chatTrigger[1].token = "pull in &1 &2"