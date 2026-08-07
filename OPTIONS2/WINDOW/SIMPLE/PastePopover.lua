-- Simple mode: the paste popover.
--
-- Advanced paste is two steps — click paste to arm a field, the library column
-- switches to a tab that can fill it, then click an item. Simple mode has no
-- library column and the field's type is already known from Tracks, so the
-- arming step is dropped: the popover opens straight onto the one collection
-- that can fill the field, and clicking an item writes it.
--
-- Built as an unparented Turbine.UI.Window holding a Control frame, the same
-- shape DeletePopup and the dropdown popup use: an unparented window floats
-- over everything with no z-order juggling, and Deactivated closes it.
--
-- The recorder is the panel's existing one (Options.CollectEffects /
-- Options.CollectChat) — there is no second recording mechanism, and recording
-- keeps running if the popover closes.

local POP_W    = 276
local HEAD_H   = 26
local FILTER_H = 26
local REC_H    = 24
local SEP_H    = 1
local LIST_MAX = 184
local ITEM_H   = 36
local ICON_SZ  = 32
local SCROLL_W = 10
local PAD      = 8
local GAP      = 8
local BTN_H    = 18
local ANCHOR_DROP = 26   -- below the field's top edge

local FONT_BODY  = Turbine.UI.Lotro.Font.Verdana12
local FONT_SMALL = Turbine.UI.Lotro.Font.Verdana10

-- the one place the palette needs a green wash, matching the library column
local REC_BG   = Turbine.UI.Color(0.082, 0.165, 0.110)
local REC_TEXT = Turbine.UI.Color(0.561, 0.839, 0.627)

-- ── item row ────────────────────────────────────────────────────────────────

-- Sized around the icon rather than scaling the icon to the row: stretching
-- inside a ListBox that has a scrollbar draws the image outside the list.
Options2SimplePasteItem = class(Turbine.UI.Control)
function Options2SimplePasteItem:Constructor(popover, data, typeIdx)
    Turbine.UI.Control.Constructor(self)

    self.popover = popover
    self.data    = data
    self.current = false

    self:SetHeight(ITEM_H)
    self:SetMouseVisible(true)

    self.icon = Turbine.UI.Control()
    self.icon:SetParent(self)
    self.icon:SetPosition(PAD, math.floor((ITEM_H - ICON_SZ) / 2))
    self.icon:SetMouseVisible(false)
    if not Options2.Elements.RowParts.SetNativeIcon(self.icon, data.icon) then
        self.icon:SetBackColor(Options.Defaults.window.bg)
    end

    self.token = Turbine.UI.Label()
    self.token:SetParent(self)
    self.token:SetFont(FONT_BODY)
    self.token:SetForeColor(Options.Defaults.window.text)
    self.token:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.token:SetMouseVisible(false)

    self.sub = Turbine.UI.Label()
    self.sub:SetParent(self)
    self.sub:SetFont(FONT_SMALL)
    self.sub:SetForeColor(Options.Defaults.window.text_faint)
    self.sub:SetTextAlignment(Turbine.UI.ContentAlignment.BottomLeft)
    self.sub:SetText(Options2.Simple.SubLine(data, typeIdx))
    self.sub:SetMouseVisible(false)

    self.MouseEnter = function()
        if not self.current then self:SetBackColor(Options.Defaults.window.row_odd) end
    end
    self.MouseLeave = function() self:_Refresh() end
    self.MouseClick = function() self.popover:Pick(self.data) end

    self:_Refresh()
end

function Options2SimplePasteItem:SetCurrent(v)
    self.current = v
    self:_Refresh()
end

function Options2SimplePasteItem:_Refresh()
    self:SetBackColor(self.current and Options.Defaults.window.select or nil)
end

function Options2SimplePasteItem:SizeChanged()
    if self.token == nil then return end
    local w, h = self:GetSize()
    if w <= 0 then return end

    local P      = Options2.Elements.RowParts
    local left   = PAD + ICON_SZ + GAP
    local text_w = math.max(0, w - left - PAD)

    self.token:SetPosition(left, 0)
    self.token:SetSize(text_w, h)
    self.token:SetText(P.Truncate(self.data.token or "", P.CharBudget(text_w)))

    self.sub:SetPosition(left, 0)
    self.sub:SetSize(text_w, h)
end

-- ── popover ─────────────────────────────────────────────────────────────────

Options2.Window.SimplePaste = class(Turbine.UI.Window)

function Options2.Window.SimplePaste:Constructor()
    Turbine.UI.Window.Constructor(self)

    self.kind       = nil
    self.typeIdx    = nil
    self.canRecord  = false
    self.filterText = ""
    self.onPick     = nil
    self.onClose    = nil

    self:SetWidth(POP_W)
    self:SetVisible(false)
    self:SetWantsKeyEvents(false)
    -- the window's own fill is the 1px accent border
    self:SetBackColor(Options.Defaults.window.accent)

    self.Deactivated = function() self:Close() end

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetPosition(1, 1)
    self.frame:SetWidth(POP_W - 2)
    self.frame:SetBackColor(Options.Defaults.window.bg_sunken)
    self.frame:SetMouseVisible(false)

    -- header: which collection this is, and which field it fills
    self.head = Turbine.UI.Control()
    self.head:SetParent(self.frame)
    self.head:SetPosition(0, 0)
    self.head:SetSize(POP_W - 2, HEAD_H)
    self.head:SetBackColor(Options.Defaults.window.select)
    self.head:SetMouseVisible(false)

    self.head_title = Turbine.UI.Label()
    self.head_title:SetParent(self.head)
    self.head_title:SetPosition(PAD, 0)
    self.head_title:SetHeight(HEAD_H)
    self.head_title:SetFont(FONT_SMALL)
    self.head_title:SetForeColor(Options.Defaults.window.accent)
    self.head_title:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_title:SetMouseVisible(false)

    self.head_fills = Turbine.UI.Label()
    self.head_fills:SetParent(self.head)
    self.head_fills:SetHeight(HEAD_H)
    self.head_fills:SetFont(FONT_SMALL)
    self.head_fills:SetForeColor(Options.Defaults.window.accent)
    self.head_fills:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.head_fills:SetMouseVisible(false)

    -- filter
    self.filter_row = Turbine.UI.Control()
    self.filter_row:SetParent(self.frame)
    self.filter_row:SetPosition(0, HEAD_H)
    self.filter_row:SetSize(POP_W - 2, FILTER_H)
    self.filter_row:SetMouseVisible(false)

    self.filter_icon = Turbine.UI.Control()
    self.filter_icon:SetParent(self.filter_row)
    self.filter_icon:SetSize(16, 16)
    self.filter_icon:SetPosition(PAD, math.floor((FILTER_H - 16) / 2))
    self.filter_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.filter_icon:SetBackground("Gibberish3/RESOURCES/search.tga")
    self.filter_icon:SetMouseVisible(true)
    self.filter_icon.MouseClick = function() self.filter:Focus() end

    local filter_left = PAD + 16 + GAP
    local filter_w    = POP_W - 2 - filter_left - PAD

    self.filter = Turbine.UI.TextBox()
    self.filter:SetParent(self.filter_row)
    self.filter:SetPosition(filter_left, 2)
    self.filter:SetSize(filter_w, FILTER_H - 4)
    self.filter:SetFont(FONT_BODY)
    self.filter:SetForeColor(Options.Defaults.window.text)
    self.filter:SetBackColor(nil)
    self.filter:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.filter:SetMultiline(false)
    self.filter:SetSelectable(true)
    self.filter.TextChanged = function()
        self.filterText = string.lower(self.filter:GetText())
        self.filter_hint:SetVisible(self.filterText == "")
        self:_FillList()
    end

    -- Turbine.UI.TextBox has no placeholder, so this sits over the empty box
    self.filter_hint = Turbine.UI.Label()
    self.filter_hint:SetParent(self.filter_row)
    self.filter_hint:SetPosition(filter_left + 2, 0)
    self.filter_hint:SetSize(filter_w, FILTER_H)
    self.filter_hint:SetFont(FONT_BODY)
    self.filter_hint:SetForeColor(Options.Defaults.window.text_faint)
    self.filter_hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.filter_hint:SetMouseVisible(false)

    self.filter_sep = Turbine.UI.Control()
    self.filter_sep:SetParent(self.frame)
    self.filter_sep:SetPosition(0, HEAD_H + FILTER_H)
    self.filter_sep:SetSize(POP_W - 2, SEP_H)
    self.filter_sep:SetBackColor(Options.Defaults.window.line)
    self.filter_sep:SetMouseVisible(false)

    -- record row, only for the collections the game fills
    self.rec = Turbine.UI.Control()
    self.rec:SetParent(self.frame)
    self.rec:SetSize(POP_W - 2, REC_H)
    self.rec:SetMouseVisible(false)

    self.rec_dot = Turbine.UI.Control()
    self.rec_dot:SetParent(self.rec)
    self.rec_dot:SetSize(7, 7)
    self.rec_dot:SetPosition(PAD, math.floor((REC_H - 7) / 2))
    self.rec_dot:SetBackColor(Options.Defaults.window.on)
    self.rec_dot:SetMouseVisible(false)

    self.rec_label = Turbine.UI.Label()
    self.rec_label:SetParent(self.rec)
    self.rec_label:SetHeight(REC_H)
    self.rec_label:SetFont(FONT_SMALL)
    self.rec_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.rec_label:SetMouseVisible(false)

    self.rec_btn = Turbine.UI.Control()
    self.rec_btn:SetParent(self.rec)
    self.rec_btn:SetHeight(BTN_H)
    self.rec_btn:SetTop(math.floor((REC_H - BTN_H) / 2))
    self.rec_btn:SetBackColor(Options.Defaults.window.line)
    self.rec_btn:SetMouseVisible(true)

    self.rec_btn_fill = Turbine.UI.Control()
    self.rec_btn_fill:SetParent(self.rec_btn)
    self.rec_btn_fill:SetPosition(1, 1)
    self.rec_btn_fill:SetMouseVisible(false)

    self.rec_btn_label = Turbine.UI.Label()
    self.rec_btn_label:SetParent(self.rec_btn_fill)
    self.rec_btn_label:SetFont(FONT_SMALL)
    self.rec_btn_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.rec_btn_label:SetMouseVisible(false)

    self.rec_btn.MouseEnter = function()
        self.rec_btn_fill:SetBackColor(Options.Defaults.window.select)
    end
    self.rec_btn.MouseLeave = function() self:_RefreshRecord() end
    self.rec_btn.MouseClick = function() self:_ToggleRecording() end

    -- list
    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self.frame)
    self.listbox:SetBackColor(Options.Defaults.window.bg_sunken)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self.frame)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.listbox:SetVerticalScrollBar(self.scrollbar)

    self.empty = Turbine.UI.Label()
    self.empty:SetParent(self.frame)
    self.empty:SetHeight(ITEM_H)
    self.empty:SetFont(FONT_BODY)
    self.empty:SetForeColor(Options.Defaults.window.text_faint)
    self.empty:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.empty:SetVisible(false)
    self.empty:SetMouseVisible(false)
end

-- ── open / close ────────────────────────────────────────────────────────────

-- anchor is the field the popover hangs under; it is right-aligned to it.
function Options2.Window.SimplePaste:Open(anchor, kind, token_label, current, on_pick, on_close)
    self.kind    = kind
    self.current = current or ""
    self.onPick  = on_pick
    self.onClose = on_close

    local typeIdx, _, can_record = Options2.Simple.CollectionFor(kind)
    self.typeIdx   = typeIdx
    self.canRecord = can_record

    self.head_title:SetText(UTILS.GetText("options2", "paste_coll_" .. typeIdx))
    self.head_fills:SetText(
        string.format(UTILS.GetText("options2", "fills_field"), token_label or ""))
    self.filter_hint:SetText(UTILS.GetText("options2", "find_library"))
    self.empty:SetText(UTILS.GetText("options2", "paste_empty"))

    self.filter:SetText("")
    self.filterText = ""
    self.filter_hint:SetVisible(true)

    self:_RefreshRecord()
    self:_FillList()

    local ax, ay = anchor:PointToScreen(0, 0)
    self:SetPosition(ax + anchor:GetWidth() - POP_W, ay + ANCHOR_DROP)

    self:SetVisible(true)
    self:Activate()
end

function Options2.Window.SimplePaste:Close()
    if not self:IsVisible() then return end
    self:SetVisible(false)
    self.closedAt = Turbine.Engine.GetGameTime()
    if self.onClose ~= nil then self.onClose() end
end

-- Clicking the paste button while the popover is open deactivates it first, so
-- by the time the click arrives the popover is already hidden and the button
-- would reopen what the user just dismissed. Treat a click that lands in the
-- instant after a close as the close it belongs to.
function Options2.Window.SimplePaste:JustClosed()
    if self.closedAt == nil then return false end
    return (Turbine.Engine.GetGameTime() - self.closedAt) < 0.25
end

function Options2.Window.SimplePaste:Pick(data)
    local fn = self.onPick
    self:Close()
    if fn ~= nil then fn(data) end
end

-- ── list ────────────────────────────────────────────────────────────────────

function Options2.Window.SimplePaste:_FillList()
    if self.kind == nil then return end

    self.listbox:ClearItems()

    local typeIdx, items = Options2.Simple.CollectionFor(self.kind)
    local shown = 0

    for _, data in ipairs(items) do
        local token = data.token or ""
        if self.filterText == "" or string.find(string.lower(token), self.filterText, 1, true) then
            local row = Options2SimplePasteItem(self, data, typeIdx)
            row:SetWidth(POP_W - 2 - SCROLL_W)
            row:SetCurrent(token == self.current)
            self.listbox:AddItem(row)
            shown = shown + 1
        end
    end

    self.empty:SetVisible(shown == 0)
    self:_ApplyLayout(shown)
end

-- ── recording ───────────────────────────────────────────────────────────────

function Options2.Window.SimplePaste:_IsRecording()
    if self.typeIdx == 2 then return Options.CollectEffects == true end
    if self.typeIdx == 3 then return Options.CollectChat == true end
    return false
end

function Options2.Window.SimplePaste:_ToggleRecording()
    if self.typeIdx == 2 then
        Options.CollectEffects = not Options.CollectEffects
        if Options.CollectEffects then
            -- seed with what is already on the player, as the library does
            local effects = LocalPlayer:GetEffects()
            for i = 1, effects:GetCount() do
                Trigger.AddToEffectCollection(effects:Get(i), "Self")
            end
        end
    elseif self.typeIdx == 3 then
        Options.CollectChat = not Options.CollectChat
    else
        return
    end

    self:_RefreshRecord()
    self:_FillList()
end

function Options2.Window.SimplePaste:_RefreshRecord()
    self.rec:SetVisible(self.canRecord)
    if not self.canRecord then return end

    local recording = self:_IsRecording()

    if recording then
        self.rec:SetBackColor(REC_BG)
        self.rec_dot:SetVisible(true)
        self.rec_label:SetForeColor(REC_TEXT)
        self.rec_label:SetText(UTILS.GetText("options2",
            self.typeIdx == 3 and "recording_chat" or "recording_effects"))
        self:_SetRecordButton(UTILS.GetText("options2", "stop"), REC_BG, REC_TEXT)
    else
        self.rec:SetBackColor(Options.Defaults.window.row_even)
        self.rec_dot:SetVisible(false)
        self.rec_label:SetForeColor(Options.Defaults.window.text_muted)
        self.rec_label:SetText(UTILS.GetText("options2", "paste_record_hint"))
        self:_SetRecordButton(UTILS.GetText("options2", "record"),
            Options.Defaults.window.bg_sunken, Options.Defaults.window.text_muted)
    end
end

function Options2.Window.SimplePaste:_SetRecordButton(text, bg, fg)
    self.rec_btn_label:SetText(text)
    local w = 2 * PAD + string.len(text) * 6
    self.rec_btn:SetWidth(w)
    self.rec_btn_fill:SetSize(w - 2, BTN_H - 2)
    self.rec_btn_label:SetSize(w - 2, BTN_H - 2)
    self.rec_btn_fill:SetBackColor(bg)
    self.rec_btn_label:SetForeColor(fg)

    local inner_w = POP_W - 2
    self.rec_btn:SetLeft(inner_w - PAD - w)
    local label_left = self.rec_dot:IsVisible() and (PAD + 7 + GAP) or PAD
    self.rec_label:SetPosition(label_left, 0)
    self.rec_label:SetWidth(math.max(0, inner_w - label_left - PAD - w - GAP))
end

-- collection changed while the popover is open
function Options2.Window.SimplePaste:CollectionChanged()
    if not self:IsVisible() then return end
    self:_FillList()
end

-- ── layout ──────────────────────────────────────────────────────────────────

function Options2.Window.SimplePaste:_ApplyLayout(item_count)
    local inner_w = POP_W - 2

    self.head_fills:SetPosition(inner_w - PAD - math.floor(inner_w * 0.55), 0)
    self.head_fills:SetWidth(math.floor(inner_w * 0.55))
    self.head_title:SetWidth(math.max(0, inner_w - 2 * PAD - math.floor(inner_w * 0.55)))

    local y = HEAD_H + FILTER_H + SEP_H
    if self.canRecord then
        self.rec:SetPosition(0, y)
        y = y + REC_H
    end

    local list_h = math.min(math.max(item_count, 1) * ITEM_H, LIST_MAX)
    local list_w = inner_w - SCROLL_W

    self.listbox:SetPosition(0, y)
    self.listbox:SetSize(list_w, list_h)
    self.scrollbar:SetPosition(list_w, y)
    self.scrollbar:SetSize(SCROLL_W, list_h)

    self.empty:SetPosition(PAD, y)
    self.empty:SetWidth(math.max(0, inner_w - 2 * PAD))

    local total = y + list_h
    self.frame:SetHeight(total)
    self:SetHeight(total + 2)
end
