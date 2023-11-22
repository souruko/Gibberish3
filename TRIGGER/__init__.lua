--=================================================================================================
--= Trigger        
--= ===============================================================================================
--= trigger events lotro interface
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- trigger table
Trigger                        = {}

-- trigger types
Trigger.Types                  = {}
Trigger.Types.EffectSelf       = 1
Trigger.Types.EffectGroup      = 2
Trigger.Types.EffectTarget     = 3
Trigger.Types.Chat             = 4
Trigger.Types.Skill            = 5
Trigger.Types.TimerEnd         = 6
Trigger.Types.TimerStart       = 7
Trigger.Types.TimerThreshold   = 8
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger specific tables
Trigger[ Trigger.Types.EffectSelf ]     = {}
Trigger[ Trigger.Types.EffectGroup ]    = {}
Trigger[ Trigger.Types.EffectTarget ]   = {}
Trigger[ Trigger.Types.Chat ]           = {}
Trigger[ Trigger.Types.Skill ]          = {}
Trigger[ Trigger.Types.TimerEnd ]       = {}
Trigger[ Trigger.Types.TimerStart ]     = {}
Trigger[ Trigger.Types.TimerThreshold ] = {}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
import "Gibberish3.TRIGGER.CHAT"
import "Gibberish3.TRIGGER.SKILL"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
import "Gibberish3.TRIGGER.Functions"
---------------------------------------------------------------------------------------------------