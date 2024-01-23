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

L[ Language.English ].type = {}
L[ Language.English ].type[Timer.Types.BAR] = "Bar"
L[ Language.English ].type[Timer.Types.CIRCEL]= "Circel"
L[ Language.English ].type[Timer.Types.COUNTER_BAR]= "Bar"
L[ Language.English ].type[Timer.Types.ICON]= "Icon"
L[ Language.English ].type[Timer.Types.TEXT]= "Text"

L[ Language.French ].type = {}
L[ Language.French ].type[Timer.Types.BAR] = "Bar"
L[ Language.French ].type[Timer.Types.CIRCEL]= "Circel"
L[ Language.French ].type[Timer.Types.COUNTER_BAR]= "Bar"
L[ Language.French ].type[Timer.Types.ICON]= "Icon"
L[ Language.French ].type[Timer.Types.TEXT]= "Text"

L[ Language.German ].type = {}
L[ Language.German ].type[Timer.Types.BAR] = "Bar"
L[ Language.German ].type[Timer.Types.CIRCEL]= "Circel"
L[ Language.German ].type[Timer.Types.COUNTER_BAR]= "Bar"
L[ Language.German ].type[Timer.Types.ICON]= "Icon"
L[ Language.German ].type[Timer.Types.TEXT]= "Text"

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

L[ Language.English ].windowType = {}
L[ Language.English ].windowType[ Window.Types.TIMER_WINDOW ] = "Timer Window"
L[ Language.English ].windowType[ Window.Types.COUNTER_WINDOW ] = "Counter Window"

L[ Language.French ].windowType = {}
L[ Language.French ].windowType[ Window.Types.TIMER_WINDOW ] = "Timer Window"
L[ Language.French ].windowType[ Window.Types.COUNTER_WINDOW ] = "Counter Window"

L[ Language.German ].windowType = {}
L[ Language.German ].windowType[ Window.Types.TIMER_WINDOW ] = "Timer Window"
L[ Language.German ].windowType[ Window.Types.COUNTER_WINDOW ] = "Counter Window"

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