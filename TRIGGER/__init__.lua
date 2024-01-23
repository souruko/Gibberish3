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
L[ Language.English ].triggerType = {}
L[ Language.English ].triggerType[ Trigger.Types.EffectSelf ]= "Self Effect"
L[ Language.English ].triggerType[ Trigger.Types.EffectGroup ]= "Group Effect"
L[ Language.English ].triggerType[ Trigger.Types.EffectTarget ]= "Target Effect"
L[ Language.English ].triggerType[ Trigger.Types.Chat ]= "Chat"
L[ Language.English ].triggerType[ Trigger.Types.Skill ]= "Skill"
L[ Language.English ].triggerType[ Trigger.Types.TimerEnd ]= "Timer End"
L[ Language.English ].triggerType[ Trigger.Types.TimerStart ]= "Timer Start"
L[ Language.English ].triggerType[ Trigger.Types.TimerThreshold ]= "Timer Threshold"
L[ Language.English ].triggerType[ Trigger.Types.Combat ]= "Combat"
L[ Language.English ].triggerType[ Trigger.Types.EffectRemoveSelf ]= "Self Effect Removed"

L[ Language.German ].triggerType = {}
L[ Language.German ].triggerType[ Trigger.Types.EffectSelf ]= "Self Effect"
L[ Language.German ].triggerType[ Trigger.Types.EffectGroup ]= "Group Effect"
L[ Language.German ].triggerType[ Trigger.Types.EffectTarget ]= "Target Effect"
L[ Language.German ].triggerType[ Trigger.Types.Chat ]= "Chat"
L[ Language.German ].triggerType[ Trigger.Types.Skill ]= "Skill"
L[ Language.German ].triggerType[ Trigger.Types.TimerEnd ]= "Timer End"
L[ Language.German ].triggerType[ Trigger.Types.TimerStart ]= "Timer Start"
L[ Language.German ].triggerType[ Trigger.Types.TimerThreshold ]= "Timer Threshold"
L[ Language.German ].triggerType[ Trigger.Types.Combat ]= "Combat"
L[ Language.German ].triggerType[ Trigger.Types.EffectRemoveSelf ]= "Self Effect Removed"

L[ Language.French ].triggerType = {}
L[ Language.French ].triggerType[ Trigger.Types.EffectSelf ]= "Self Effect"
L[ Language.French ].triggerType[ Trigger.Types.EffectGroup ]= "Group Effect"
L[ Language.French ].triggerType[ Trigger.Types.EffectTarget ]= "Target Effect"
L[ Language.French ].triggerType[ Trigger.Types.Chat ]= "Chat"
L[ Language.French ].triggerType[ Trigger.Types.Skill ]= "Skill"
L[ Language.French ].triggerType[ Trigger.Types.TimerEnd ]= "Timer End"
L[ Language.French ].triggerType[ Trigger.Types.TimerStart ]= "Timer Start"
L[ Language.French ].triggerType[ Trigger.Types.TimerThreshold ]= "Timer Threshold"
L[ Language.French ].triggerType[ Trigger.Types.Combat ]= "Combat"
L[ Language.French ].triggerType[ Trigger.Types.EffectRemoveSelf ]= "Self Effect Removed"
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