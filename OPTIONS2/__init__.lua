-- standalone controls
import "Gibberish3.OPTIONS2.ELEMENTS.CheckBox"
import "Gibberish3.OPTIONS2.ELEMENTS.Tooltip"

-- compound controls (each subfolder has its own __init__)
import "Gibberish3.OPTIONS2.ELEMENTS.DROPDOWN"
import "Gibberish3.OPTIONS2.ELEMENTS.TABWINDOW"
import "Gibberish3.OPTIONS2.ELEMENTS.RIGHT_CLICK_MENU"

-- row widgets (depend on CheckBox, Tooltip, Dropdown)
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.TextBoxRow"
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.NumberBoxRow"
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.SliderBoxRow"
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.ColorBoxRow"
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.CheckBoxRow"
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.DropDownRow"
import "Gibberish3.OPTIONS2.ELEMENTS.OPTIONS_ROW.IconBoxRow"

-- window shell first (defines Options2.Window = {})
import "Gibberish3.OPTIONS2.WINDOW.BaseWindow"
import "Gibberish3.OPTIONS2.WINDOW.DeletePopup"
import "Gibberish3.OPTIONS2.WINDOW.ImportDialog"
-- navigation tree adds Options2.Window.Nav.* to the existing table
import "Gibberish3.OPTIONS2.WINDOW.NAV"
-- editor panel (depends on NAV for node types, depends on elements for row widgets)
import "Gibberish3.OPTIONS2.WINDOW.EDITOR"
-- library panel (skills / effects / chat + clipboard bar)
import "Gibberish3.OPTIONS2.WINDOW.LIBRARY"
-- startup and clipboard helpers (must be last)
import "Gibberish3.OPTIONS2.Functions"

-- singleton tooltip used by all row widgets
Options2.Elements.TooltipObject = Options2.Elements.Tooltip()
