-- Simple mode: the two columns right of the structure column.
--   B timers (219px)   C editor (flexes)
--
-- The structure column is not built here. Simple mode shows the *same* tree as
-- advanced, so BaseWindow keeps the one Options2.Window.Nav instance and lays
-- it out to the left of this panel; the nav pushes its selection in through
-- SetContainer. Two Nav instances would fight over the persisted selection.
--
-- The rows, the "+ Timer" button and the editor fields arrive in later steps;
-- this is the shell they drop into.

local HEADER_H  = 34
local SECTION_H = 20
local FOOTER_H  = 24
local SEP_H     = 1
local PAD       = 10
local GAP       = 8
local MARK      = 16
local SCROLL_W  = 10
local BTN_H     = 20
local BTN_PAD   = 8
local BTN_H2    = 22   -- the card's own button
local CARD_HD_H = 24
local REASON_H  = 20
local BODY_H    = 54   -- three wrapped lines of the read-only sentence
local MAX_REASON = 4

-- column B keeps a fixed width, column C takes what is left
local TIMERS_W  = 219

local FONT_TITLE = Turbine.UI.Lotro.Font.Verdana14
local FONT_BODY  = Turbine.UI.Lotro.Font.Verdana12
local FONT_SMALL = Turbine.UI.Lotro.Font.Verdana10

-- 1px-bordered text button, matching the contents column's add buttons
local function make_add_btn(parent, click_fn, tooltip)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H)
    btn:SetBackColor(Options.Defaults.window.line)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetBackColor(Options.Defaults.window.bg)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(FONT_SMALL)
    label:SetForeColor(Options.Defaults.window.text_muted)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    Options2.Elements.Tooltip.AddTooltip(btn, "tooltip", tooltip, false)
    local tip_enter, tip_leave = btn.MouseEnter, btn.MouseLeave
    btn.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        fill:SetBackColor(Options.Defaults.window.select)
    end
    btn.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        fill:SetBackColor(Options.Defaults.window.bg)
    end
    btn.MouseClick = click_fn

    function btn:SetLabel(text)
        label:SetText(text)
        local w = BTN_PAD * 2 + string.len(text) * 6
        self:SetWidth(w)
        fill:SetSize(w - 2, BTN_H - 2)
        label:SetSize(w - 2, BTN_H - 2)
    end

    return btn
end

-- outline button: 1px border, sunken fill, the label in the border's colour
local function make_outline_btn(parent, color, click_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H2)
    btn:SetBackColor(color)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetBackColor(Options.Defaults.window.bg_sunken)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(FONT_BODY)
    label:SetForeColor(color)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    btn.MouseEnter = function() fill:SetBackColor(Options.Defaults.window.select) end
    btn.MouseLeave = function() fill:SetBackColor(Options.Defaults.window.bg_sunken) end
    btn.MouseClick = click_fn

    function btn:SetLabel(text)
        label:SetText(text)
        local w = 2 * PAD + string.len(text) * 6
        self:SetWidth(w)
        fill:SetSize(w - 2, BTN_H2 - 2)
        label:SetSize(w - 2, BTN_H2 - 2)
    end

    -- Revert takes the border colour but muted text, so the two buttons do not
    -- read as equally weighted
    function btn:SetLabelColor(color) label:SetForeColor(color) end

    return btn
end

-- glyph and colour for each structural reason a timer is advanced-only
local REASON_STYLE = {
    triggers   = { icon = "trigger",   color = "color_trigger" },
    kind       = { icon = "trigger",   color = "color_trigger" },
    action     = { icon = "trigger",   color = "color_trigger" },
    conditions = { icon = "condition", color = "color_cond" },
}

Options2.Window.Simple = {}
Options2.Window.Simple.Constructor = class(Turbine.UI.Control)

function Options2.Window.Simple.Constructor:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.nodeData      = nil
    -- the editor shows the window itself, or whichever timer is picked
    self.windowSelected = false
    self.items        = {}
    self.selectedKey  = Options2.GetPanelState("simpleTimerKey")
    self.selectedItem = nil
    self._last_list_w = -1
    -- the persisted timer only wins on the first fill; after that, picking a
    -- window resets the selection to its first timer
    self._initial_restore = (self.selectedKey ~= nil)

    self:SetBackColor(Options.Defaults.window.bg)

    -- ── column B: timers ────────────────────────────────────────────────────
    self.timers = Turbine.UI.Control()
    self.timers:SetParent(self)
    self.timers:SetBackColor(Options.Defaults.window.bg)
    self.timers:SetMouseVisible(false)

    -- The header doubles as the row for the window itself, the same way the
    -- advanced contents column's header does: clicking it puts the window's own
    -- settings in the editor, which is where everything visual lives.
    self.timers_head = Turbine.UI.Control()
    self.timers_head:SetParent(self.timers)
    self.timers_head:SetPosition(0, 0)
    self.timers_head:SetHeight(HEADER_H)
    self.timers_head:SetBackColor(Options.Defaults.window.bg_sunken)
    self.timers_head:SetMouseVisible(true)
    self.timers_head.MouseEnter = function()
        if not self.windowSelected then
            self.timers_head:SetBackColor(Options.Defaults.window.row_odd)
        end
    end
    self.timers_head.MouseLeave = function() self:_UpdateHeaderState() end
    self.timers_head.MouseClick = function() self:SelectWindow() end

    self.head_rail = Turbine.UI.Control()
    self.head_rail:SetParent(self.timers_head)
    self.head_rail:SetPosition(0, 0)
    self.head_rail:SetSize(Options2.Elements.RowParts.RAIL_W, HEADER_H)
    self.head_rail:SetBackColor(Options.Defaults.window.color_window)
    self.head_rail:SetVisible(false)
    self.head_rail:SetMouseVisible(false)

    self.timers_mark = Options2.Elements.RowParts.MakeIcon(
        self.timers_head, Options2.Elements.RowParts.ICON.window, HEADER_H)
    self.timers_mark:SetLeft(PAD)
    self.timers_mark:SetVisible(false)

    self.timers_name = Turbine.UI.Label()
    self.timers_name:SetParent(self.timers_head)
    self.timers_name:SetHeight(HEADER_H)
    self.timers_name:SetFont(FONT_TITLE)
    self.timers_name:SetForeColor(Options.Defaults.window.text)
    self.timers_name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.timers_name:SetMouseVisible(false)

    self.btn_timer = make_add_btn(self.timers_head, function()
        self:AddTimer()
    end, "o2_add_timer")

    self.timers_head_sep = Turbine.UI.Control()
    self.timers_head_sep:SetParent(self.timers)
    self.timers_head_sep:SetPosition(0, HEADER_H)
    self.timers_head_sep:SetHeight(SEP_H)
    self.timers_head_sep:SetBackColor(Options.Defaults.window.line)
    self.timers_head_sep:SetMouseVisible(false)

    self.timers_section = Turbine.UI.Control()
    self.timers_section:SetParent(self.timers)
    self.timers_section:SetPosition(0, HEADER_H + SEP_H)
    self.timers_section:SetHeight(SECTION_H)
    self.timers_section:SetBackColor(Options.Defaults.window.row_even)
    self.timers_section:SetMouseVisible(false)

    self.timers_section_label = Turbine.UI.Label()
    self.timers_section_label:SetParent(self.timers_section)
    self.timers_section_label:SetPosition(PAD, 0)
    self.timers_section_label:SetHeight(SECTION_H)
    self.timers_section_label:SetFont(FONT_SMALL)
    self.timers_section_label:SetForeColor(Options.Defaults.window.text_faint)
    self.timers_section_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.timers_section_label:SetMouseVisible(false)

    self.timers_section_sep = Turbine.UI.Control()
    self.timers_section_sep:SetParent(self.timers)
    self.timers_section_sep:SetHeight(SEP_H)
    self.timers_section_sep:SetBackColor(Options.Defaults.window.line)
    self.timers_section_sep:SetMouseVisible(false)

    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self.timers)
    self.listbox:SetBackColor(Options.Defaults.window.bg)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self.timers)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.listbox:SetVerticalScrollBar(self.scrollbar)

    -- shown while no window is picked, or the picked window holds no timers
    self.timers_hint = Turbine.UI.Label()
    self.timers_hint:SetParent(self.timers)
    self.timers_hint:SetHeight(HEADER_H)
    self.timers_hint:SetFont(FONT_BODY)
    self.timers_hint:SetForeColor(Options.Defaults.window.text_faint)
    self.timers_hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.timers_hint:SetMouseVisible(false)

    self.sep = Turbine.UI.Control()
    self.sep:SetParent(self)
    self.sep:SetBackColor(Options.Defaults.window.line)
    self.sep:SetMouseVisible(false)

    -- ── column C: editor ────────────────────────────────────────────────────
    self.editor = Turbine.UI.Control()
    self.editor:SetParent(self)
    self.editor:SetBackColor(Options.Defaults.window.bg)
    self.editor:SetMouseVisible(false)

    self.editor_head = Turbine.UI.Control()
    self.editor_head:SetParent(self.editor)
    self.editor_head:SetPosition(0, 0)
    self.editor_head:SetHeight(HEADER_H)
    self.editor_head:SetBackColor(Options.Defaults.window.bg_sunken)
    self.editor_head:SetMouseVisible(false)

    self.editor_mark = Options2.Elements.RowParts.MakeIcon(
        self.editor_head, Options2.Elements.RowParts.ICON.timer, HEADER_H)
    self.editor_mark:SetLeft(PAD)
    self.editor_mark:SetVisible(false)

    self.editor_name = Turbine.UI.Label()
    self.editor_name:SetParent(self.editor_head)
    self.editor_name:SetHeight(HEADER_H)
    self.editor_name:SetFont(FONT_TITLE)
    self.editor_name:SetForeColor(Options.Defaults.window.text)
    self.editor_name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.editor_name:SetMouseVisible(false)

    -- names the kind the timer tracks, beside its name
    self.editor_kind = Turbine.UI.Label()
    self.editor_kind:SetParent(self.editor_head)
    self.editor_kind:SetHeight(HEADER_H)
    self.editor_kind:SetFont(FONT_SMALL)
    self.editor_kind:SetForeColor(Options.Defaults.window.text_faint)
    self.editor_kind:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.editor_kind:SetMouseVisible(false)

    self.btn_save = make_outline_btn(self.editor_head, Options.Defaults.window.accent,
        function() self:SaveTimer() end)
    self.btn_revert = make_outline_btn(self.editor_head, Options.Defaults.window.line,
        function() self:RevertTimer() end)
    self.btn_revert:SetLabelColor(Options.Defaults.window.text_muted)

    self.editor_head_sep = Turbine.UI.Control()
    self.editor_head_sep:SetParent(self.editor)
    self.editor_head_sep:SetPosition(0, HEADER_H)
    self.editor_head_sep:SetHeight(SEP_H)
    self.editor_head_sep:SetBackColor(Options.Defaults.window.line)
    self.editor_head_sep:SetMouseVisible(false)

    self.editor_body = Turbine.UI.Control()
    self.editor_body:SetParent(self.editor)
    self.editor_body:SetBackColor(Options.Defaults.window.bg)
    self.editor_body:SetMouseVisible(false)

    self.editor_hint = Turbine.UI.Label()
    self.editor_hint:SetParent(self.editor_body)
    self.editor_hint:SetFont(FONT_BODY)
    self.editor_hint:SetForeColor(Options.Defaults.window.text_faint)
    self.editor_hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.editor_hint:SetMouseVisible(false)

    self.fields = Options2.Window.SimpleEditor(self)
    self.fields:SetParent(self.editor_body)
    self.fields:SetVisible(false)

    self.win_fields = Options2.Window.SimpleWindowEditor(self)
    self.win_fields:SetParent(self.editor_body)
    self.win_fields:SetVisible(false)

    self:_BuildAdvancedCard()

    -- ── footer, under the editor column only ────────────────────────────────
    self.footer_sep = Turbine.UI.Control()
    self.footer_sep:SetParent(self.editor)
    self.footer_sep:SetHeight(SEP_H)
    self.footer_sep:SetBackColor(Options.Defaults.window.line)
    self.footer_sep:SetMouseVisible(false)

    self.footer = Turbine.UI.Control()
    self.footer:SetParent(self.editor)
    self.footer:SetHeight(FOOTER_H)
    self.footer:SetBackColor(Options.Defaults.window.row_even)
    self.footer:SetMouseVisible(false)

    self.footer_label = Turbine.UI.Label()
    self.footer_label:SetParent(self.footer)
    self.footer_label:SetPosition(PAD, 0)
    self.footer_label:SetHeight(FOOTER_H)
    self.footer_label:SetFont(FONT_SMALL)
    self.footer_label:SetForeColor(Options.Defaults.window.text_faint)
    self.footer_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.footer_label:SetMouseVisible(false)

    self.footer_note = Turbine.UI.Label()
    self.footer_note:SetParent(self.footer)
    self.footer_note:SetHeight(FOOTER_H)
    self.footer_note:SetFont(FONT_SMALL)
    self.footer_note:SetForeColor(Options.Defaults.window.text_faint)
    self.footer_note:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.footer_note:SetMouseVisible(false)

    self:_RefreshTexts()
    self:_RefreshHeader()
    self:Rebuild()
end

-- ── container ───────────────────────────────────────────────────────────────

-- Called by the structure column whenever its selection changes. A folder has
-- no timers of its own, so only a window fills this panel.
function Options2.Window.Simple.Constructor:SetContainer(nodeData)
    local prev_wi = self:GetWindowIndex()
    self.fields:ClosePaste()

    if nodeData ~= nil and nodeData.nodeType == "window" then
        self.nodeData = nodeData
    else
        self.nodeData = nil
    end

    -- Picking a different window starts on its first timer. Landing on the same
    -- one keeps the selection, so a save — which refreshes every column — does
    -- not bounce back to the top of the list. The persisted selection survives
    -- the first fill of the session only.
    if self:GetWindowIndex() ~= prev_wi and not self._initial_restore then
        self.selectedKey    = nil
        self.windowSelected = false
    end
    self._initial_restore = false

    self:_RefreshHeader()
    self:Rebuild()
end

function Options2.Window.Simple.Constructor:GetWindowIndex()
    if self.nodeData == nil then return nil end
    return self.nodeData.windowIndex
end

function Options2.Window.Simple.Constructor:_RefreshHeader()
    local nd = self.nodeData

    if nd == nil then
        self.timers_mark:SetVisible(false)
        self.timers_name:SetText("")
        self.btn_timer:SetVisible(false)
        self.windowSelected = false
        self:_UpdateHeaderState()
        return
    end

    local name = nd.data.name
    if name == nil or name == "" then
        name = UTILS.GetText("options2", "unnamed_window")
    end
    self.timers_mark:SetVisible(true)
    self.timers_name:SetText(name)
    self.btn_timer:SetVisible(true)
    self:_UpdateHeaderState()
end

-- ── timer list ──────────────────────────────────────────────────────────────

function Options2.Window.Simple.Constructor:Rebuild()
    if self.listbox == nil then return end

    self.listbox:ClearItems()
    self.items        = {}
    self.selectedItem = nil

    local wi = self:GetWindowIndex()
    local wd = wi ~= nil and Data.window[wi] or nil

    if wd == nil then
        self.timers_hint:SetText(UTILS.GetText("options2", "simple_no_window"))
        self.timers_hint:SetVisible(true)
        self:_SelectItem(nil)
        return
    end

    local list_w = self.listbox:GetWidth()
    if list_w <= 0 then list_w = TIMERS_W - SCROLL_W end

    for ti, td in ipairs(wd.timerList) do
        local row = Options2SimpleTimer(self, wi, ti, td, "t_" .. wi .. "_" .. ti)
        row:SetWidth(list_w)
        self.listbox:AddItem(row)
        self.items[#self.items + 1] = row
    end

    local empty = (#self.items == 0)
    self.timers_hint:SetText(UTILS.GetText("options2", "simple_no_timers"))
    self.timers_hint:SetVisible(empty)

    self:_RestoreSelection()
end

-- Keep whatever key is current if it is still in the list; SetContainer has
-- already cleared it when the window changed, which lands this on the first row.
function Options2.Window.Simple.Constructor:_RestoreSelection()
    -- a window with no timers has only its own settings to show
    if #self.items == 0 and self.nodeData ~= nil then
        self.windowSelected = true
    end

    if self.windowSelected then
        self:_SelectItem(nil)
        self:_UpdateHeaderState()
        return
    end

    for _, item in ipairs(self.items) do
        if item:GetKey() == self.selectedKey then
            self:_SelectItem(item)
            return
        end
    end
    self:_SelectItem(self.items[1])
end

-- clicking the header puts the window's own settings in the editor
function Options2.Window.Simple.Constructor:SelectWindow()
    if self.nodeData == nil then return end
    self.fields:ClosePaste()
    self.windowSelected = true

    if self.selectedItem ~= nil then
        self.selectedItem:SetSelected(false)
        self.selectedItem = nil
    end

    Options2.selectedNode = self.nodeData
    self:_UpdateHeaderState()
    self:_RefreshEditor()
end

function Options2.Window.Simple.Constructor:_UpdateHeaderState()
    local on = (self.windowSelected == true and self.nodeData ~= nil)
    self.head_rail:SetVisible(on)
    self.timers_head:SetBackColor(on and Options.Defaults.window.select
                                     or  Options.Defaults.window.bg_sunken)
end

function Options2.Window.Simple.Constructor:RowClicked(item)
    if self.selectedItem == item and not self.windowSelected then return end
    -- picking another timer must not leave a popover hanging over the new one
    self.fields:ClosePaste()
    self.windowSelected = false
    self:_UpdateHeaderState()
    self:_SelectItem(item)
    -- only a click owns the shared node; a rebuild's restore must not clobber
    -- whatever the advanced columns have selected
    Options2.selectedNode = item.nodeData
end

function Options2.Window.Simple.Constructor:_SelectItem(item)
    if self.selectedItem ~= nil and self.selectedItem ~= item then
        self.selectedItem:SetSelected(false)
    end

    self.selectedItem = item

    -- every rebuild restores a selection; only write to disk when it moved
    local key = item ~= nil and item:GetKey() or nil
    if key ~= self.selectedKey then
        self.selectedKey = key
        Options2.SetPanelState("simpleTimerKey", key)
    end

    if item ~= nil then item:SetSelected(true) end

    self:_RefreshEditor()
end

-- ── editor column ───────────────────────────────────────────────────────────

-- Three things can be on show: the window's own settings, a simple timer's
-- fields, or the read-only card for a timer built in advanced mode.
function Options2.Window.Simple.Constructor:_RefreshEditor()
    local item = self.selectedItem

    -- the window itself
    if self.windowSelected and self.nodeData ~= nil then
        local wd   = self.nodeData.data
        local name = (wd.name ~= nil and wd.name ~= "") and wd.name
            or UTILS.GetText("options2", "unnamed_window")

        self.editor_mark:SetBackground(Options2.Elements.RowParts.ICON.window)
        self.editor_mark:SetVisible(true)
        self.editor_name:SetText(name)
        self.editor_kind:SetText(UTILS.GetText("options2", "kind_window"))
        self.editor_hint:SetVisible(false)

        self.card:SetVisible(false)
        self.fields:SetVisible(false)
        self.win_fields:SetWindow(self.nodeData)
        self.win_fields:SetVisible(true)
        self.btn_save:SetVisible(true)
        self.btn_revert:SetVisible(true)

        self:_ApplyLayout()
        return
    end

    self.win_fields:SetVisible(false)

    if item == nil then
        self.editor_mark:SetVisible(false)
        self.editor_name:SetText("")
        self.editor_kind:SetText("")
        self.editor_hint:SetVisible(true)
        self.card:SetVisible(false)
        self.fields:SetVisible(false)
        self.btn_save:SetVisible(false)
        self.btn_revert:SetVisible(false)
        self:_ApplyLayout()
        return
    end

    local td   = item.nodeData.data
    local name = (td.description ~= nil and td.description ~= "")
        and td.description or UTILS.GetText("options2", "unnamed_timer")

    self.editor_mark:SetBackground(Options2.Elements.RowParts.ICON.timer)
    self.editor_mark:SetVisible(true)
    self.editor_name:SetText(name)
    self.editor_hint:SetVisible(false)

    -- a timer that fails the derived test is shown, but read-only
    local info = item.info or Options2.Simple.Inspect(td)

    if info.simple then
        self.card:SetVisible(false)
        self.fields:SetTimer(item.nodeData)
        self.fields:SetVisible(true)
        self.btn_save:SetVisible(true)
        self.btn_revert:SetVisible(true)
        self.editor_kind:SetText(UTILS.GetText("options2",
            "track_" .. (Options2.Simple.KIND_KEY[info.triggerType] or "self")))
    else
        -- nothing on the card is editable, so its actions are hidden; the
        -- window's look is still reachable through the header above
        self.fields:SetVisible(false)
        self.btn_save:SetVisible(false)
        self.btn_revert:SetVisible(false)
        self.editor_kind:SetText("")
        self._card_h = self:_FillAdvancedCard(info)
        self.card:SetVisible(true)
    end

    self:_ApplyLayout()
end

-- ── save / revert ───────────────────────────────────────────────────────────

-- the header's two buttons act on whichever panel is showing
function Options2.Window.Simple.Constructor:_ActivePanel()
    if self.win_fields:IsVisible() then return self.win_fields end
    if self.fields:IsVisible()     then return self.fields end
    return nil
end

function Options2.Window.Simple.Constructor:SaveTimer()
    local panel = self:_ActivePanel()
    if panel == nil then return end
    panel:Save()

    -- names, kinds, the display type and the derived test can all have moved
    Options2.RefreshAll()
end

function Options2.Window.Simple.Constructor:RevertTimer()
    local panel = self:_ActivePanel()
    if panel == nil then return end
    panel:Load()
end

-- ── adding ──────────────────────────────────────────────────────────────────

-- A new timer starts as an "Effect on me" so it is simple-representable from
-- birth: one trigger, of a kind the simple editor knows, and nothing else.
function Options2.Window.Simple.Constructor:AddTimer()
    local wi = self:GetWindowIndex()
    if wi == nil then return end
    local wd = Data.window[wi]
    if wd == nil then return end

    local tmd = Timer.New(wd.timerType)
    table.insert(tmd[Trigger.Types.EffectSelf], Trigger.New(Trigger.Types.EffectSelf))
    Window.AddTimer(wi, tmd)

    Options.SaveData()
    Options.DataChanged(wi)
    Windows.EnabledChanged(wi)

    -- rebuild every list column; the new row is the last one, and is selected
    Options2.RefreshAll()
    local added = self.items[#self.items]
    self.windowSelected = false
    self:_UpdateHeaderState()
    self:_SelectItem(added)
    if added ~= nil then Options2.selectedNode = added.nodeData end
end

-- ── the read-only card ──────────────────────────────────────────────────────
--
-- Shown instead of the fields when the selected timer fails the derived test.
-- It is visible rather than hidden so nobody thinks a timer vanished, and it is
-- never partly editable, which is what would corrupt it.

function Options2.Window.Simple.Constructor:_BuildAdvancedCard()
    local P = Options2.Elements.RowParts

    -- the card's own fill paints the 1px border, the interior sits inside it
    self.card = Turbine.UI.Control()
    self.card:SetParent(self.editor_body)
    self.card:SetBackColor(Options.Defaults.window.line)
    self.card:SetVisible(false)
    self.card:SetMouseVisible(false)

    self.card_inner = Turbine.UI.Control()
    self.card_inner:SetParent(self.card)
    self.card_inner:SetPosition(1, 1)
    self.card_inner:SetBackColor(Options.Defaults.window.bg_sunken)
    self.card_inner:SetMouseVisible(false)

    self.card_head = Turbine.UI.Control()
    self.card_head:SetParent(self.card_inner)
    self.card_head:SetPosition(0, 0)
    self.card_head:SetHeight(CARD_HD_H)
    self.card_head:SetBackColor(Options.Defaults.window.row_even)
    self.card_head:SetMouseVisible(false)

    self.card_head_label = Turbine.UI.Label()
    self.card_head_label:SetParent(self.card_head)
    self.card_head_label:SetPosition(PAD, 0)
    self.card_head_label:SetHeight(CARD_HD_H)
    self.card_head_label:SetFont(FONT_SMALL)
    self.card_head_label:SetForeColor(Options.Defaults.window.text_muted)
    self.card_head_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.card_head_label:SetMouseVisible(false)

    self.card_tag = Options2.Simple.MakeAdvTag(self.card_head, CARD_HD_H)

    self.card_head_sep = Turbine.UI.Control()
    self.card_head_sep:SetParent(self.card_inner)
    self.card_head_sep:SetPosition(0, CARD_HD_H)
    self.card_head_sep:SetHeight(SEP_H)
    self.card_head_sep:SetBackColor(Options.Defaults.window.line)
    self.card_head_sep:SetMouseVisible(false)

    self.card_body = Turbine.UI.Label()
    self.card_body:SetParent(self.card_inner)
    self.card_body:SetFont(FONT_BODY)
    self.card_body:SetForeColor(Options.Defaults.window.text)
    self.card_body:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.card_body:SetMouseVisible(false)

    -- reason rows are pooled: the list is short and its length changes with the
    -- timer, so they are built once and shown or hidden per selection
    self.card_reasons = {}
    for i = 1, MAX_REASON do
        local row = Turbine.UI.Control()
        row:SetParent(self.card_inner)
        row:SetHeight(REASON_H)
        row:SetVisible(false)
        row:SetMouseVisible(false)

        row.icon = P.MakeIcon(row, P.ICON.trigger, REASON_H)

        row.label = Turbine.UI.Label()
        row.label:SetParent(row)
        row.label:SetHeight(REASON_H)
        row.label:SetFont(FONT_BODY)
        row.label:SetForeColor(Options.Defaults.window.text_muted)
        row.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
        row.label:SetMouseVisible(false)

        row.meta = Turbine.UI.Label()
        row.meta:SetParent(row)
        row.meta:SetHeight(REASON_H)
        row.meta:SetFont(FONT_SMALL)
        row.meta:SetForeColor(Options.Defaults.window.text_faint)
        row.meta:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
        row.meta:SetMouseVisible(false)

        self.card_reasons[i] = row
    end

    self.card_div = Turbine.UI.Control()
    self.card_div:SetParent(self.card_inner)
    self.card_div:SetHeight(SEP_H)
    self.card_div:SetBackColor(Options.Defaults.window.line)
    self.card_div:SetMouseVisible(false)

    self.card_open = make_outline_btn(self.card_inner, Options.Defaults.window.accent,
        function() self:OpenInAdvanced() end)
end

-- Fill the card for a timer and return the height it needs.
function Options2.Window.Simple.Constructor:_FillAdvancedCard(info)
    self.card_head_label:SetText(UTILS.GetText("options2", "simple_adv_header"))
    self.card_body:SetText(UTILS.GetText("options2", "simple_adv_body"))
    self.card_open:SetLabel(UTILS.GetText("options2", "simple_adv_open"))

    local shown = 0
    for i, row in ipairs(self.card_reasons) do
        local r = info.reasons[i]
        if r == nil then
            row:SetVisible(false)
        else
            local style = REASON_STYLE[r.key] or REASON_STYLE.triggers
            row.icon:SetBackground(Options2.Elements.RowParts.ICON[style.icon])
            row.label:SetForeColor(Options.Defaults.window[style.color])
            row.label:SetText(UTILS.GetText("options2", "simple_reason_" .. r.key))
            row.meta:SetText(string.format(
                UTILS.GetText("options2", "simple_reason_" .. r.key .. "_meta"), r.count))
            row:SetVisible(true)
            shown = shown + 1
        end
    end

    self._card_reason_count = shown
    return CARD_HD_H + SEP_H + PAD + BODY_H + PAD
        + shown * REASON_H + PAD + SEP_H + PAD + BTN_H2 + PAD
end

function Options2.Window.Simple.Constructor:_LayoutAdvancedCard(w)
    -- a SizeChanged can arrive before the card is built
    if self.card == nil or not self.card:IsVisible() then return end

    local inner_w = math.max(0, w - 2)
    self.card:SetPosition(PAD, PAD)
    self.card:SetSize(w, self._card_h or 0)
    self.card_inner:SetSize(inner_w, math.max(0, (self._card_h or 0) - 2))

    self.card_head:SetWidth(inner_w)
    self.card_head_sep:SetWidth(inner_w)
    self.card_tag:SetLeft(math.max(0, inner_w - PAD - self.card_tag:GetWidth()))
    self.card_head_label:SetWidth(math.max(0,
        inner_w - 2 * PAD - self.card_tag:GetWidth() - GAP))

    local text_w = math.max(0, inner_w - 2 * PAD)
    local y = CARD_HD_H + SEP_H + PAD

    self.card_body:SetPosition(PAD, y)
    self.card_body:SetSize(text_w, BODY_H)
    y = y + BODY_H + PAD

    for _, row in ipairs(self.card_reasons) do
        if row:IsVisible() then
            row:SetPosition(PAD, y)
            row:SetWidth(text_w)
            row.icon:SetLeft(0)
            local label_left = MARK + GAP
            local meta_w     = math.floor(text_w * 0.45)
            row.label:SetPosition(label_left, 0)
            row.label:SetWidth(math.max(0, text_w - label_left - meta_w - GAP))
            row.meta:SetPosition(math.max(0, text_w - meta_w), 0)
            row.meta:SetWidth(meta_w)
            y = y + REASON_H
        end
    end

    y = y + PAD
    self.card_div:SetPosition(PAD, y)
    self.card_div:SetWidth(text_w)
    y = y + SEP_H + PAD

    self.card_open:SetPosition(PAD, y)
end

-- Switch to advanced with this timer still selected. Both list columns key
-- timers the same way, so handing the key to the contents column is enough.
function Options2.Window.Simple.Constructor:OpenInAdvanced()
    local item = self.selectedItem
    local obj  = Options2.Window.Object
    if item == nil or obj == nil then return end

    if obj.contents ~= nil then
        obj.contents.selectedKey = item:GetKey()
        Options2.SaveContentState(item:GetKey())
        obj.contents:Rebuild()
    end

    Options2.SetMode(Options2.Mode.ADVANCED)
end

-- ── texts ───────────────────────────────────────────────────────────────────

function Options2.Window.Simple.Constructor:_RefreshTexts()
    self.timers_section_label:SetText(UTILS.GetText("options2", "simple_timers"))
    self.btn_timer:SetLabel(UTILS.GetText("options2", "add_timer"))
    self.btn_save:SetLabel(UTILS.GetText("options2", "save"))
    self.btn_revert:SetLabel(UTILS.GetText("options2", "revert"))
    self.editor_hint:SetText(UTILS.GetText("options2", "simple_no_timer"))
    self.footer_note:SetText(UTILS.GetText("options2", "simple_footer_note"))
    self.footer_label:SetText("")
end

function Options2.Window.Simple.Constructor:LanguageChanged()
    if self.timers == nil then return end
    self:_RefreshTexts()
    self:_RefreshHeader()
    self.fields:LanguageChanged()
    self.win_fields:LanguageChanged()
    self.card_tag:LanguageChanged()
    self:Rebuild()
    self:_ApplyLayout()
end

-- ── layout ──────────────────────────────────────────────────────────────────

function Options2.Window.Simple.Constructor:SizeChanged()
    if self.timers == nil then return end
    self:_ApplyLayout()
end

function Options2.Window.Simple.Constructor:_ApplyLayout()
    local w, h = self:GetSize()
    if w <= 0 or h <= 0 then return end

    -- column B, then the rule, then whatever is left for column C
    local timers_w = math.min(TIMERS_W, math.max(0, w - SEP_H))
    local editor_w = math.max(0, w - timers_w - SEP_H)

    self.timers:SetPosition(0, 0)
    self.timers:SetSize(timers_w, h)
    self.timers_head:SetWidth(timers_w)
    self.timers_head_sep:SetWidth(timers_w)
    self.timers_section:SetWidth(timers_w)
    self.timers_section_label:SetWidth(math.max(0, timers_w - 2 * PAD))

    -- "+ Timer" sits at the right of the header, the name takes what is left
    local name_right = timers_w - PAD
    if self.btn_timer:IsVisible() then
        self.btn_timer:SetPosition(timers_w - PAD - self.btn_timer:GetWidth(),
                                   math.floor((HEADER_H - BTN_H) / 2))
        name_right = name_right - self.btn_timer:GetWidth() - GAP
    end

    local name_left = PAD + MARK + GAP
    self.timers_name:SetPosition(name_left, 0)
    self.timers_name:SetWidth(math.max(0, name_right - name_left))

    local list_top = HEADER_H + SEP_H + SECTION_H
    self.timers_section_sep:SetPosition(0, list_top)
    self.timers_section_sep:SetWidth(timers_w)
    list_top = list_top + SEP_H

    local list_w = math.max(0, timers_w - SCROLL_W)
    local list_h = math.max(0, h - list_top)
    self.listbox:SetPosition(0, list_top)
    self.listbox:SetSize(list_w, list_h)
    self.scrollbar:SetPosition(list_w, list_top)
    self.scrollbar:SetSize(SCROLL_W, list_h)

    self.timers_hint:SetPosition(PAD, list_top)
    self.timers_hint:SetWidth(math.max(0, timers_w - 2 * PAD))

    if list_w ~= self._last_list_w then
        self._last_list_w = list_w
        for _, item in ipairs(self.items) do item:SetWidth(list_w) end
    end

    self.sep:SetPosition(timers_w, 0)
    self.sep:SetSize(SEP_H, h)

    self.editor:SetPosition(timers_w + SEP_H, 0)
    self.editor:SetSize(editor_w, h)
    self.editor_head:SetWidth(editor_w)
    self.editor_head_sep:SetWidth(editor_w)

    -- Save and Revert sit at the right; the name and kind take what is left
    local ex = editor_w - PAD
    if self.btn_revert:IsVisible() then
        ex = ex - self.btn_revert:GetWidth()
        self.btn_revert:SetPosition(ex, math.floor((HEADER_H - BTN_H2) / 2))
        ex = ex - GAP
    end
    if self.btn_save:IsVisible() then
        ex = ex - self.btn_save:GetWidth()
        self.btn_save:SetPosition(ex, math.floor((HEADER_H - BTN_H2) / 2))
        ex = ex - GAP
    end

    local ed_name_left = PAD + MARK + GAP
    local ed_avail     = math.max(0, ex - ed_name_left)
    local ed_name_w    = math.floor(ed_avail * 0.62)
    self.editor_name:SetPosition(ed_name_left, 0)
    self.editor_name:SetWidth(ed_name_w)
    self.editor_kind:SetPosition(ed_name_left + ed_name_w + GAP, 0)
    self.editor_kind:SetWidth(math.max(0, ed_avail - ed_name_w - GAP))

    local footer_top = h - FOOTER_H
    self.footer_sep:SetPosition(0, footer_top - SEP_H)
    self.footer_sep:SetWidth(editor_w)
    self.footer:SetPosition(0, footer_top)
    self.footer:SetWidth(editor_w)

    -- the note keeps its own width on the right; the label takes the rest
    local note_w = math.floor(editor_w * 0.5)
    self.footer_note:SetPosition(math.max(0, editor_w - PAD - note_w), 0)
    self.footer_note:SetWidth(note_w)
    self.footer_label:SetWidth(math.max(0, editor_w - 2 * PAD - note_w - GAP))

    local body_top = HEADER_H + SEP_H
    local body_h   = math.max(0, footer_top - SEP_H - body_top)
    self.editor_body:SetPosition(0, body_top)
    self.editor_body:SetSize(editor_w, body_h)
    self.editor_hint:SetSize(editor_w, body_h)

    local panel_w = math.max(0, editor_w - 2 * PAD)
    local panel_h = math.max(0, body_h - 2 * PAD)
    self.fields:SetPosition(PAD, PAD)
    self.fields:SetSize(panel_w, panel_h)
    self.win_fields:SetPosition(PAD, PAD)
    self.win_fields:SetSize(panel_w, panel_h)

    self:_LayoutAdvancedCard(math.max(0, editor_w - 2 * PAD))
end
