-- Structure column row: window.
-- window icon · name · type tag · [bolt] · enable box
-- Windows hold no children in this column, so they carry no chevron.

local P = nil   -- resolved lazily; RowParts is imported before this file

local FONT_NAME  = Turbine.UI.Lotro.Font.Verdana12
local FONT_SMALL = Turbine.UI.Lotro.Font.Verdana10

local TAG_W       = 52

-- "Bar" / "Counter" etc. from the tables in UI_ELEMENTS/__init__.lua, uppercased
-- for the tag. string.upper is byte-wise, which is fine for these ASCII names.
local function type_tag(wd)
    local lang = L[Language.Local] or L[Language.English]
    local name
    if wd.type == Window.Types.COUNTER_WINDOW then
        name = lang.windowType and lang.windowType[wd.type]
    else
        name = lang.type and wd.timerType and lang.type[wd.timerType]
    end
    if name == nil or name == "" then return "" end
    return string.upper(name)
end

Options2NavWindow = class(Turbine.UI.Control)
function Options2NavWindow:Constructor(navWin, winIdx, winData, key, expanded, depth)
    Turbine.UI.Control.Constructor(self)
    P = Options2.Elements.RowParts

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 0
    self.nodeData = {
        nodeType    = "window",
        key         = key,
        data        = winData,
        windowIndex = winIdx,
    }

    self:SetHeight(P.ROW_H)

    self.rail = P.MakeRail(self, Options.Defaults.window.color_window)
    self.icon = P.MakeIcon(self, P.ICON.window, P.ROW_H, P.NODE_ICON)

    self.label = P.MakeLabel(self, FONT_NAME, Options.Defaults.window.color_window,
        Turbine.UI.ContentAlignment.MiddleLeft)

    self.tag = P.MakeLabel(self, FONT_SMALL, Options.Defaults.window.text_faint,
        Turbine.UI.ContentAlignment.MiddleRight)

    self.bolt = P.MakeIcon(self, P.ICON.trigger, P.ROW_H)
    self.bolt:SetVisible(false)

    self.box = P.MakeEnableBox(self, function()
        winData.enabled = not winData.enabled
        self.box:SetOn(winData.enabled == true)
        Options.SaveData()
        Options.DataChanged(winIdx)
        Windows.EnabledChanged(winIdx)
        navWin:RefreshEnabledStates()
    end)

    P.WireRow(self, navWin)
    self:_Sync()
end

function Options2NavWindow:_Sync()
    local wd = self.nodeData.data

    self._name = (wd.name ~= nil and wd.name ~= "") and wd.name
        or UTILS.GetText("options2", "unnamed_window")
    self.tag:SetText(type_tag(wd))
    self.bolt:SetVisible(Options2.Elements.RowParts.HasTriggers(wd, self.navWin.trig_types))
    self.box:SetOn(wd.enabled == true)
    self.label:SetForeColor(wd.enabled == true
        and Options.Defaults.window.color_window
        or  Options.Defaults.window.text_muted)

    P.LayoutGuides(self, self.depth)
    self:_Layout()
end

function Options2NavWindow:_Layout()
    local w = self:GetWidth()
    if w <= 0 then return end

    local left = P.ContentLeft(self.depth)
    self.icon:SetSlotLeft(left)
    local text_left = left + P.NODE_ICON + P.GAP

    -- right to left: enable box, trigger bolt, type tag
    local x = w - P.PAD - P.BOX
    self.box:SetLeft(x)

    if self.bolt:IsVisible() then
        x = x - P.GAP - P.ICON_SIZE
        self.bolt:SetLeft(x)
    end

    x = x - P.GAP - TAG_W
    self.tag:SetPosition(x, 0)
    self.tag:SetWidth(TAG_W)

    local text_w = math.max(0, x - P.GAP - text_left)
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(text_w)
    self.label:SetText(P.Truncate(self._name, P.CharBudget(text_w)))
end

function Options2NavWindow:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2NavWindow:SetSelected(v)
    Options2.Elements.RowParts.ApplySelected(self, v)
end

function Options2NavWindow:GetKey()       return self.key end

-- windows own no rows in the structure column
function Options2NavWindow:IsExpandable() return false end
function Options2NavWindow:SetExpanded(v) end

function Options2NavWindow:RefreshEnabled()
    self.box:SetOn(self.nodeData.data.enabled == true)
    self.label:SetForeColor(self.nodeData.data.enabled == true
        and Options.Defaults.window.color_window
        or  Options.Defaults.window.text_muted)
end

function Options2NavWindow:Refresh(expanded, depth)
    self.depth = depth or 0
    Options2.Elements.RowParts.ApplySelected(self, false)
    self:_Sync()
end
