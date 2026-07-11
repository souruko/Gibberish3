Options2.Elements.CheckBoxRow = class(Turbine.UI.Control)
function Options2.Elements.CheckBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description

    local sp             = Options.Defaults.window.spacing
    local g_content_top  = -2

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(sp, sp)
    self.label:SetSize(110, height - sp)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.label:SetFont(Options.Defaults.window.font)
    Options2.Elements.Tooltip.AddTooltip(self.label, "tooltip", tooltip_description, false)

    self.checkbox = Options2.Elements.CheckBox()
    self.checkbox:SetParent(self)
    self.checkbox:SetPosition(140, sp + g_content_top)

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.CheckBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.CheckBoxRow:SizeChanged()
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
