-- standalone controls
import "Gibberish3.OPTIONS2.ELEMENTS.CheckBox"
import "Gibberish3.OPTIONS2.ELEMENTS.Tooltip"
-- shared row chrome for the structure and contents columns
import "Gibberish3.OPTIONS2.ELEMENTS.RowParts"
-- frameless window chrome, base class for every options window
import "Gibberish3.OPTIONS2.ELEMENTS.PanelWindow"

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
-- right-click menus, shared by both list columns
import "Gibberish3.OPTIONS2.WINDOW.ContextMenus"
-- structure column adds Options2.Window.Nav.* to the existing table
import "Gibberish3.OPTIONS2.WINDOW.NAV"
-- contents column: everything inside the selected folder or window
import "Gibberish3.OPTIONS2.WINDOW.CONTENT"
-- editor panel (depends on NAV for node types, depends on elements for row widgets)
import "Gibberish3.OPTIONS2.WINDOW.EDITOR"
-- standalone settings window (hosts the settings panel defined under EDITOR)
import "Gibberish3.OPTIONS2.WINDOW.SettingsWindow"
-- library panel (skills / effects / chat + clipboard bar)
import "Gibberish3.OPTIONS2.WINDOW.LIBRARY"
-- startup and clipboard helpers (must be last)
import "Gibberish3.OPTIONS2.Functions"

-- shared Options.* state, shortcut button, and move-window mode
import "Gibberish3.OPTIONS2.SHORTCUT.Functions"
import "Gibberish3.OPTIONS2.MOVE.Window"
import "Gibberish3.OPTIONS2.SHORTCUT.Window"

-- singleton tooltip used by all row widgets
Options2.Elements.TooltipObject = Options2.Elements.Tooltip()

-- create objects
Options.Shortcut.Object = Options.Shortcut.Constructor()
