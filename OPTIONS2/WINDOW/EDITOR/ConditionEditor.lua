local ROW_H  = 30
local DESC_H = 50
local LEFT   = 5
local TOP    = 8

local BC_ODD  = Turbine.UI.Color(0.16, 0.13, 0.10)
local BC_EVEN = Turbine.UI.Color(0.12, 0.10, 0.08)

Options2.Window.ConditionEditor = class(Turbine.UI.Control)
function Options2.Window.ConditionEditor:Constructor(nodeData)
    Turbine.UI.Control.Constructor(self)

    self.nodeData = nodeData
    local data    = nodeData.data
    local bc      = Options.Defaults.window.basecolor
    local y       = TOP
    local count   = 0
    self.rows     = {}

    local function add(widget, h)
        count = count + 1
        widget:SetBackColor(count % 2 == 1 and BC_ODD or BC_EVEN)
        widget:SetParent(self)
        widget:SetPosition(LEFT, y)
        self.rows[#self.rows + 1] = widget
        y = y + (h or ROW_H) + 5
    end

    self.desc = Options2.Elements.TextBoxRow(bc, "options", "description", "trg_description", DESC_H, true)
    add(self.desc, DESC_H)
    self.enabled = Options2.Elements.CheckBoxRow(bc, "options", "enabled", "cond_enabled", ROW_H)
    add(self.enabled)
    self.permanent = Options2.Elements.CheckBoxRow(bc, "options", "permanent", "cond_permanent", ROW_H)
    add(self.permanent)
    self.useCustomDuration = Options2.Elements.CheckBoxRow(bc, "options", "useCustomDuration", "cond_use_custom_duration", ROW_H)
    add(self.useCustomDuration)
    self.duration = Options2.Elements.NumberBoxRow(bc, "options", "duration", "cond_duration", ROW_H)
    add(self.duration)

    self:_Load()
end

function Options2.Window.ConditionEditor:_Load()
    local data = self.nodeData.data
    self.desc:SetText(data.description or "")
    self.enabled:SetChecked(data.enabled == true)
    self.permanent:SetChecked(data.permanent == true)
    self.useCustomDuration:SetChecked(data.useCustomDuration == true)
    self.duration:SetText(tostring(data.duration or 10))
end

function Options2.Window.ConditionEditor:SizeChanged()
    if self.rows == nil then return end
    local w = self:GetWidth()
    for _, r in ipairs(self.rows) do r:SetWidth(w - LEFT - 5) end
end

function Options2.Window.ConditionEditor:Save()
    local data = self.nodeData.data
    data.description       = self.desc:GetText()
    data.enabled           = self.enabled:IsChecked()
    data.permanent         = self.permanent:IsChecked()
    data.useCustomDuration = self.useCustomDuration:IsChecked()
    data.duration          = self.duration:GetText() or 10
    Options.SaveData()
    local wi = self.nodeData.windowIndex
    if wi ~= nil then
        Options.DataChanged(wi)
        Windows.EnabledChanged(wi)
    end
end

function Options2.Window.ConditionEditor:Reset()
    self:_Load()
end

function Options2.Window.ConditionEditor:LanguageChanged()
    if self.rows == nil then return end
    for _, r in ipairs(self.rows) do r:LanguageChanged() end
end
