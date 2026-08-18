-- Contents column: a folder's or window's own trigger. No rail — these hang off
-- the container itself, not off a timer.

local H       = 28
local PAD     = 10
local GAP     = 8
local BOLT    = 4
local BOX     = 9
local TOKEN_W = 130

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    H       = F.Px(28)
    TOKEN_W = F.Px(130)
end)

-- nodeType is "foldertrigger" or "windowtrigger"; the owner index goes into
-- folderIndex or windowIndex to match what the editor expects
Options2ContentOwnTrigger = class(Turbine.UI.Control)
function Options2ContentOwnTrigger:Constructor(contentWin, nodeType, ownerIdx, trigData, trigType, trigIdx, key)
    Turbine.UI.Control.Constructor(self)
    local P = Options2.Elements.RowParts

    self.contentWin = contentWin
    self.key        = key
    self.selected   = false

    self.nodeData = {
        nodeType     = nodeType,
        key          = key,
        data         = trigData,
        triggerType  = trigType,
        triggerIndex = trigIdx,
    }
    if nodeType == "foldertrigger" then
        self.nodeData.folderIndex = ownerIdx
    else
        self.nodeData.windowIndex = ownerIdx
    end

    self:SetHeight(H)

    self.rail = P.MakeRailAt(self, 0, Options.Defaults.window.color_trigger, H)
    self.rail:SetWidth(P.RAIL_IDLE_W)

    self.bolt = P.MakeIcon(self, P.ICON.trigger, H)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetHeight(H)
    self.label:SetFont(Options2.Fonts.BODY)
    self.label:SetForeColor(Options.Defaults.window.text)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetMouseVisible(false)

    self.token = Turbine.UI.Label()
    self.token:SetParent(self)
    self.token:SetHeight(H)
    self.token:SetFont(Options2.Fonts.SMALL)
    self.token:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.token:SetMouseVisible(false)

    self.box = P.MakeEnableBox(self, function()
        trigData.enabled = not trigData.enabled
        self.box:SetOn(trigData.enabled == true)
        Options.SaveData()
        if self.nodeData.windowIndex ~= nil then
            Options.DataChanged(self.nodeData.windowIndex)
            Windows.EnabledChanged(self.nodeData.windowIndex)
        end
    end, BOX, H)

    Options2.Elements.RowParts.WireContentRow(self, contentWin)
    self:_Sync()
end

function Options2ContentOwnTrigger:_Sync()
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

function Options2ContentOwnTrigger:_Layout()
    local P = Options2.Elements.RowParts
    local w = self:GetWidth()
    if w <= 0 then return end

    self.bolt:SetLeft(PAD)
    local text_left = PAD + Options2.Elements.RowParts.ICON_SIZE + GAP

    local x = w - PAD - BOX
    self.box:SetLeft(x)

    local token_w = math.min(TOKEN_W, math.max(0, x - GAP - text_left))
    x = x - GAP - token_w
    self.token:SetPosition(x, 0)
    self.token:SetWidth(token_w)
    self.token:SetText(P.Truncate(self._token_text, P.CharBudget(token_w)))

    local text_w = math.max(0, x - GAP - text_left)
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(text_w)
    self.label:SetText(P.Truncate(self._label_text, P.CharBudget(text_w)))
end

function Options2ContentOwnTrigger:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2ContentOwnTrigger:GetKey()       return self.key end
function Options2ContentOwnTrigger:IsSelectable() return true end

function Options2ContentOwnTrigger:SetSelected(v)
    self.selected = v
    self.rail:SetWidth(v and Options2.Elements.RowParts.RAIL_W or Options2.Elements.RowParts.RAIL_IDLE_W)
    self:SetBackColor(v and Options.Defaults.window.select or nil)
end

function Options2ContentOwnTrigger:Refresh()
    self:SetSelected(false)
    self:_Sync()
end
