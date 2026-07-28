Options2.Elements.CheckBoxRow = class(Turbine.UI.Control)
function Options2.Elements.CheckBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)
    local M = Options2.Elements.EditorRow

    self.label_control     = label_control
    self.label_description = label_description

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    self.checkbox = Options2.Elements.CheckBox()
    self.checkbox:SetParent(self)
    self.checkbox:SetPosition(M.CTRL_LEFT, M.CentreTop(height, M.CHECK))

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.CheckBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.CheckBoxRow:SizeChanged()
    if self.checkbox == nil then return end
    local M = Options2.Elements.EditorRow
    local h = self:GetHeight()
    self.label:SetHeight(h)
    self.checkbox:SetTop(M.CentreTop(h, M.CHECK))
end

function Options2.Elements.CheckBoxRow:SetChecked(value)
    self.checkbox:SetChecked(value)
end

function Options2.Elements.CheckBoxRow:IsChecked()
    return self.checkbox:IsChecked()
end

function Options2.Elements.CheckBoxRow:SetCallback(func)
    self.checkbox.CheckedChanged = func
end
