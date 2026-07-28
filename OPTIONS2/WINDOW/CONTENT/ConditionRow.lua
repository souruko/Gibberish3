-- Contents column: a condition belonging to a timer.
-- Carries the timer's green rail; its own triggers add a purple one inside it.

Options2ContentCondition = class(Turbine.UI.Control)
function Options2ContentCondition:Constructor(contentWin, winIdx, timerIdx, condIdx, condData, key)
    Turbine.UI.Control.Constructor(self)
    local P = Options2.Elements.RowParts

    self.contentWin = contentWin
    self.key        = key
    self.selected   = false

    self.nodeData = {
        nodeType       = "condition",
        key            = key,
        data           = condData,
        windowIndex    = winIdx,
        timerIndex     = timerIdx,
        conditionIndex = condIdx,
    }

    self:SetHeight(P.CHILD_H)

    self.timer_rail = P.MakeRailAt(self, P.CHILD_RAIL_X,
        Options.Defaults.window.color_timer, P.CHILD_H)

    self.sel_rail = P.MakeRailAt(self, 0,
        Options.Defaults.window.color_cond, P.CHILD_H)
    self.sel_rail:SetWidth(P.RAIL_W)
    self.sel_rail:SetVisible(false)

    self.mark = P.MakeIcon(self, P.ICON.condition, P.CHILD_H)
    self.mark:SetLeft(P.CHILD_TEXT_X)

    self.label = P.MakeChildLabel(self, Turbine.UI.Lotro.Font.Verdana10,
        Options.Defaults.window.text, Turbine.UI.ContentAlignment.MiddleLeft)

    self.meta = P.MakeChildLabel(self, Turbine.UI.Lotro.Font.Verdana10,
        Options.Defaults.window.text_faint, Turbine.UI.ContentAlignment.MiddleRight)

    self.box = P.MakeEnableBox(self, function()
        condData.enabled = not condData.enabled
        self.box:SetOn(condData.enabled == true)
        self:_Sync()
        Options.SaveData()
        Options.DataChanged(winIdx)
        Windows.EnabledChanged(winIdx)
    end, P.CHILD_DOT, P.CHILD_H)

    P.WireContentRow(self, contentWin)
    self:_Sync()
end

function Options2ContentCondition:_Sync()
    local P  = Options2.Elements.RowParts
    local cd = self.nodeData.data

    self._label_text = (cd.description ~= nil and cd.description ~= "")
        and cd.description or UTILS.GetText("options2", "unnamed_condition")

    local n = 0
    for _, tt in ipairs(Options2.TriggerTypes()) do
        n = n + #(cd[tt] or {})
    end
    self._meta_text = string.format(UTILS.GetText("options2", "meta_triggers"), n)

    self.box:SetOn(cd.enabled == true)
    self.label:SetForeColor(cd.enabled == true
        and Options.Defaults.window.text
        or  Options.Defaults.window.text_muted)

    self:_Layout()
end

function Options2ContentCondition:_Layout()
    local P = Options2.Elements.RowParts
    local w = self:GetWidth()
    if w <= 0 then return end

    local text_left = P.CHILD_TEXT_X + P.ICON_SIZE + P.CHILD_GAP

    local x = w - P.CHILD_PAD - P.CHILD_DOT
    self.box:SetLeft(x)

    local meta_w = math.max(0, math.min(70, x - P.CHILD_GAP - text_left))
    x = x - P.CHILD_GAP - meta_w
    self.meta:SetPosition(x, 0)
    self.meta:SetWidth(meta_w)
    self.meta:SetText(self._meta_text)

    local text_w = math.max(0, x - P.CHILD_GAP - text_left)
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(text_w)
    self.label:SetText(P.Truncate(self._label_text, P.CharBudget(text_w)))
end

function Options2ContentCondition:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2ContentCondition:GetKey()       return self.key end
function Options2ContentCondition:IsSelectable() return true end

function Options2ContentCondition:SetSelected(v)
    Options2.Elements.RowParts.ApplyChildSelected(self, v, self.sel_rail)
end

function Options2ContentCondition:Refresh()
    self:SetSelected(false)
    self:_Sync()
end
