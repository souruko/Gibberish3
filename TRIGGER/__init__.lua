--===================================================================================
--             Name:    TRIGGER
-------------------------------------------------------------------------------------
--      Description:    init
--===================================================================================




Trigger.Types.EffectSelf       = 1
Trigger.Types.EffectGroup      = 2
Trigger.Types.EffectTarget     = 3
Trigger.Types.Chat             = 4
Trigger.Types.Skill            = 5
Trigger.Types.TimerEnd         = 6
Trigger.Types.TimerStart       = 7
Trigger.Types.TimerThreshold   = 8


Trigger.EffectSelf       = {}
Trigger.EffectGroup      = {}
Trigger.EffectTarget     = {}
Trigger.Chat             = {}
Trigger.Skill            = {}
Trigger.TimerEnd         = {}
Trigger.TimerStart       = {}
Trigger.TimerThreshold   = {}



import "Gibberish3.TRIGGER.Effects.Self"
import "Gibberish3.TRIGGER.Effects.Group"
import "Gibberish3.TRIGGER.Effects.Target"
import "Gibberish3.TRIGGER.Chat"
import "Gibberish3.TRIGGER.Skill"
import "Gibberish3.TRIGGER.TIMER.End"
import "Gibberish3.TRIGGER.TIMER.Start"
import "Gibberish3.TRIGGER.TIMER.Threshold"

import "Gibberish3.TRIGGER.Functions"
import "Gibberish3.TRIGGER.Defaults"
