--===================================================================================
--             Name:    TRIGGER
-------------------------------------------------------------------------------------
--      Description:    init
--===================================================================================




Trigger.Types.EFFECT_SELF       = 1
Trigger.Types.EFFECT_GROUP      = 2
Trigger.Types.EFFECT_TARGET     = 3
Trigger.Types.CHAT              = 4
Trigger.Types.SKILL             = 5
Trigger.Types.TIMER_END         = 6
Trigger.Types.TIMER_START       = 7
Trigger.Types.TIMER_THRESHOLD   = 8


Trigger.EFFECT_SELF       = {}
Trigger.EFFECT_GROUP      = {}
Trigger.EFFECT_TARGET     = {}
Trigger.CHAT              = {}
Trigger.SKILL             = {}
Trigger.TIMER_END         = {}
Trigger.TIMER_START       = {}
Trigger.TIMER_THRESHOLD   = {}



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
