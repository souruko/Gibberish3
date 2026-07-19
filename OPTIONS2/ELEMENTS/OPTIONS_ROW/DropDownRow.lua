Options2.Elements.DropDownRow = class(Turbine.UI.Control)
function Options2.Elements.DropDownRow:Constructor(back_color, label_control, label_description, tooltip_description, height, lines)
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

    self.dropdown = Options2.Elements.Dropdown(150, lines)
    self.dropdown:SetParent(self)
    self.dropdown:SetPosition(145, sp)
    self.dropdown:SetHeight(height - 2 * sp)

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.DropDownRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.DropDownRow:SizeChanged()
end

function Options2.Elements.DropDownRow:AddItem(text_control, text_description, value)
    self.dropdown:AddItem(text_control, text_description, value)
end

function Options2.Elements.DropDownRow:SetSelection(value)
    self.dropdown:SetSelection(value)
end

function Options2.Elements.DropDownRow:GetSelectedValue()
    return self.dropdown:GetSelectedValue()
end

function Options2.Elements.DropDownRow:ClearItems()
    self.dropdown:ClearItems()
end

function Options2.Elements.DropDownRow:Sort()
    self.dropdown:Sort()
end

function Options2.Elements.DropDownRow:SortAlpha()
    self.dropdown:SortAlpha()
end

function Options2.Elements.DropDownRow:Close()
    self.dropdown:Close()
end

function Options2.Elements.DropDownRow:SetCallback(func)
    self.dropdown.SelectionChanged = func
end
