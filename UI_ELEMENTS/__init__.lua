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

-- timer specific tables
for index, timerType in pairs( Timer.Types ) do

    Timer[timerType] = {}

end

-- timer imports
import "Gibberish3.UI_ELEMENTS.TIMER.BAR"
import "Gibberish3.UI_ELEMENTS.TIMER.CIRCEL"
import "Gibberish3.UI_ELEMENTS.TIMER.ICON"
import "Gibberish3.UI_ELEMENTS.TIMER.TEXT"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window types
Window.Types.LISTBOX = 1

-- window specific tables
for index, windowType in pairs( Window.Types ) do

    Window[windowType] = {}

end

-- window imports
import "Gibberish3.UI_ELEMENTS.WINDOWS.LISTBOX"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window functions
import "Gibberish3.UI_ELEMENTS.WINDOWS.Functions"
---------------------------------------------------------------------------------------------------