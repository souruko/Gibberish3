Options2.Elements.NumberBoxRow = class(Turbine.UI.Control)
function Options2.Elements.NumberBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
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
    self.textbox:SetMultiline(false)

    self:SetHeight(height)
    self:SetBackColor(back_color)

    self:LanguageChanged()
end

function Options2.Elements.NumberBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.NumberBoxRow:SizeChanged()
    local width = self:GetWidth()
    self.textbox:SetWidth(width - 130 - 3 * Options.Defaults.window.spacing)
end

function Options2.Elements.NumberBoxRow:SetText(value)
    self.textbox:SetText(value)
end

function Options2.Elements.NumberBoxRow:GetText()
    return tonumber(self.textbox:GetText())
end
