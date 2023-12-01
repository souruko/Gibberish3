--=================================================================================================
--= Trigger        
--= ===============================================================================================
--= trigger events lotro interface
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- trigger types
Trigger.Types.EffectSelf       = 1
Trigger.Types.EffectGroup      = 2
Trigger.Types.EffectTarget     = 3
Trigger.Types.Chat             = 4
Trigger.Types.Skill            = 5
Trigger.Types.TimerEnd         = 6
Trigger.Types.TimerStart       = 7
Trigger.Types.TimerThreshold   = 8
Trigger.Types.Combat           = 9
Trigger.Types.EffectRemoveSelf = 10
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger specific tables
for index, triggerType in pairs( Trigger.Types ) do

    Trigger[triggerType] = {}

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
import "Gibberish3.TRIGGER.EFFECT.SELF"
import "Gibberish3.TRIGGER.EFFECT.GROUP"
import "Gibberish3.TRIGGER.EFFECT.TARGET"
import "Gibberish3.TRIGGER.CHAT"
import "Gibberish3.TRIGGER.SKILL"
import "Gibberish3.TRIGGER.TIMER"
import "Gibberish3.TRIGGER.COMBAT"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
import "Gibberish3.TRIGGER.Functions"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- initiate all trigger tracking
Trigger.InitAll()
---------------------------------------------------------------------------------------------------