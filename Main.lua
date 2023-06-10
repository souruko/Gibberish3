

import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"


import "Gibberish3.GlobalVariables"
import "Gibberish3.GlobalDefaults"
import "Gibberish3.Resources.IconIDs"

import "Gibberish3.UTILS"

import "Gibberish3.OPTIONS"

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

Data.group[testIndex].width = 200
Data.group[testIndex].height = 60
Data.group[testIndex].frame = 10
-- Data.group[testIndex].color1 = {R=1, G=0, B=0}

timer1in = Group.AddTimer(Data.group[testIndex], Timer.Types.BAR)
Data.group[testIndex].timerList[timer1in].useCustomTimer = true
Data.group[testIndex].timerList[timer1in].timerValue = "&1"
Data.group[testIndex].timerList[timer1in].textOption = TimerTextOptions.CustomText
Data.group[testIndex].timerList[timer1in].textValue = "Text: &2"
Data.group[testIndex].timerList[timer1in].unique = true
Data.group[testIndex].timerList[timer1in].description = "toller timer"

tr1  = Timer.AddTrigger(Data.group[testIndex].timerList[timer1in], Trigger.Types.Chat)
Data.group[testIndex].timerList[timer1in][Trigger.Types.Chat][tr1].useRegex = true
Data.group[testIndex].timerList[timer1in][Trigger.Types.Chat][tr1].token = "pull in &1 &2"

tr7  = Timer.AddTrigger(Data.group[testIndex].timerList[timer1in], Trigger.Types.Chat)
Data.group[testIndex].timerList[timer1in][Trigger.Types.Chat][tr7].useRegex = true
Data.group[testIndex].timerList[timer1in][Trigger.Types.Chat][tr7].token = "yoyoyoyoyo"

timer2in = Group.AddTimer(Data.group[testIndex], Timer.Types.BAR)
Data.group[testIndex].timerList[timer2in].useCustomTimer = false
Data.group[testIndex].timerList[timer2in].textOption = TimerTextOptions.NoText
Data.group[testIndex].timerList[timer2in].textValue = "Text: &2"
Data.group[testIndex].timerList[timer2in].unique = true
Data.group[testIndex].timerList[timer2in].useThreshold = true
Data.group[testIndex].timerList[timer2in].description = "bestimmt ein tollerer timer oder auch nicht"


tr2  = Timer.AddTrigger(Data.group[testIndex].timerList[timer2in], Trigger.Types.Chat)
Data.group[testIndex].timerList[timer2in][Trigger.Types.Chat][tr2].useRegex = false
Data.group[testIndex].timerList[timer2in][Trigger.Types.Chat][tr2].token = "Soliloquy of Spirit"
Data.group[testIndex].timerList[timer2in].icon = nil
Data.group[testIndex].timerList[timer2in].useCustomTimer = true
Data.group[testIndex].timerList[timer2in].useAnimation = true
Data.group[testIndex].timerList[timer2in].timerValue = 10
Data.group[testIndex].timerList[timer2in].useShadow = true
Data.group[testIndex].timerList[timer2in].direction = Direction.Descending
Data.group[testIndex].timerList[timer2in].animationType = IconID.Type.NewDottedBorder

timer3in = Group.AddTimer(Data.group[testIndex], Timer.Types.BAR)
Data.group[testIndex].timerList[timer3in].useCustomTimer = false
Data.group[testIndex].timerList[timer3in].textOption = TimerTextOptions.Token
Data.group[testIndex].timerList[timer3in].textValue = "Text: &2"
Data.group[testIndex].timerList[timer3in].unique = true
Data.group[testIndex].timerList[timer3in].description = "timer ohne selbstvertrauen!"

tr3  = Timer.AddTrigger(Data.group[testIndex].timerList[timer3in], Trigger.Types.Chat)
Data.group[testIndex].timerList[timer3in][Trigger.Types.Chat][tr3].useRegex = false
Data.group[testIndex].timerList[timer3in][Trigger.Types.Chat][tr3].token = "Chord of Salvation"
Data.group[testIndex].timerList[timer3in].icon = nil
Data.group[testIndex].timerList[timer3in].permanent = true
Data.group[testIndex].opacityPassiv = 0.3
Data.group[testIndex].opacityActiv = 1

local testIndex2 = Group.New("bye", Group.Types.COUNTER)
Data.group[testIndex2].top = 0.5
Data.group[testIndex2].left = 0.3

timer4in = Group.AddTimer(Data.group[testIndex2], Timer.Types.COUNTER_BAR)
Data.group[testIndex2].timerList[timer4in].useCustomTimer = true
Data.group[testIndex2].timerList[timer4in].timerValue = "&1"
Data.group[testIndex2].timerList[timer4in].textOption = TimerTextOptions.CustomText
Data.group[testIndex2].timerList[timer4in].textValue = "Text: &2"
Data.group[testIndex2].timerList[timer4in].unique = true


tr4  = Timer.AddTrigger(Data.group[testIndex2].timerList[timer4in], Trigger.Types.EffectSelf)
Data.group[testIndex2].timerList[timer4in][Trigger.Types.EffectSelf][tr4].useRegex = false
Data.group[testIndex2].timerList[timer4in][Trigger.Types.EffectSelf][tr4].token = "Soliloquy of Spirit"
Data.group[testIndex2].timerList[timer4in].icon = nil
Data.group[testIndex2].timerList[timer4in].useCustomTimer = true
Data.group[testIndex2].timerList[timer4in].useAnimation = true
Data.group[testIndex2].timerList[timer4in].timerValue = 10
Data.group[testIndex2].counterDirection = Direction.Descending
Data.group[testIndex2].timerList[timer4in].useShadow = true
Data.group[testIndex2].timerList[timer4in].direction = Direction.Descending
Data.group[testIndex2].timerList[timer4in].animationType = IconID.Type.NewDottedBorder
Data.group[testIndex2].timerList[timer4in].counterValue = 3
Data.group[testIndex2].timerList[timer4in].permanent = true



timer5in = Group.AddTimer(Data.group[testIndex2], Timer.Types.COUNTER_BAR)

Data.group[testIndex2].timerList[timer5in].useCustomTimer = true
Data.group[testIndex2].timerList[timer5in].timerValue = "&1"
Data.group[testIndex2].timerList[timer5in].textOption = TimerTextOptions.CustomText
Data.group[testIndex2].timerList[timer5in].textValue = "Text: &2"
Data.group[testIndex2].timerList[timer5in].unique = true


tr5  = Timer.AddTrigger(Data.group[testIndex2].timerList[timer5in], Trigger.Types.EffectSelf)
Data.group[testIndex2].timerList[timer5in][Trigger.Types.EffectSelf][tr5].useRegex = false
Data.group[testIndex2].timerList[timer5in][Trigger.Types.EffectSelf][tr5].token = "Soliloquy of Spirit"
Data.group[testIndex2].timerList[timer5in].icon = 1090522263
Data.group[testIndex2].timerList[timer5in].useCustomTimer = true
Data.group[testIndex2].timerList[timer5in].useAnimation = true
Data.group[testIndex2].timerList[timer5in].timerValue = 10
Data.group[testIndex2].counterDirection = Direction.Descending
Data.group[testIndex2].timerList[timer5in].useShadow = true
Data.group[testIndex2].timerList[timer5in].direction = Direction.Descending
Data.group[testIndex2].timerList[timer5in].animationType = IconID.Type.NewDottedBorder
Data.group[testIndex2].timerList[timer5in].counterValue = 8
Data.group[testIndex2].timerList[timer5in].permanent = false

tr6  = Timer.AddTrigger(Data.group[testIndex2].timerList[timer5in], Trigger.Types.Chat)
Data.group[testIndex2].timerList[timer5in][Trigger.Types.Chat][tr6].useRegex = true
Data.group[testIndex2].timerList[timer5in][Trigger.Types.Chat][tr6].token = "pull in &1 &2"
Data.group[testIndex2].timerList[timer5in][Trigger.Types.Chat][tr6].action = Actions.Add
Data.group[testIndex2].timerList[timer5in][Trigger.Types.Chat][tr6].action = Actions.Reset


g3 = Group.New("Content Stuff", 1)
g4 = Group.New("Hello there", 1)
g5 = Group.New("Wulfs group", 1)
g6 = Group.New("of timers", 1)
g7 = Group.New("with special needs", 1)
g8 = Group.New("yeahhaaha", 1)
g9 = Group.New("of timers", 1)
g10 = Group.New("with special needs", 1)
g11 = Group.New("yeahhaaha", 1)

f1i = Folder.New("Folder of Life")
f2i = Folder.New("Other Folder")
f3i = Folder.New("Nethe in a Box")
f4i = Folder.New("Other Folder")
f5i = Folder.New("Nethe in a Box")

Data.group[g3].folder = f1i
Data.group[g4].folder = f1i
Data.group[g5].folder = f2i
Data.group[g6].folder = f3i
Data.group[g7].folder = f3i

Data.folder[f3i].folder = f1i

-------------------------------------------------------------------------------------
--      Description:    TOBEDELETED   
-------------------------------------------------------------------------------------


import "Gibberish3.ChatCommand"

Group.OpenAll()

if Data.moveMode == true then
    Options.Move.UpdateMode(true)
end

Trigger.InitAll()


