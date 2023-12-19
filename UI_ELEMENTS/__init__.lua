--=================================================================================================
--= Window level UI Elements        
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- timer types
Timer.Types.BAR         = 1
Timer.Types.CIRCEL      = 2
Timer.Types.ICON        = 3
Timer.Types.TEXT        = 4
Timer.Types.COUNTER_BAR = 5

-- timer specific tables
for index, timerType in pairs( Timer.Types ) do

    Timer[timerType] = {}

end

-- timer imports
import "Gibberish3.UI_ELEMENTS.TIMER.BAR"
import "Gibberish3.UI_ELEMENTS.TIMER.CIRCEL"
import "Gibberish3.UI_ELEMENTS.TIMER.ICON"
import "Gibberish3.UI_ELEMENTS.TIMER.TEXT"
import "Gibberish3.UI_ELEMENTS.TIMER.COUNTER_BAR"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window types
Window.Types.TIMER_WINDOW = 1
Window.Types.COUNTER_WINDOW = 2

-- window specific tables
for index, windowType in pairs( Window.Types ) do

    Window[windowType] = {}

end

-- window imports
import "Gibberish3.UI_ELEMENTS.WINDOWS.TIMER_WINDOW"
import "Gibberish3.UI_ELEMENTS.WINDOWS.COUNTER_WINDOW"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window functions
import "Gibberish3.UI_ELEMENTS.WINDOWS.Functions"
---------------------------------------------------------------------------------------------------