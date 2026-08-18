-- Simple mode, column B: one timer in the selected window.
--
-- Flatter than the contents column's timer row: simple mode never shows a
-- timer's triggers or conditions, so there is no block to head and no rail
-- running down to children — just the row's own 2px marker rail.

local H      = 28
local PAD    = 10
local GAP    = 8
local MARK   = 16
local BOX    = 9
local META_W = 46

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    H      = F.Px(28)
    META_W = F.Px(46)
end)

Options2SimpleTimer = class(Turbine.UI.Control)
function Options2SimpleTimer:Constructor(simpleWin, winIdx, timerIdx, timerData, key)
    Turbine.UI.Control.Constructor(self)
    local P = Options2.Elements.RowParts

    self.simpleWin = simpleWin
    self.key       = key
    self.selected  = false

    -- the same nodeData shape both list columns produce, so the editor can read
    -- a simple-mode selection with no special case
    self.nodeData = {
        nodeType    = "timer",
        key         = key,
        data        = timerData,
        windowIndex = winIdx,
        timerIndex  = timerIdx,
    }

    self:SetHeight(H)
    self:SetMouseVisible(true)

    self.rail = P.MakeRailAt(self, 0, Options.Defaults.window.color_timer, H)
    self.rail:SetWidth(P.RAIL_IDLE_W)

    self.marker = P.MakeIcon(self, P.ICON.timer, H, MARK)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetHeight(H)
    self.label:SetFont(Options2.Fonts.BODY)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetMouseVisible(false)

    self.meta = Turbine.UI.Label()
    self.meta:SetParent(self)
    self.meta:SetHeight(H)
    self.meta:SetFont(Options2.Fonts.SMALL)
    self.meta:SetForeColor(Options.Defaults.window.text_faint)
    self.meta:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.meta:SetMouseVisible(false)

    self.box = P.MakeEnableBox(self, function()
        timerData.enabled = not timerData.enabled
        self:_Sync()
        Options.SaveData()
        Options.DataChanged(winIdx)
        Windows.EnabledChanged(winIdx)
    end, BOX, H)

    -- takes the enable box's place on a timer the simple editor will not touch
    self.adv = Options2.Simple.MakeAdvTag(self, H)
    self.adv:SetVisible(false)

    self.divider = Turbine.UI.Control()
    self.divider:SetParent(self)
    self.divider:SetHeight(1)
    self.divider:SetBackColor(Options.Defaults.window.row_even)
    self.divider:SetMouseVisible(false)

    self.MouseEnter = function()
        if not self.selected then self:SetBackColor(Options.Defaults.window.row_odd) end
    end
    self.MouseLeave = function()
        if not self.selected then self:SetBackColor(nil) end
    end
    self.MouseClick = function()
        self.simpleWin:RowClicked(self)
    end

    self:_Sync()
end

function Options2SimpleTimer:_Sync()
    local td = self.nodeData.data

    -- derived every time the row is drawn, never stored: see SIMPLE/Kinds.lua
    self.info = Options2.Simple.Inspect(td)
    self.box:SetVisible(self.info.simple)
    self.adv:SetVisible(not self.info.simple)

    self._label_text = (td.description ~= nil and td.description ~= "")
        and td.description or UTILS.GetText("options2", "unnamed_timer")

    local enabled = td.enabled == true
    if not enabled then
        self._meta_text = UTILS.GetText("options2", "meta_disabled")
    elseif td.useCustomTimer == true and td.timerValue ~= nil then
        self._meta_text = string.format(UTILS.GetText("options2", "meta_seconds"), td.timerValue)
    else
        self._meta_text = ""
    end

    self.box:SetOn(enabled)
    self:_ApplyNameColor()
    self:_Layout()
end

-- the selected row's name brightens; a disabled timer stays muted either way
function Options2SimpleTimer:_ApplyNameColor()
    local enabled = self.nodeData.data.enabled == true
    if not enabled then
        self.label:SetForeColor(Options.Defaults.window.text_muted)
    elseif self.selected then
        self.label:SetForeColor(Options.Defaults.window.text)
    else
        self.label:SetForeColor(Options.Defaults.window.text_muted)
    end
end

function Options2SimpleTimer:_Layout()
    local P = Options2.Elements.RowParts
    local w = self:GetWidth()
    if w <= 0 then return end

    self.marker:SetSlotLeft(PAD)
    local text_left = PAD + MARK + GAP

    -- the ADV tag stands where the enable box would be, and is wider
    local x
    if self.adv:IsVisible() then
        x = w - PAD - self.adv:GetWidth()
        self.adv:SetLeft(x)
    else
        x = w - PAD - BOX
        self.box:SetLeft(x)
    end

    x = x - GAP - META_W
    self.meta:SetPosition(x, 0)
    self.meta:SetWidth(META_W)
    self.meta:SetText(self._meta_text)

    local text_w = math.max(0, x - GAP - text_left)
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(text_w)
    self.label:SetText(P.Truncate(self._label_text, P.CharBudget(text_w)))

    self.divider:SetPosition(0, H - 1)
    self.divider:SetWidth(w)
end

function Options2SimpleTimer:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2SimpleTimer:GetKey() return self.key end

function Options2SimpleTimer:SetSelected(v)
    local P = Options2.Elements.RowParts
    self.selected = v
    self.rail:SetWidth(v and P.RAIL_W or P.RAIL_IDLE_W)
    self:SetBackColor(v and Options.Defaults.window.select or nil)
    self:_ApplyNameColor()
end
