-- Options panel: title bar + four columns
--   1 structure (nav)  2 contents  3 editor  4 library
-- Columns 1 and 4 collapse to a 30px strip; the state is persisted per character.
--
-- A Simple / Advanced switch in the title bar picks which panel is shown.
-- Advanced is the four columns below; simple is a narrower panel that edits one
-- timer at a time. The mode is persisted per character like the collapse flags.
--
-- Chrome (border, title bar, drag, close, resize) comes from
-- Options2.Elements.PanelWindow.

local SEP_W        = 1
local PAD          = 8
local GAP          = 8
local BTN_ICON     = 16
local DIV_H        = 16
local COLLAPSED_W  = 30

local STRIP_BTN    = 18
local STRIP_ICON   = 16

local SW_PAD       = 10   -- padding either side of a segment's label
local SW_ACCENT_H  = 2

-- Everything below holds text, so it follows the panel's font size. The column
-- widths are the minimum each column needs for its own labels; the fixed art
-- above (separators, padding, strip glyphs) does not scale.
local BTN_SIZE     = 22
local TITLE_H      = 30

-- column slots include their own 1px rule
local COL_STRUCT_W = 272
local COL_CONT_W   = 348
local COL_LIB_W    = 230
local COL_EDIT_MIN = 200

-- simple mode uses a narrower structure column; its other two live in SIMPLE/
local SIMPLE_STRUCT_W = 240

-- mode switch
local SW_H         = 22
local SW_CHAR      = 6    -- Verdana is proportional; this is the width budget

Options2.Fonts.Register(function()
    local F = Options2.Fonts
    BTN_SIZE        = F.Px(22)
    TITLE_H         = F.Px(30)
    COL_STRUCT_W    = F.Px(272)
    COL_CONT_W      = F.Px(348)
    COL_LIB_W       = F.Px(230)
    COL_EDIT_MIN    = F.Px(200)
    SIMPLE_STRUCT_W = F.Px(240)
    SW_H            = F.Px(22)
    SW_CHAR         = F.Px(6)
end)

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
    icon:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2),
                     math.floor((BTN_SIZE - BTN_ICON) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(icon_path)
    icon:SetMouseVisible(false)

    -- A .tga background cannot be tinted (SetBackColor fills the control behind
    -- the glyph rather than colouring it), so the accent state is carried by a
    -- 2px bar under the icon.
    local accent = Turbine.UI.Control()
    accent:SetParent(btn)
    accent:SetSize(BTN_ICON, 2)
    accent:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2), BTN_SIZE - 2)
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

-- Collapsed 30px strip: an expand arrow, and nothing else. The column name
-- used to be stacked one letter per line, which never sat straight; the design
-- turns it on its side, which Turbine cannot do for a Label (see CLAUDE.md).
-- The arrow plus its tooltip say which column this is without either problem.
local function make_strip(parent, icon_path, description, expand_fn)
    local strip = Turbine.UI.Control()
    strip:SetParent(parent)
    strip:SetBackColor(Options.Defaults.window.bg_sunken)
    strip:SetVisible(false)
    strip:SetMouseVisible(true)

    local inner_w  = COLLAPSED_W - SEP_W
    local btn_left = math.floor((inner_w - STRIP_BTN) / 2)

    local btn = Turbine.UI.Control()
    btn:SetParent(strip)
    btn:SetSize(STRIP_BTN, STRIP_BTN)
    btn:SetPosition(btn_left, PAD)
    btn:SetMouseVisible(false)

    local icon = Turbine.UI.Control()
    icon:SetParent(btn)
    icon:SetSize(STRIP_ICON, STRIP_ICON)
    icon:SetPosition(math.floor((STRIP_BTN - STRIP_ICON) / 2), math.floor((STRIP_BTN - STRIP_ICON) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(icon_path)
    icon:SetMouseVisible(false)

    -- with no label, the tooltip is the only thing naming the column
    add_hover_tooltip(strip, description,
        function() strip:SetBackColor(Options.Defaults.window.select) end,
        function() strip:SetBackColor(Options.Defaults.window.bg_sunken) end)

    strip.MouseClick = expand_fn

    return strip
end

-- Two-segment Simple / Advanced switch.
--
-- The switch's own fill paints the 1px border and the segments sit inside it,
-- so the two share one outline rather than each drawing their own. The active
-- segment is picked out by a 2px accent bar along its bottom edge, the same
-- language the title-bar toggles use — a .tga cannot be tinted, so state has to
-- be carried by primitives (see CLAUDE.md).
local function make_mode_switch(parent, pick_fn)
    local sw = Turbine.UI.Control()
    sw:SetParent(parent)
    sw:SetHeight(SW_H)
    sw:SetBackColor(Options.Defaults.window.line)
    sw:SetMouseVisible(false)

    local function make_segment(mode)
        local seg = Turbine.UI.Control()
        seg:SetParent(sw)
        seg:SetTop(1)
        seg:SetHeight(SW_H - 2)
        seg:SetMouseVisible(true)

        local label = Turbine.UI.Label()
        label:SetParent(seg)
        label:SetHeight(SW_H - 2)
        label:SetFont(Options2.Fonts.SMALL)
        label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
        label:SetMouseVisible(false)

        local accent = Turbine.UI.Control()
        accent:SetParent(seg)
        accent:SetHeight(SW_ACCENT_H)
        accent:SetBackColor(Options.Defaults.window.accent)
        accent:SetVisible(false)
        accent:SetMouseVisible(false)

        seg.label   = label
        seg.mode    = mode
        seg.active  = false
        seg.hovered = false

        function seg:ApplyState()
            if self.active then
                self:SetBackColor(Options.Defaults.window.select)
                label:SetForeColor(Options.Defaults.window.text)
            elseif self.hovered then
                self:SetBackColor(Options.Defaults.window.select)
                label:SetForeColor(Options.Defaults.window.text)
            else
                self:SetBackColor(Options.Defaults.window.bg_sunken)
                label:SetForeColor(Options.Defaults.window.text_muted)
            end
            accent:SetVisible(self.active)
        end

        function seg:SetLabel(text)
            label:SetText(text)
            local w = 2 * SW_PAD + string.len(text) * SW_CHAR
            self:SetWidth(w)
            label:SetWidth(w)
            accent:SetPosition(0, SW_H - 2 - SW_ACCENT_H)
            accent:SetWidth(w)
        end

        seg.MouseEnter = function() seg.hovered = true  seg:ApplyState() end
        seg.MouseLeave = function() seg.hovered = false seg:ApplyState() end
        seg.MouseClick = function() pick_fn(seg.mode) end

        seg:ApplyState()
        return seg
    end

    sw.seg_simple   = make_segment(Options2.Mode.SIMPLE)
    sw.seg_advanced = make_segment(Options2.Mode.ADVANCED)

    -- Labels come from the localisation tables, so their widths change with the
    -- language; the switch measures itself from them every time they are set.
    function sw:SetLabels(simple_text, advanced_text)
        self.seg_simple:SetLabel(simple_text)
        self.seg_advanced:SetLabel(advanced_text)
        self.seg_simple:SetLeft(1)
        self.seg_advanced:SetLeft(1 + self.seg_simple:GetWidth())
        self:SetWidth(2 + self.seg_simple:GetWidth() + self.seg_advanced:GetWidth())
    end

    function sw:SetMode(mode)
        self.seg_simple.active   = (mode == Options2.Mode.SIMPLE)
        self.seg_advanced.active = (mode == Options2.Mode.ADVANCED)
        self.seg_simple:ApplyState()
        self.seg_advanced:ApplyState()
    end

    return sw
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
    self.mode               = Options2.GetMode()

    -- ── mode switch ─────────────────────────────────────────────────────────
    self.mode_switch = make_mode_switch(self.titlebar,
        function(mode) Options2.SetMode(mode) end)

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
    self.breadcrumb:SetFont(Options2.Fonts.SMALL)
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
        "Gibberish3/RESOURCES/chevron_right.tga", "o2_structure",
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
        "Gibberish3/RESOURCES/chevron_left.tga", "o2_library",
        function() self:_SetLibraryCollapsed(false) end)

    -- ── simple mode: columns B and C ────────────────────────────────────────
    -- The structure column is not duplicated here. Simple mode reuses the one
    -- nav instance above, laid out to the left of this panel.
    self.simple = Options2.Window.Simple.Constructor()
    self.simple:SetParent(self.client)
    self.simple:SetVisible(false)

    self:_RefreshTexts()
    self:_RefreshToggles()

    self:SetText("Gibberish")
    -- open at the size the restored mode needs, not always the advanced one
    if self:IsSimpleMode() then
        self:SetSize(Options.Defaults.window.min_width_simple,
                     Options.Defaults.window.min_height_simple)
    else
        self:SetSize(Options.Defaults.window.min_width,
                     Options.Defaults.window.min_height)
    end

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

    self:ApplyMode()
    self:SetVisible(true)

    -- populate nav tree after first layout (SetSize fires SizeChanged first)
    self.nav:Rebuild()

    -- Options2.Window.Object isn't assigned until after this constructor returns,
    -- so neither column's restore loop can reach the editor through it. Do it
    -- explicitly here, in the order the columns are nested.
    if self.nav.selectedItem ~= nil then
        self.editor_panel:SetNode(self.nav.selectedItem.nodeData)
        self.contents:SetContainer(self.nav.selectedItem.nodeData)
        self.simple:SetContainer(self.nav.selectedItem.nodeData)

        -- SetContainer may have restored a row inside the container. That row,
        -- not the container, is what was last being edited.
        if self.contents.selectedItem ~= nil then
            self.editor_panel:SetNode(self.contents.selectedItem.nodeData)
        end
    end
end

function Options2.Window.Constructor:SetBreadcrumb(text)
    if self.breadcrumb == nil then return end
    self.breadcrumb:SetText(text or "")
end

function Options2.Window.Constructor:CloseWindow()
    -- the paste popover is an unparented window; it does not go with the panel
    if self.simple ~= nil then self.simple.fields:ClosePaste() end
    self:SetVisible(false)
    Data.options.window.open2 = false
end

-- ── mode ────────────────────────────────────────────────────────────────────

function Options2.Window.Constructor:IsSimpleMode()
    return self.mode == Options2.Mode.SIMPLE
end

-- Re-read the persisted mode and redraw for it. Called from Options2.SetMode,
-- so a switch made anywhere reaches the panel by the one path.
function Options2.Window.Constructor:ApplyMode()
    if self.mode_switch == nil then return end
    self.mode = Options2.GetMode()
    self.mode_switch:SetMode(self.mode)

    -- the two column toggles steer columns that simple mode does not show
    local advanced = not self:IsSimpleMode()
    self.btn_structure:SetVisible(advanced)
    self.btn_library:SetVisible(advanced)
    self.breadcrumb:SetVisible(advanced)

    -- the popover floats over everything, so it must not survive the switch
    if self.simple ~= nil then self.simple.fields:ClosePaste() end

    -- hand the current selection over so the panel opens on it rather than empty
    if self.simple ~= nil and self.nav ~= nil and self.nav.selectedItem ~= nil then
        self.simple:SetContainer(self.nav.selectedItem.nodeData)
    end

    if advanced then
        self:SetMinSize(Options.Defaults.window.min_width,
                        Options.Defaults.window.min_height)
    else
        self:SetMinSize(Options.Defaults.window.min_width_simple,
                        Options.Defaults.window.min_height_simple)
    end

    -- SetMinSize only resizes when the window is under the new floor, so lay
    -- out explicitly rather than relying on a SizeChanged that may not fire
    local rw, ch = self.client:GetSize()
    self:OnLayout(rw, ch)
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

-- text_faint, for the markup the title label renders
local VERSION_RGB = "#5C6076"

function Options2.Window.Constructor:_RefreshTexts()
    self:SetTitleText(UTILS.GetText("options2", "brand")
        .. "  <rgb=" .. VERSION_RGB .. ">" .. (Options.Version or "") .. "</rgb>")

    self.mode_switch:SetLabels(UTILS.GetText("options2", "mode_simple"),
                               UTILS.GetText("options2", "mode_advanced"))
    self.mode_switch:SetMode(self.mode)
end

-- ── window plumbing ─────────────────────────────────────────────────────────

function Options2.Window.Constructor:LanguageChanged()
    if self.nav == nil then return end
    self:_RefreshTexts()
    -- the switch measures itself from its labels, so its width just changed
    local rw, ch = self.client:GetSize()
    self:OnLayout(rw, ch)
    self.nav:LanguageChanged()
    if self.contents ~= nil then self.contents:LanguageChanged() end
    if self.editor_panel ~= nil and self.editor_panel.LanguageChanged ~= nil then
        self.editor_panel:LanguageChanged()
    end
    if self.library ~= nil and self.library.LanguageChanged ~= nil then
        self.library:LanguageChanged()
    end
    if self.simple ~= nil then self.simple:LanguageChanged() end
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
    -- The switch is placed before the column toggles so that only the fixed
    -- buttons sit between it and the close button. The toggles are hidden in
    -- simple mode, and hiding them must not shift the switch under the cursor.
    x = x - GAP - self.mode_switch:GetWidth()
    self.mode_switch:SetPosition(x, math.floor((TITLE_H - SW_H) / 2))

    if self.btn_library:IsVisible() then
        x = x - GAP - BTN_SIZE
        self.btn_library:SetPosition(x, btn_top)
    end
    if self.btn_structure:IsVisible() then
        x = x - GAP - BTN_SIZE
        self.btn_structure:SetPosition(x, btn_top)
    end

    self.title_label:SetWidth(math.max(0, x - GAP - PAD))

    -- the path sits between the brand and the toggles
    local crumb_left = PAD + 90
    self.breadcrumb:SetPosition(crumb_left, 0)
    self.breadcrumb:SetWidth(math.max(0, x - GAP - crumb_left))

    self:_ApplyLayout()
end

function Options2.Window.Constructor:_ApplyLayout()
    if self.nav == nil then return end
    local iw, ih = self.client:GetSize()
    if iw <= 0 or ih <= 0 then return end

    -- Simple mode: the shared structure column, then its own two columns. The
    -- advanced-only columns come down rather than being laid out behind them.
    if self.simple ~= nil and self:IsSimpleMode() then
        self.contents:SetVisible(false)
        self.sep2:SetVisible(false)
        self.editor_panel:SetVisible(false)
        self.sep3:SetVisible(false)
        self.library:SetVisible(false)
        self.lib_strip:SetVisible(false)

        -- the structure column cannot be collapsed here; its toggle is hidden
        local struct_w = math.min(SIMPLE_STRUCT_W - SEP_W, math.max(0, iw - SEP_W))
        self.struct_strip:SetVisible(false)
        self.nav:SetVisible(true)
        self.nav:SetPosition(0, 0)
        self.nav:SetSize(struct_w, ih)

        self.sep1:SetVisible(true)
        self.sep1:SetPosition(struct_w, 0)
        self.sep1:SetSize(SEP_W, ih)

        local simple_left = struct_w + SEP_W
        self.simple:SetVisible(true)
        self.simple:SetPosition(simple_left, 0)
        self.simple:SetSize(math.max(0, iw - simple_left), ih)
        return
    end

    if self.simple ~= nil then
        self.simple:SetVisible(false)
        self.sep1:SetVisible(true)
        self.contents:SetVisible(true)
        self.sep2:SetVisible(true)
        self.editor_panel:SetVisible(true)
        self.sep3:SetVisible(true)
    end

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
