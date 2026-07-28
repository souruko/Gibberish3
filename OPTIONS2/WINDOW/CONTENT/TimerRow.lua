-- Contents column: a timer inside the selected window. Heads a block whose
-- child rows (triggers, conditions, condition triggers) are tied together by a
-- continuous green rail.

local H    = 28
local PAD  = 10
local GAP  = 8
local MARK = 11
local BOX  = 9
local META_W = 60

Options2ContentTimer = class(Turbine.UI.Control)
function Options2ContentTimer:Constructor(contentWin, winIdx, timerIdx, timerData, key)
    Turbine.UI.Control.Constructor(self)
    local P = Options2.Elements.RowParts

    self.contentWin = contentWin
    self.key        = key
    self.selected   = false

    self.nodeData = {
        nodeType    = "timer",
        key         = key,
        data        = timerData,
        windowIndex = winIdx,
        timerIndex  = timerIdx,
    }

    self:SetHeight(H)

    self.rail = P.MakeRailAt(self, 0, Options.Defaults.window.color_timer, H)
    self.rail:SetWidth(P.RAIL_IDLE_W)

    -- the timer's own marker, in the timer colour: the window owns the display
    -- type, so there is nothing per-timer to distinguish here
    self.marker = P.MakeIcon(self, P.ICON.timer, H, MARK)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetHeight(H)
    self.label:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetMouseVisible(false)

    self.meta = Turbine.UI.Label()
    self.meta:SetParent(self)
    self.meta:SetHeight(H)
    self.meta:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    self.meta:SetForeColor(Options.Defaults.window.text_faint)
    self.meta:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.meta:SetMouseVisible(false)

    self.box = P.MakeEnableBox(self, function()
        timerData.enabled = not timerData.enabled
        self.box:SetOn(timerData.enabled == true)
        self:_Sync()
        Options.SaveData()
        Options.DataChanged(winIdx)
        Windows.EnabledChanged(winIdx)
    end, BOX, H)

    -- 1px divider closing the timer block
    self.divider = Turbine.UI.Control()
    self.divider:SetParent(self)
    self.divider:SetHeight(1)
    self.divider:SetBackColor(Options.Defaults.window.row_even)
    self.divider:SetMouseVisible(false)

    P.WireContentRow(self, contentWin)
    self:_Sync()
end

function Options2ContentTimer:_Sync()
    local P  = Options2.Elements.RowParts
    local td = self.nodeData.data

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
    self.label:SetForeColor(enabled and Options.Defaults.window.text
                                    or  Options.Defaults.window.text_muted)
    self:_Layout()
end

function Options2ContentTimer:_Layout()
    local P = Options2.Elements.RowParts
    local w = self:GetWidth()
    if w <= 0 then return end

    self.marker:SetSlotLeft(PAD)
    local text_left = PAD + MARK + GAP

    local x = w - PAD - BOX
    self.box:SetLeft(x)

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

function Options2ContentTimer:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2ContentTimer:GetKey()       return self.key end
function Options2ContentTimer:IsSelectable() return true end

function Options2ContentTimer:SetSelected(v)
    self.selected = v
    self.rail:SetWidth(v and Options2.Elements.RowParts.RAIL_W or Options2.Elements.RowParts.RAIL_IDLE_W)
    self:SetBackColor(v and Options.Defaults.window.select or nil)
end

function Options2ContentTimer:Refresh()
    self:SetSelected(false)
    self:_Sync()
end
