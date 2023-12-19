--=================================================================================================
--= Main        
--= ===============================================================================================
--= load and start up
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- lotro interface
import "Turbine.Gameplay"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- lotro ui elements
import "Turbine.UI"
import "Turbine.UI.Lotro"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- global variables and constants
import "Gibberish3.Variables"
import "Gibberish3.Constants"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- class / type lua
-- combat chat parse
-- load / save        
-- global variables / constants
-- utils functions
import "Gibberish3.UTILS"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- data structures
import "Gibberish3.STRUCTS"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ui elements
import "Gibberish3.UI_ELEMENTS"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- load data
import "Gibberish3.UTILS.Save"
import "Gibberish3.UTILS.Load"

-- placeholder for load/save
Data.New()
Data.moveMode = true
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger events
import "Gibberish3.TRIGGER"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- options
import "Gibberish3.OPTIONS"
----

Window.New("test", Window.Types.COUNTER_WINDOW)
Data.window[ 1 ].durationFormat = NumberFormat.OneDecimal
Data.window[ 1 ].height = 150
Data.window[ 1 ].showIcon = true
Data.window[ 1 ].showTimer = true
Data.window[ 1 ].orientation =Orientation.Vertical

Data.window[ 1 ][ Trigger.Types.EffectSelf ][ 1 ] = Trigger.New( Trigger.Types.EffectSelf )
Data.window[ 1 ][ Trigger.Types.EffectSelf ][ 1 ].token = "Blade Shield"
Data.window[ 1 ][ Trigger.Types.EffectSelf ][ 1 ].action = Action.Reset

Data.window[ 1 ].timerList[ 1 ] = Timer.New( Timer.Types.COUNTER_BAR )
Data.window[ 1 ].timerList[ 1 ].textOption = TimerTextOptions.NoText
Data.window[ 1 ].timerList[ 1 ].useCustomTimer = true
Data.window[ 1 ].timerList[ 1 ].timerValue = 5
Data.window[ 1 ].timerList[ 1 ].useThreshold = true
Data.window[ 1 ].timerList[ 1 ].useAnimation = true
Data.window[ 1 ].timerList[ 1 ].animationType = AnimationType.New_Dotted_Border
Data.window[ 1 ].timerList[ 1 ].useShadow = true
Data.window[ 1 ].timerList[ 1 ].counterEND = 5
Data.window[ 1 ].timerList[ 1 ].counterSTART = 0

Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ] = Trigger.New( Trigger.Types.Chat )
Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ].token = "Dodge"
Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ].value = 1

Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ] = Trigger.New( Trigger.Types.Chat )
Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ].token = "Hi Fara"
Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ].value = -2

Window.New("test 2", Window.Types.TIMER_WINDOW)



Windows.StartUp()