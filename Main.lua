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
import "Gibberish3.Defaults"
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

Data = Options.LoadData()
Options.FillPersistantCollection()
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger events
import "Gibberish3.TRIGGER"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
Windows.StartUp()
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- options
import "Gibberish3.OPTIONS"

Options.StartUp()
---------------------------------------------------------------------------------------------------
-- startup
-- Window.New("test", Window.Types.COUNTER_WINDOW)
-- Data.window[ 1 ].durationFormat = NumberFormat.OneDecimal
-- Data.window[ 1 ].height = 150
-- Data.window[ 1 ].showIcon = true
-- Data.window[ 1 ].showTimer = true
-- Data.window[ 1 ].orientation =Orientation.Vertical

-- Data.window[ 1 ][ Trigger.Types.EffectSelf ][ 1 ] = Trigger.New( Trigger.Types.EffectSelf )
-- Data.window[ 1 ][ Trigger.Types.EffectSelf ][ 1 ].token = "Blade Shield"
-- Data.window[ 1 ][ Trigger.Types.EffectSelf ][ 1 ].action = Action.Reset

-- Data.window[ 1 ].timerList[ 1 ] = Timer.New( Timer.Types.COUNTER_BAR )
-- Data.window[ 1 ].timerList[ 1 ].textOption = TimerTextOptions.NoText
-- Data.window[ 1 ].timerList[ 1 ].useCustomTimer = true
-- Data.window[ 1 ].timerList[ 1 ].timerValue = 5
-- Data.window[ 1 ].timerList[ 1 ].useThreshold = true
-- Data.window[ 1 ].timerList[ 1 ].useAnimation = true
-- Data.window[ 1 ].timerList[ 1 ].animationType = AnimationType.New_Dotted_Border
-- Data.window[ 1 ].timerList[ 1 ].useShadow = true
-- Data.window[ 1 ].timerList[ 1 ].counterEND = 5
-- Data.window[ 1 ].timerList[ 1 ].counterSTART = 0

-- Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ] = Trigger.New( Trigger.Types.Chat )
-- Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ].token = "Dodge"
-- Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ].value = 1

-- Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ] = Trigger.New( Trigger.Types.Chat )
-- Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ].token = "Hi Fara"
-- Data.window[ 1 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ].value = -2

-- Window.New("test 2", Window.Types.TIMER_WINDOW)

-- Data.window[ 2 ].timerList[ 1 ] = Timer.New( Timer.Types.BAR )
-- Data.window[ 2 ].timerList[ 1 ].textValue = "test value"
-- Data.window[ 2 ].timerList[ 1 ].permanent = true
-- Data.window[ 2 ].timerList[ 1 ].sortIndex = 1
-- Data.window[ 2 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ] = Trigger.New( Trigger.Types.Chat )
-- Data.window[ 2 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ].token = "Dodge"
-- Data.window[ 2 ].timerList[ 1 ][ Trigger.Types.Chat ][ 1 ].value = 1

-- Data.window[ 2 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ] = Trigger.New( Trigger.Types.Chat )
-- Data.window[ 2 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ].token = "dont"
-- Data.window[ 2 ].timerList[ 1 ][ Trigger.Types.Chat ][ 2 ].value = 1

-- Data.window[ 2 ].timerList[ 2 ] = Timer.New( Timer.Types.BAR )
-- Data.window[ 2 ].timerList[ 2 ].description = "woob woob"
-- Data.window[ 2 ].timerList[ 2 ].sortIndex = 3
-- Data.window[ 2 ].timerList[ 3 ] = Timer.New( Timer.Types.BAR )
-- Data.window[ 2 ].timerList[ 3 ].sortIndex = 2

-- Data.window[ 2 ][ Trigger.Types.EffectSelf ][ 1 ] = Trigger.New( Trigger.Types.EffectSelf )
-- Data.window[ 2 ][ Trigger.Types.EffectSelf ][ 1 ].token = "Blade Shield"
-- Data.window[ 2 ][ Trigger.Types.EffectSelf ][ 1 ].action = Action.Reset

-- Folder.New( "wulfs kiste" )
-- Data.folder[ 1 ].collapsed = false
-- Data.folder[ 1 ][ Trigger.Types.EffectSelf ][ 1 ] = Trigger.New( Trigger.Types.EffectSelf )
-- Data.folder[ 1 ][ Trigger.Types.EffectSelf ][ 1 ].token = "Blade Shield"
-- Data.folder[ 1 ][ Trigger.Types.EffectSelf ][ 1 ].action = Action.Enable

-- Data.folder[ 1 ][ Trigger.Types.EffectGroup ][ 1 ] = Trigger.New( Trigger.Types.EffectGroup )
-- Data.folder[ 1 ][ Trigger.Types.EffectGroup ][ 1 ].token = "Test EffectGroup"
-- Data.folder[ 1 ][ Trigger.Types.EffectGroup ][ 1 ].action = Action.Disable

-- Data.folder[ 1 ][ Trigger.Types.EffectTarget ][ 1 ] = Trigger.New( Trigger.Types.EffectTarget )
-- Data.folder[ 1 ][ Trigger.Types.EffectTarget ][ 1 ].token = "Test EffectTarget"
-- Data.folder[ 1 ][ Trigger.Types.EffectTarget ][ 1 ].action = Action.Disable

-- Data.folder[ 1 ][ Trigger.Types.Skill ][ 1 ] = Trigger.New( Trigger.Types.Skill )
-- Data.folder[ 1 ][ Trigger.Types.Skill ][ 1 ].token = "Test Skill"
-- Data.folder[ 1 ][ Trigger.Types.Skill ][ 1 ].action = Action.Disable

-- Data.folder[ 1 ][ Trigger.Types.Chat ][ 1 ] = Trigger.New( Trigger.Types.Chat )
-- Data.folder[ 1 ][ Trigger.Types.Chat ][ 1 ].token = "Test Chat"
-- Data.folder[ 1 ][ Trigger.Types.Chat ][ 1 ].action = Action.Disable

-- Data.folder[ 1 ][ Trigger.Types.TimerEnd ][ 1 ] = Trigger.New( Trigger.Types.TimerEnd )
-- Data.folder[ 1 ][ Trigger.Types.TimerEnd ][ 1 ].token = "Test TimerEnd"
-- Data.folder[ 1 ][ Trigger.Types.TimerEnd ][ 1 ].action = Action.Disable

-- Data.folder[ 1 ][ Trigger.Types.Combat ][ 1 ] = Trigger.New( Trigger.Types.Combat )
-- Data.folder[ 1 ][ Trigger.Types.Combat ][ 1 ].token = "Test Combat"
-- Data.folder[ 1 ][ Trigger.Types.Combat ][ 1 ].action = Action.Disable

-- Folder.New( "nethes tasche" )

-- Window.New("wulf 2", Window.Types.TIMER_WINDOW)
-- Data.window[ 3 ].folder = 1
-- Window.New("wulf 3", Window.Types.TIMER_WINDOW)
-- Data.window[ 4 ].folder = 2
-- Window.New("wulf 6", Window.Types.TIMER_WINDOW)
-- Data.window[ 5 ].folder = 1

-- Folder.New( "sils steine" )
-- Data.folder[ 3 ].folder = 1

-- Window.New("wulf 4", Window.Types.TIMER_WINDOW)
-- Data.window[ 6 ].folder = 1

-- Window.New("wulf 9", Window.Types.TIMER_WINDOW)
-- Data.window[ 7 ].folder = 3

-- Folder.New( "besondere steine" )
-- Data.folder[ 4 ].folder = 3

-- Window.New("schwarzer stein", Window.Types.TIMER_WINDOW)
-- Data.window[ 8 ].folder = 4
-- Window.New("roter stein", Window.Types.TIMER_WINDOW)
-- Data.window[ 9 ].folder = 4
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("sil muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("nethe muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("sil muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)
-- Window.New("wulf muss auffüllen", Window.Types.TIMER_WINDOW)

-- Data.options.window.left      = 0.2
-- Data.options.window.top       = 0.4
-- Options.OptionsWindow( true )