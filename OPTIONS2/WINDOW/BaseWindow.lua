-- Options panel: title bar + four columns
--   1 structure (nav)  2 contents  3 editor  4 library
-- Columns 1 and 4 collapse to a 30px strip; the state is persisted per character.
--
-- Chrome (border, title bar, drag, close, resize) comes from
-- Options2.Elements.PanelWindow.

local SEP_W        = 1
local PAD          = 8
local GAP          = 8
local BTN_SIZE     = 22
local BTN_ICON     = 16
local DIV_H        = 16
local TITLE_H      = 30

-- column slots include their own 1px rule
local COL_STRUCT_W = 272
local COL_CONT_W   = 348
local COL_LIB_W    = 230
local COL_EDIT_MIN = 200
local COLLAPSED_W  = 30

local STRIP_BTN    = 18
local STRIP_ICON   = 16

-- "Library" -> "L\ni\nb\nr\na\ny", for the collapsed strips.
-- Splits on utf-8 sequences so accented names stay intact.
local function stack_text(text)
    local out = {}
    for char in string.gmatch(text, "[\1-\127\194-\244][\128-\191]*") do
        out[#out + 1] = char
    end
    return table.concat(out, "\n")
end

-- Tooltip.AddTooltip owns MouseEnter/MouseLeave, so wrap it to keep the hover fill.
local function add_hover_tooltip(control, description, enter_fn, leave_fn)
    Options2.Elements.Tooltip.AddTooltip(control, "tooltip", description, false)
    local tip_enter = control.MouseEnter
    local tip_leave = control.MouseLeave
    control.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        enter_fn()
    end
    control.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        leave_fn()
    end
end

-- rest_color fills the button when it is neither hovered nor active; pass nil
-- for a toggle that should read as empty when off.
local function make_title_btn(parent, icon_path, description, click_fn, rest_color)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetSize(BTN_SIZE, BTN_SIZE)
    btn:SetMouseVisible(true)

    local icon = Turbine.UI.Control()
    icon:SetParent(btn)
    icon:SetSize(BTN_ICON, BTN_ICON)
    icon:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2), 1)
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(icon_path)
    icon:SetMouseVisible(false)

    -- A .tga background cannot be tinted (SetBackColor fills the control behind
    -- the glyph rather than colouring it), so the accent state is carried by a
    -- 2px bar under the icon.
    local accent = Turbine.UI.Control()
    accent:SetParent(btn)
    accent:SetSize(BTN_ICON, 2)
    accent:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2), BTN_SIZE - 3)
    accent:SetBackColor(Options.Defaults.window.accent)
    accent:SetVisible(false)
    accent:SetMouseVisible(false)

    btn.icon    = icon
    btn.accent  = accent
    btn.active  = false
    btn.hovered = false
    btn.rest    = rest_color

    function btn:ApplyState()
        if self.hovered then
            self:SetBackColor(Options.Defaults.window.line)
        elseif self.active then
            self:SetBackColor(Options.Defaults.window.select)
        else
            self:SetBackColor(self.rest)
        end
        self.accent:SetVisible(self.active)
    end

    add_hover_tooltip(btn, description,
        function() btn.hovered = true  btn:ApplyState() end,
        function() btn.hovered = false btn:ApplyState() end)

    btn.MouseClick = click_fn
    btn:ApplyState()

    return btn
end

-- collapsed 30px strip: expand arrow over a vertical column name
local function make_strip(parent, icon_path, expand_fn)
    local strip = Turbine.UI.Control()
    strip:SetParent(parent)
    strip:SetBackColor(Options.Defaults.window.bg_sunken)
    strip:SetVisible(false)
    strip:SetMouseVisible(true)

    local btn = Turbine.UI.Control()
    btn:SetParent(strip)
    btn:SetSize(STRIP_BTN, STRIP_BTN)
    btn:SetPosition(math.floor((COLLAPSED_W - SEP_W - STRIP_BTN) / 2), PAD)
    btn:SetMouseVisible(false)

    local icon = Turbine.UI.Control()
    icon:SetParent(btn)
    icon:SetSize(STRIP_ICON, STRIP_ICON)
    icon:SetPosition(math.floor((STRIP_BTN - STRIP_ICON) / 2), math.floor((STRIP_BTN - STRIP_ICON) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(icon_path)
    icon:SetMouseVisible(false)

    local LABEL_TOP = PAD + STRIP_BTN + GAP

    local label = Turbine.UI.Label()
    label:SetParent(strip)
    label:SetPosition(0, LABEL_TOP)
    label:SetWidth(COLLAPSED_W - SEP_W)
    label:SetMultiline(true)
    label:SetFont(Options.Defaults.window.font)
    label:SetForeColor(Options.Defaults.window.text_muted)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter)
    label:SetMouseVisible(false)

    strip.MouseEnter = function() strip:SetBackColor(Options.Defaults.window.select) end
    strip.MouseLeave = function() strip:SetBackColor(Options.Defaults.window.bg_sunken) end
    strip.MouseClick = expand_fn

    strip.label = label

    strip.SizeChanged = function()
        local _, h = strip:GetSize()
        label:SetHeight(math.max(0, h - LABEL_TOP - PAD))
    end

    return strip
end

Options2.Window = {}

Options2.Window.Constructor = class(Options2.Elements.PanelWindow)
function Options2.Window.Constructor:Constructor()
    Options2.Elements.PanelWindow.Constructor(self, {
        resizable  = true,
        min_width  = Options.Defaults.window.min_width,
        min_height = Options.Defaults.window.min_height,
    })

    self.structureCollapsed = (Options2.GetPanelState("structureCollapsed") == true)
    self.libraryCollapsed   = (Options2.GetPanelState("libraryCollapsed")   == true)

    -- ── title bar extras (left of the close button) ─────────────────────────
    self.btn_structure = make_title_btn(self.titlebar,
        "Gibberish3/RESOURCES/col_structure.tga", "o2_structure",
        function() self:_SetStructureCollapsed(not self.structureCollapsed) end)

    self.btn_library = make_title_btn(self.titlebar,
        "Gibberish3/RESOURCES/col_library.tga", "o2_library",
        function() self:_SetLibraryCollapsed(not self.libraryCollapsed) end)

    -- centred path of whatever the editor is showing
    self.breadcrumb = Turbine.UI.Label()
    self.breadcrumb:SetParent(self.titlebar)
    self.breadcrumb:SetHeight(TITLE_H)
    self.breadcrumb:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    self.breadcrumb:SetForeColor(Options.Defaults.window.text_faint)
    self.breadcrumb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.breadcrumb:SetMouseVisible(false)

    self.title_div = Turbine.UI.Control()
    self.title_div:SetParent(self.titlebar)
    self.title_div:SetSize(SEP_W, DIV_H)
    self.title_div:SetBackColor(Options.Defaults.window.line)
    self.title_div:SetMouseVisible(false)

    -- neither the gear nor reload is a toggle, so they carry a resting fill
    -- rather than an active state
    self.btn_reload = make_title_btn(self.titlebar,
        "Gibberish3/RESOURCES/reload.tga", "o2_reload",
        function() Options.Reload() end,
        Options.Defaults.window.select)

    self.btn_settings = make_title_btn(self.titlebar,
        "Gibberish3/RESOURCES/gear.tga", "o2_settings",
        function() Options2.ToggleSettingsWindow() end,
        Options.Defaults.window.select)

    -- ── column 1: structure ─────────────────────────────────────────────────
    self.nav = Options2.Window.Nav.Constructor()
    self.nav:SetParent(self.client)

    self.struct_strip = make_strip(self.client,
        "Gibberish3/RESOURCES/chevron_right.tga",
        function() self:_SetStructureCollapsed(false) end)

    self.sep1 = Turbine.UI.Control()
    self.sep1:SetParent(self.client)
    self.sep1:SetBackColor(Options.Defaults.window.line)
    self.sep1:SetMouseVisible(false)

    -- ── column 2: contents ──────────────────────────────────────────────────
    self.contents = Options2.Window.Content.Constructor()
    self.contents:SetParent(self.client)

    self.sep2 = Turbine.UI.Control()
    self.sep2:SetParent(self.client)
    self.sep2:SetBackColor(Options.Defaults.window.line)
    self.sep2:SetMouseVisible(false)

    -- ── column 3: editor ────────────────────────────────────────────────────
    self.editor_panel = Options2.Window.Editor.Constructor()
    self.editor_panel:SetParent(self.client)

    self.sep3 = Turbine.UI.Control()
    self.sep3:SetParent(self.client)
    self.sep3:SetBackColor(Options.Defaults.window.line)
    self.sep3:SetMouseVisible(false)

    -- ── column 4: library ───────────────────────────────────────────────────
    self.library = Options2.Library.Window()
    self.library:SetParent(self.client)

    self.lib_strip = make_strip(self.client,
        "Gibberish3/RESOURCES/chevron_left.tga",
        function() self:_SetLibraryCollapsed(false) end)

    self:_RefreshTexts()
    self:_RefreshToggles()

    self:SetText("Gibberish")
    self:SetSize(Options.Defaults.window.min_width, Options.Defaults.window.min_height)

    local l2 = Data.options.window.left2 or Data.options.window.left
    local t2 = Data.options.window.top2  or Data.options.window.top
    self:SetPosition(UTILS.ScreenRatioToPixel(l2, t2))

    self:SetWantsKeyEvents(true)
    self.KeyDown = function(sender, args)
        if args.Action == Turbine.UI.Lotro.Action.Escape then
            self:CloseWindow()
        end
    end

    self.Closed = function()
        Data.options.window.open2 = false
    end

    self:SetVisible(true)

    -- populate nav tree after first layout (SetSize fires SizeChanged first)
    self.nav:Rebuild()

    -- Options2.Window.Object isn't assigned until after this constructor returns,
    -- so Rebuild's restore loop can't call SetNode. Do it explicitly here.
    if self.nav.selectedItem ~= nil then
        self.editor_panel:SetNode(self.nav.selectedItem.nodeData)
        self.contents:SetContainer(self.nav.selectedItem.nodeData)
    end
end

function Options2.Window.Constructor:SetBreadcrumb(text)
    if self.breadcrumb == nil then return end
    self.breadcrumb:SetText(text or "")
end

function Options2.Window.Constructor:CloseWindow()
    self:SetVisible(false)
    Data.options.window.open2 = false
end

-- ── collapse state ──────────────────────────────────────────────────────────

function Options2.Window.Constructor:_SetStructureCollapsed(collapsed)
    self.structureCollapsed = collapsed
    Options2.SetPanelState("structureCollapsed", collapsed)
    self:_RefreshToggles()
    self:_ApplyLayout()
end

function Options2.Window.Constructor:_SetLibraryCollapsed(collapsed)
    self.libraryCollapsed = collapsed
    Options2.SetPanelState("libraryCollapsed", collapsed)
    self:_RefreshToggles()
    self:_ApplyLayout()
end

function Options2.Window.Constructor:_RefreshToggles()
    self.btn_structure.active = not self.structureCollapsed
    self.btn_library.active   = not self.libraryCollapsed
    self.btn_structure:ApplyState()
    self.btn_library:ApplyState()
end

function Options2.Window.Constructor:_RefreshTexts()
    self:SetTitleText(UTILS.GetText("options2", "brand"))
    self.struct_strip.label:SetText(stack_text(UTILS.GetText("options2", "structure")))
    self.lib_strip.label:SetText(stack_text(UTILS.GetText("options2", "library")))
end

-- ── window plumbing ─────────────────────────────────────────────────────────

function Options2.Window.Constructor:LanguageChanged()
    if self.nav == nil then return end
    self:_RefreshTexts()
    self.nav:LanguageChanged()
    if self.contents ~= nil then self.contents:LanguageChanged() end
    if self.editor_panel ~= nil and self.editor_panel.LanguageChanged ~= nil then
        self.editor_panel:LanguageChanged()
    end
    if self.library ~= nil and self.library.LanguageChanged ~= nil then
        self.library:LanguageChanged()
    end
end

function Options2.Window.Constructor:_SavePosition()
    local left, top = UTILS.PixelToScreenRatio(self:GetPosition())
    Data.options.window.left2 = left
    Data.options.window.top2  = top
end

function Options2.Window.Constructor:PositionChanged()
    self:_SavePosition()
end

-- PanelWindow drag hook, in case PositionChanged does not fire for a
-- programmatic SetPosition
function Options2.Window.Constructor:OnMoved()
    self:_SavePosition()
end

-- ── layout ──────────────────────────────────────────────────────────────────

function Options2.Window.Constructor:OnLayout(iw, ih)
    if self.nav == nil then return end

    -- title bar extras, right to left from the close button
    local btn_top = math.floor((TITLE_H - BTN_SIZE) / 2)
    local x = self:TitleBarRight() - BTN_SIZE
    self.btn_settings:SetPosition(x, btn_top)
    x = x - GAP - BTN_SIZE
    self.btn_reload:SetPosition(x, btn_top)
    x = x - GAP - SEP_W
    self.title_div:SetPosition(x, math.floor((TITLE_H - DIV_H) / 2))
    x = x - GAP - BTN_SIZE
    self.btn_library:SetPosition(x, btn_top)
    x = x - GAP - BTN_SIZE
    self.btn_structure:SetPosition(x, btn_top)

    self.title_label:SetWidth(math.max(0, x - GAP - PAD))

    -- the path sits between the brand and the buttons
    local crumb_left = PAD + 90
    self.breadcrumb:SetPosition(crumb_left, 0)
    self.breadcrumb:SetWidth(math.max(0, x - GAP - crumb_left))

    self:_ApplyLayout()
end

function Options2.Window.Constructor:_ApplyLayout()
    if self.nav == nil then return end
    local iw, ih = self.client:GetSize()
    if iw <= 0 or ih <= 0 then return end

    -- each slot includes the 1px rule drawn at its inner edge
    local struct_slot = self.structureCollapsed and COLLAPSED_W or COL_STRUCT_W
    local lib_slot    = self.libraryCollapsed   and COLLAPSED_W or COL_LIB_W
    local cont_slot   = COL_CONT_W

    local edit_w = iw - struct_slot - cont_slot - lib_slot
    if edit_w < COL_EDIT_MIN then
        cont_slot = math.max(SEP_W, cont_slot - (COL_EDIT_MIN - edit_w))
        edit_w    = math.max(0, iw - struct_slot - cont_slot - lib_slot)
    end

    -- column 1
    local col_w = struct_slot - SEP_W
    self.nav:SetVisible(not self.structureCollapsed)
    self.struct_strip:SetVisible(self.structureCollapsed)
    -- the hidden panel keeps its full width so its own row layout stays valid
    self.nav:SetPosition(0, 0)
    self.nav:SetSize(COL_STRUCT_W - SEP_W, ih)
    self.struct_strip:SetPosition(0, 0)
    self.struct_strip:SetSize(COLLAPSED_W - SEP_W, ih)

    self.sep1:SetPosition(col_w, 0)
    self.sep1:SetSize(SEP_W, ih)

    -- column 2
    local cont_left = struct_slot
    local cont_w    = cont_slot - SEP_W
    self.contents:SetPosition(cont_left, 0)
    self.contents:SetSize(cont_w, ih)

    self.sep2:SetPosition(cont_left + cont_w, 0)
    self.sep2:SetSize(SEP_W, ih)

    -- column 3
    local edit_left = struct_slot + cont_slot
    self.editor_panel:SetPosition(edit_left, 0)
    self.editor_panel:SetSize(edit_w, ih)

    -- column 4
    local lib_sep_left = edit_left + edit_w
    self.sep3:SetPosition(lib_sep_left, 0)
    self.sep3:SetSize(SEP_W, ih)

    local lib_left = lib_sep_left + SEP_W
    self.library:SetVisible(not self.libraryCollapsed)
    self.lib_strip:SetVisible(self.libraryCollapsed)
    self.library:SetPosition(lib_left, 0)
    self.library:SetSize(COL_LIB_W - SEP_W, ih)
    self.lib_strip:SetPosition(lib_left, 0)
    self.lib_strip:SetSize(COLLAPSED_W - SEP_W, ih)
end
