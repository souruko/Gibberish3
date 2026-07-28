-- Contents column: a trigger belonging to a condition.
-- Two rails: the timer's green one, unbroken through the whole block, and the
-- condition's purple one nested inside it.

Options2ContentCondTrigger = class(Turbine.UI.Control)
function Options2ContentCondTrigger:Constructor(contentWin, winIdx, timerIdx, condIdx, trigData, trigType, trigIdx, key)
    Turbine.UI.Control.Constructor(self)
    local P = Options2.Elements.RowParts

    self.contentWin = contentWin
    self.key        = key
    self.selected   = false

    self.nodeData = {
        nodeType       = "conditiontrigger",
        key            = key,
        data           = trigData,
        windowIndex    = winIdx,
        timerIndex     = timerIdx,
        conditionIndex = condIdx,
        triggerType    = trigType,
        triggerIndex   = trigIdx,
    }

    self:SetHeight(P.CHILD_H)

    self.timer_rail = P.MakeRailAt(self, P.CHILD_RAIL_X,
        Options.Defaults.window.color_timer, P.CHILD_H)
    self.cond_rail = P.MakeRailAt(self, P.COND_RAIL_X,
        Options.Defaults.window.color_cond, P.CHILD_H)

    self.sel_rail = P.MakeRailAt(self, 0,
        Options.Defaults.window.color_trigger, P.CHILD_H)
    self.sel_rail:SetWidth(P.RAIL_W)
    self.sel_rail:SetVisible(false)

    self.mark = P.MakeChildMark(self, Options.Defaults.window.color_trigger)
    self.mark:SetLeft(P.COND_TEXT_X)

    self.label = P.MakeChildLabel(self, Turbine.UI.Lotro.Font.Verdana10,
        Options.Defaults.window.text, Turbine.UI.ContentAlignment.MiddleLeft)

    self.token = P.MakeChildLabel(self, Turbine.UI.Lotro.Font.Verdana10,
        Options.Defaults.window.text_faint, Turbine.UI.ContentAlignment.MiddleRight)

    self.box = P.MakeEnableBox(self, function()
        trigData.enabled = not trigData.enabled
        self.box:SetOn(trigData.enabled == true)
        Options.SaveData()
        Options.DataChanged(winIdx)
        Windows.EnabledChanged(winIdx)
    end, P.CHILD_DOT, P.CHILD_H)

    P.WireContentRow(self, contentWin)
    self:_Sync()
end

function Options2ContentCondTrigger:_Sync()
    local P  = Options2.Elements.RowParts
    local nd = self.nodeData

    self._label_text = P.TriggerLabel(nd.data, nd.triggerType)

    local token, missing = P.TriggerToken(nd.data, nd.triggerType)
    self._token_text = token
    self.token:SetForeColor(missing and Options.Defaults.window.color_trigger
                                    or  Options.Defaults.window.text_faint)

    self.box:SetOn(nd.data.enabled == true)
    self.label:SetForeColor(nd.data.enabled == true
        and Options.Defaults.window.text
        or  Options.Defaults.window.text_muted)

    self:_Layout()
end

function Options2ContentCondTrigger:_Layout()
    local P = Options2.Elements.RowParts
    local w = self:GetWidth()
    if w <= 0 then return end

    local text_left = P.COND_TEXT_X + P.CHILD_MARK + P.CHILD_GAP

    local x = w - P.CHILD_PAD - P.CHILD_DOT
    self.box:SetLeft(x)

    local token_w = math.max(0, math.min(110, x - P.CHILD_GAP - text_left))
    x = x - P.CHILD_GAP - token_w
    self.token:SetPosition(x, 0)
    self.token:SetWidth(token_w)
    self.token:SetText(P.Truncate(self._token_text, P.CharBudget(token_w)))

    local text_w = math.max(0, x - P.CHILD_GAP - text_left)
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(text_w)
    self.label:SetText(P.Truncate(self._label_text, P.CharBudget(text_w)))
end

function Options2ContentCondTrigger:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2ContentCondTrigger:GetKey()       return self.key end
function Options2ContentCondTrigger:IsSelectable() return true end

function Options2ContentCondTrigger:SetSelected(v)
    Options2.Elements.RowParts.ApplyChildSelected(self, v, self.sel_rail)
end

function Options2ContentCondTrigger:Refresh()
    self:SetSelected(false)
    self:_Sync()
end
