Options2.Elements.TextBoxRow = class(Turbine.UI.Control)
function Options2.Elements.TextBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height, allow_multiline)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description

    local sp = Options.Defaults.window.spacing

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(sp, sp)
    self.label:SetSize(110, height - sp)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.label:SetFont(Options.Defaults.window.font)
    Options2.Elements.Tooltip.AddTooltip(self.label, "tooltip", tooltip_description, false)

    self.textbox = Turbine.UI.Lotro.TextBox()
    self.textbox:SetParent(self)
    self.textbox:SetPosition(130 + 2 * sp, sp)
    self.textbox:SetHeight(height - 2 * sp)
    self.textbox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.textbox:SetForeColor(Options.Defaults.window.textcolor)
    self.textbox:SetSelectable(true)
    self.textbox:SetFont(Options.Defaults.window.font)
    self.textbox:SetMultiline(allow_multiline)
    self.textbox:SetMarkupEnabled(false)

    self:SetHeight(height)
    self:SetBackColor(back_color)

    self:LanguageChanged()
end

function Options2.Elements.TextBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.TextBoxRow:SizeChanged()
    local width = self:GetWidth()
    self.textbox:SetWidth(width - 130 - 3 * Options.Defaults.window.spacing)
end

function Options2.Elements.TextBoxRow:SetText(value)
    self.textbox:SetText(value)
end

function Options2.Elements.TextBoxRow:GetText()
    return self.textbox:GetText()
end
