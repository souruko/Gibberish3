local ROW_H  = Options2.Elements.EditorRow.ROW_H
local DESC_H = 40
local LEFT   = 10
local TOP    = 10

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    -- ROW_H is the shared editor row height, so every editor stays in step
    ROW_H  = Options2.Elements.EditorRow.ROW_H
    DESC_H = F.Px(40)
end)

local BC_ODD  = Options.Defaults.window.row_odd
local BC_EVEN = Options.Defaults.window.row_even

Options2.Window.ConditionEditor = class(Turbine.UI.Control)
function Options2.Window.ConditionEditor:Constructor(nodeData)
    Turbine.UI.Control.Constructor(self)

    self.nodeData = nodeData
    local data    = nodeData.data
    local bc      = Options.Defaults.window.row_odd
    local y       = TOP
    local count   = 0
    self.rows     = {}

    local function add(widget, h)
        count = count + 1
        widget:SetBackColor(count % 2 == 1 and BC_ODD or BC_EVEN)
        widget:SetParent(self)
        widget:SetPosition(LEFT, y)
        self.rows[#self.rows + 1] = widget
        y = y + (h or ROW_H) + 2
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
    for _, r in ipairs(self.rows) do r:SetWidth(w - LEFT - LEFT) end
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
