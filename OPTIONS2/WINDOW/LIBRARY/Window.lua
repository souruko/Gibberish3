-- Library column: header, tab strip (Skills / Effects / Chat), filter, a status
-- line, the active tab's list, and the "Copied" footer.
--
-- When the editor arms a field, the header names it, the tab strip jumps to a
-- tab that can fill it, and clicking an item writes straight into it.

local HEADER_H = 26
local TAB_H    = 26
local FILTER_H = 26
local STATUS_H = 24
local SEP_H    = 1
local PAD      = 8
local GAP      = 6
local ICON_SZ  = 16
local BTN_H    = 18

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    HEADER_H = F.Px(26)
    TAB_H    = F.Px(26)
    FILTER_H = F.Px(26)
    STATUS_H = F.Px(24)
    BTN_H    = F.Px(18)
end)

-- recording banner colours, the one place the palette needs a green wash
local REC_BG   = Turbine.UI.Color(0.082, 0.165, 0.110)
local REC_TEXT = Turbine.UI.Color(0.561, 0.839, 0.627)

-- assigned rather than built as a literal: a nil key would throw
local EFFECT_TYPES = {}
for _, name in ipairs({ "EffectSelf", "EffectGroup", "EffectTarget", "EffectRemoveSelf" }) do
    local tt = Trigger.Types[name]
    if tt ~= nil then EFFECT_TYPES[tt] = true end
end

-- small bordered text button
local function make_text_btn(parent, click_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H)
    btn:SetBackColor(Options.Defaults.window.line)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(Options2.Fonts.SMALL)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    btn._fill  = fill
    btn._label = label

    function btn:SetTone(bg, fg)
        self._bg_idle = bg
        fill:SetBackColor(bg)
        label:SetForeColor(fg)
    end

    function btn:SetLabel(text)
        label:SetText(text)
        local w = 16 + string.len(text) * 6
        self:SetWidth(w)
        fill:SetSize(w - 2, BTN_H - 2)
        label:SetSize(w - 2, BTN_H - 2)
    end

    btn.MouseEnter = function() fill:SetBackColor(Options.Defaults.window.select) end
    btn.MouseLeave = function() fill:SetBackColor(btn._bg_idle) end
    btn.MouseClick = click_fn

    btn:SetTone(Options.Defaults.window.bg_sunken, Options.Defaults.window.text_muted)
    return btn
end

-- tab: label plus a 2px accent underline when active
local function make_tab(parent, click_fn)
    local tab = Turbine.UI.Control()
    tab:SetParent(parent)
    tab:SetHeight(TAB_H)
    tab:SetMouseVisible(true)

    local label = Turbine.UI.Label()
    label:SetParent(tab)
    label:SetHeight(TAB_H)
    label:SetFont(Options2.Fonts.SMALL)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    local underline = Turbine.UI.Control()
    underline:SetParent(tab)
    underline:SetHeight(2)
    underline:SetBackColor(Options.Defaults.window.accent)
    underline:SetVisible(false)
    underline:SetMouseVisible(false)

    tab.label     = label
    tab.underline = underline
    tab.active    = false

    function tab:ApplyState()
        if self.active then
            self:SetBackColor(Options.Defaults.window.row_odd)
            label:SetForeColor(Options.Defaults.window.text)
        else
            self:SetBackColor(nil)
            label:SetForeColor(Options.Defaults.window.text_muted)
        end
        underline:SetVisible(self.active)
    end

    function tab:Layout(w)
        self:SetWidth(w)
        label:SetWidth(w)
        underline:SetPosition(0, TAB_H - 2)
        underline:SetWidth(w)
    end

    tab.MouseEnter = function()
        if not tab.active then tab:SetBackColor(Options.Defaults.window.row_even) end
    end
    tab.MouseLeave = function() tab:ApplyState() end
    tab.MouseClick = click_fn

    tab:ApplyState()
    return tab
end

Options2.Library.Window = class(Turbine.UI.Control)
function Options2.Library.Window:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.filterText    = ""
    self._openSeg      = nil
    self._selectedItem = nil

    self:SetBackColor(Options.Defaults.window.bg_sunken)

    -- ── header ──────────────────────────────────────────────────────────────
    self.header = Turbine.UI.Control()
    self.header:SetParent(self)
    self.header:SetPosition(0, 0)
    self.header:SetHeight(HEADER_H)
    self.header:SetBackColor(Options.Defaults.window.select)
    self.header:SetMouseVisible(false)

    self.head_label = Turbine.UI.Label()
    self.head_label:SetParent(self.header)
    self.head_label:SetPosition(PAD, 0)
    self.head_label:SetHeight(HEADER_H)
    self.head_label:SetFont(Options2.Fonts.SMALL)
    self.head_label:SetForeColor(Options.Defaults.window.accent)
    self.head_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_label:SetMouseVisible(false)

    -- names the armed field, when there is one
    self.head_fills = Turbine.UI.Label()
    self.head_fills:SetParent(self.header)
    self.head_fills:SetHeight(HEADER_H)
    self.head_fills:SetFont(Options2.Fonts.SMALL)
    self.head_fills:SetForeColor(Options.Defaults.window.accent)
    self.head_fills:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.head_fills:SetMouseVisible(false)

    -- 1px accent edge down the column while a field is armed
    self.armed_edge = Turbine.UI.Control()
    self.armed_edge:SetParent(self)
    self.armed_edge:SetPosition(0, 0)
    self.armed_edge:SetWidth(1)
    self.armed_edge:SetBackColor(Options.Defaults.window.accent)
    self.armed_edge:SetVisible(false)
    self.armed_edge:SetMouseVisible(false)

    -- ── tab strip ───────────────────────────────────────────────────────────
    self.skill_seg  = Options2.Library.SegmentItem("segment", "skills", self, 1)
    self.effect_seg = Options2.Library.SegmentItem("segment", "effects", self, 2)
    self.chat_seg   = Options2.Library.SegmentItem("segment", "chat", self, 3)
    self.skill_seg:SetParent(self)
    self.effect_seg:SetParent(self)
    self.chat_seg:SetParent(self)

    self.tab_skill  = make_tab(self, function() self:ShowSegment(self.skill_seg) end)
    self.tab_effect = make_tab(self, function() self:ShowSegment(self.effect_seg) end)
    self.tab_chat   = make_tab(self, function() self:ShowSegment(self.chat_seg) end)
    self._tabs = {
        { tab = self.tab_skill,  seg = self.skill_seg },
        { tab = self.tab_effect, seg = self.effect_seg },
        { tab = self.tab_chat,   seg = self.chat_seg },
    }

    -- ── filter ──────────────────────────────────────────────────────────────
    self.filter_row = Turbine.UI.Control()
    self.filter_row:SetParent(self)
    self.filter_row:SetHeight(FILTER_H)
    self.filter_row:SetMouseVisible(false)

    self.filter_icon = Turbine.UI.Control()
    self.filter_icon:SetParent(self.filter_row)
    self.filter_icon:SetSize(ICON_SZ, ICON_SZ)
    self.filter_icon:SetTop(math.floor((FILTER_H - ICON_SZ) / 2))
    self.filter_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.filter_icon:SetBackground("Gibberish3/RESOURCES/search.tga")
    self.filter_icon:SetMouseVisible(true)
    self.filter_icon.MouseClick = function() self.filter:Focus() end

    self.filter = Turbine.UI.TextBox()
    self.filter:SetParent(self.filter_row)
    self.filter:SetHeight(FILTER_H - 4)
    self.filter:SetTop(2)
    self.filter:SetFont(Options2.Fonts.BODY)
    self.filter:SetForeColor(Options.Defaults.window.text)
    self.filter:SetBackColor(nil)
    self.filter:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.filter:SetMultiline(false)
    self.filter:SetSelectable(true)
    self.filter.TextChanged = function()
        self.filterText = string.lower(self.filter:GetText())
        self.filter_clear:SetVisible(self.filterText ~= "")
        self.filter_hint:SetVisible(self.filterText == "")
        self:_FilterAll()
    end

    self.filter_hint = Turbine.UI.Label()
    self.filter_hint:SetParent(self.filter_row)
    self.filter_hint:SetHeight(FILTER_H)
    self.filter_hint:SetFont(Options2.Fonts.BODY)
    self.filter_hint:SetForeColor(Options.Defaults.window.text_faint)
    self.filter_hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.filter_hint:SetMouseVisible(false)

    self.filter_clear = Turbine.UI.Button()
    self.filter_clear:SetSize(18, 18)
    self.filter_clear:SetParent(self.filter)
    self.filter_clear:SetText("x")
    self.filter_clear:SetFont(Options2.Fonts.BODY)
    self.filter_clear:SetVisible(false)
    self.filter_clear.Click = function()
        self.filter:SetText("")
        self.filterText = ""
        self.filter_clear:SetVisible(false)
        self.filter_hint:SetVisible(true)
        self:_FilterAll()
    end

    self.filter_sep = Turbine.UI.Control()
    self.filter_sep:SetParent(self)
    self.filter_sep:SetHeight(SEP_H)
    self.filter_sep:SetBackColor(Options.Defaults.window.line)
    self.filter_sep:SetMouseVisible(false)

    -- ── status line: armed hint, or the recording banner ────────────────────
    self.status = Turbine.UI.Control()
    self.status:SetParent(self)
    self.status:SetHeight(STATUS_H)
    self.status:SetMouseVisible(false)

    self.status_dot = Turbine.UI.Control()
    self.status_dot:SetParent(self.status)
    self.status_dot:SetSize(7, 7)
    self.status_dot:SetTop(math.floor((STATUS_H - 7) / 2))
    self.status_dot:SetLeft(PAD)
    self.status_dot:SetBackColor(Options.Defaults.window.on)
    self.status_dot:SetVisible(false)
    self.status_dot:SetMouseVisible(false)

    self.status_label = Turbine.UI.Label()
    self.status_label:SetParent(self.status)
    self.status_label:SetHeight(STATUS_H)
    self.status_label:SetFont(Options2.Fonts.SMALL)
    self.status_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.status_label:SetMouseVisible(false)

    -- Effects and Chat are collected by listening to the game. This starts and
    -- stops that, and sits next to the banner it produces.
    self.status_btn = make_text_btn(self.status, function() self:_ToggleRecording() end)
    Options2.Elements.Tooltip.AddTooltip(self.status_btn, "tooltip", "o2_record", false)
    self.status_btn:SetTop(math.floor((STATUS_H - BTN_H) / 2))
    self.status_btn:SetVisible(false)

    -- ── copied footer ───────────────────────────────────────────────────────
    self.clip_bar = Options2.Library.ClipboardBar()
    self.clip_bar:SetParent(self)

    self:_RefreshTexts()
    self:_FillSkills()
    self:_FillEffects()
    self:_FillChat()
    self:ShowSegment(self.skill_seg)
end

-- ── texts ──────────────────────────────────────────────────────────────────────

function Options2.Library.Window:_RefreshTexts()
    self.head_label:SetText(UTILS.GetText("options2", "library"))
    self.filter_hint:SetText(UTILS.GetText("options2", "find_library"))
    self:_RefreshTabs()
    self:_RefreshStatus()
end

function Options2.Library.Window:_RefreshTabs()
    for _, entry in ipairs(self._tabs) do
        local text = entry.seg:GetTabText()
        local n    = entry.seg:GetCount()
        if n > 0 then text = text .. " " .. n end
        entry.tab.label:SetText(text)
        entry.tab.active = (entry.seg == self._openSeg)
        entry.tab:ApplyState()
    end
end

function Options2.Library.Window:LanguageChanged()
    self.skill_seg:LanguageChanged()
    self.effect_seg:LanguageChanged()
    self.chat_seg:LanguageChanged()
    self.clip_bar:LanguageChanged()
    self:_RefreshTexts()
end

-- ── collection filling ─────────────────────────────────────────────────────────

function Options2.Library.Window:_FillSkills()
    -- shared with simple mode's paste popover, so the two lists cannot drift
    self.skill_seg:SetList(Options2.Simple.SkillList(), self.filterText)
    self:_RefreshTabs()
end

function Options2.Library.Window:_FillEffects()
    self.effect_seg:SetList(Options.Collection.Effects, self.filterText)
    self:_RefreshTabs()
end

function Options2.Library.Window:_FillChat()
    self.chat_seg:SetList(Options.Collection.Chat, self.filterText)
    self:_RefreshTabs()
end

function Options2.Library.Window:_FilterAll()
    self.skill_seg:Filter(self.filterText)
    self.effect_seg:Filter(self.filterText)
    self.chat_seg:Filter(self.filterText)
end

-- ── tabs ───────────────────────────────────────────────────────────────────────

function Options2.Library.Window:ShowSegment(seg)
    self._openSeg = seg
    for _, entry in ipairs(self._tabs) do
        entry.seg:SetVisible(entry.seg == seg)
    end
    self:_RefreshTabs()
    self:_RefreshStatus()
    self:_ApplyLayout()
end

-- kept for the editor: selecting a trigger jumps to the tab that feeds it
function Options2.Library.Window:SetContext(triggerType)
    local target
    if EFFECT_TYPES[triggerType] then
        target = self.effect_seg
    elseif triggerType == Trigger.Types.Skill then
        target = self.skill_seg
    elseif triggerType == Trigger.Types.Chat then
        target = self.chat_seg
    end
    if target ~= nil and target ~= self._openSeg then
        self:ShowSegment(target)
    end
end

function Options2.Library.Window:_SegmentForType(typeIdx)
    for _, entry in ipairs(self._tabs) do
        if entry.seg.typeIdx == typeIdx then return entry.seg end
    end
end

-- ── armed field ────────────────────────────────────────────────────────────────

function Options2.Library.Window:ArmedFieldChanged()
    local armed = Options2.armedField

    -- jump to a tab that can actually supply the armed field
    if armed ~= nil and armed.types ~= nil then
        local ok = false
        for _, t in ipairs(armed.types) do
            if self._openSeg ~= nil and self._openSeg.typeIdx == t then ok = true break end
        end
        if not ok then
            local seg = self:_SegmentForType(armed.types[1])
            if seg ~= nil then self:ShowSegment(seg) end
        end
    end

    self:_RefreshStatus()
    self:_ApplyLayout()
end

function Options2.Library.Window:_RefreshStatus()
    local armed     = Options2.armedField
    local recording = Options.CollectEffects or Options.CollectChat
    -- nil on Skills, which is not collected
    local collectable = (self:_RecordingForOpenTab() ~= nil)

    if recording then
        self.status:SetBackColor(REC_BG)
        self.status_dot:SetVisible(true)
        self.status_label:SetForeColor(REC_TEXT)
        self.status_label:SetText(UTILS.GetText("options2",
            Options.CollectEffects and "recording_effects" or "recording_chat"))
        self.status_btn:SetLabel(UTILS.GetText("options2", "stop"))
        self.status_btn:SetTone(REC_BG, REC_TEXT)
        self.status_btn:SetVisible(true)
    else
        self.status:SetBackColor(Options.Defaults.window.row_even)
        self.status_dot:SetVisible(false)
        self.status_label:SetForeColor(Options.Defaults.window.text_faint)
        -- the header already names an armed field, so do not contradict it here
        self.status_label:SetText(armed ~= nil and ""
            or UTILS.GetText("options2", "no_field_armed"))
        self.status_btn:SetLabel(UTILS.GetText("options2", "record"))
        self.status_btn:SetTone(Options.Defaults.window.bg_sunken,
                                Options.Defaults.window.text_muted)
        self.status_btn:SetVisible(collectable)
    end

    if armed ~= nil then
        self.head_fills:SetText(
            string.format(UTILS.GetText("options2", "fills_field"), armed.label or ""))
        self.head_fills:SetVisible(true)
        self.armed_edge:SetVisible(true)
    else
        self.head_fills:SetVisible(false)
        self.armed_edge:SetVisible(false)
    end
end

function Options2.Library.Window:_StopRecording()
    Options.CollectEffects = false
    Options.CollectChat    = false
    self:_RefreshStatus()
    self:_ApplyLayout()
end

-- starts or stops collection for whichever of Effects / Chat is on show
function Options2.Library.Window:_ToggleRecording()
    if self._openSeg == self.effect_seg then
        Options.CollectEffects = not Options.CollectEffects
        if Options.CollectEffects then
            -- seed with what is already on the player
            local effects = LocalPlayer:GetEffects()
            for i = 1, effects:GetCount() do
                Trigger.AddToEffectCollection(effects:Get(i), "Self")
            end
            self:_FillEffects()
        end
    elseif self._openSeg == self.chat_seg then
        Options.CollectChat = not Options.CollectChat
    else
        return
    end
    self:_RefreshStatus()
    self:_ApplyLayout()
end

-- which collection the visible tab records into, if any
function Options2.Library.Window:_RecordingForOpenTab()
    if self._openSeg == self.effect_seg then return Options.CollectEffects end
    if self._openSeg == self.chat_seg   then return Options.CollectChat end
    return nil
end

-- ── item actions ───────────────────────────────────────────────────────────────

-- clicking a row always copies it; if a field is armed and this row can supply
-- it, it fills that too
function Options2.Library.Window:SelectItem(item)
    local prev = self._selectedItem
    self._selectedItem = item
    if prev ~= nil then prev:_Refresh() end
    item:_Refresh()

    Options2.SetClipboard(item.data, item.typeIdx)
    Options2.FillArmedField(item.data, item.typeIdx)
end

-- the Use button on the selected row
function Options2.Library.Window:UseItem(item)
    if not Options2.FillArmedField(item.data, item.typeIdx) then
        Options2.SetClipboard(item.data, item.typeIdx)
    end
end

function Options2.Library.Window:ClipboardChanged()
    self.clip_bar:ClipboardChanged()
    self.clip_bar:SetWidth(self:GetWidth())
    if Options2.clipboard.item == nil and self._selectedItem ~= nil then
        local prev = self._selectedItem
        self._selectedItem = nil
        prev:_Refresh()
    end
    self:_ApplyLayout()
end

-- ── layout ─────────────────────────────────────────────────────────────────────

function Options2.Library.Window:SizeChanged()
    if self.header == nil then return end
    self:_ApplyLayout()
end

function Options2.Library.Window:_ApplyLayout()
    local w, h = self:GetSize()
    if w <= 0 or h <= 0 then return end

    self.header:SetWidth(w)
    self.armed_edge:SetHeight(h)

    local fills_w = math.floor(w * 0.55)
    self.head_label:SetWidth(math.max(0, w - 2 * PAD - fills_w))
    self.head_fills:SetPosition(w - PAD - fills_w, 0)
    self.head_fills:SetWidth(fills_w)

    local y = HEADER_H

    local tab_w = math.floor(w / 3)
    for i, entry in ipairs(self._tabs) do
        local this_w = (i == 3) and (w - tab_w * 2) or tab_w
        entry.tab:Layout(this_w)
        entry.tab:SetPosition(tab_w * (i - 1), y)
    end
    y = y + TAB_H

    self.filter_row:SetPosition(0, y)
    self.filter_row:SetWidth(w)
    local filter_left = PAD + ICON_SZ + GAP
    local filter_w    = math.max(0, w - filter_left - PAD)
    self.filter_icon:SetLeft(PAD)
    self.filter:SetPosition(filter_left, 2)
    self.filter:SetWidth(filter_w)
    self.filter_hint:SetPosition(filter_left + 2, 0)
    self.filter_hint:SetWidth(filter_w)
    self.filter_clear:SetPosition(math.max(0, filter_w - 20),
        math.floor((FILTER_H - 4 - 18) / 2))
    y = y + FILTER_H

    self.filter_sep:SetPosition(0, y)
    self.filter_sep:SetWidth(w)
    y = y + SEP_H

    self.status:SetPosition(0, y)
    self.status:SetWidth(w)
    local status_left = self.status_dot:IsVisible() and (PAD + 7 + GAP) or PAD
    local btn_w = self.status_btn:IsVisible() and (self.status_btn:GetWidth() + GAP) or 0
    self.status_btn:SetLeft(math.max(0, w - PAD - self.status_btn:GetWidth()))
    self.status_label:SetPosition(status_left, 0)
    self.status_label:SetWidth(math.max(0, w - status_left - PAD - btn_w))
    y = y + STATUS_H

    -- the footer only takes space when something is on the clipboard
    local clip_h = self.clip_bar:IsVisible() and self.clip_bar:GetHeight() or 0
    local list_h = math.max(0, h - y - clip_h)

    for _, entry in ipairs(self._tabs) do
        entry.seg:SetPosition(0, y)
        entry.seg:SetSize(w, list_h)
    end

    if clip_h > 0 then
        self.clip_bar:SetPosition(0, h - clip_h)
        self.clip_bar:SetWidth(w)
    end
end
