Options2.Elements.CheckRow = class(Turbine.UI.Control)
function Options2.Elements.CheckRow:Constructor(text_control, text_description, func, height)
    Turbine.UI.Control.Constructor(self)

    self.parent           = nil
    self.func             = func
    self.text_control     = text_control
    self.text_description = text_description

    self.checkbox = Options2.Elements.CheckBox()
    self.checkbox:SetParent(self)
    self.checkbox:SetPosition(Options.Defaults.rc_menu.text_left, (height - 32) / 2)
    self.checkbox:SetMouseVisible(false)

    self.text = Turbine.UI.Label()
    self.text:SetParent(self)
    self.text:SetHeight(height)
    self.text:SetLeft(Options.Defaults.rc_menu.text_left + 36)
    self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.text:SetFont(Options.Defaults.rc_menu.font)
    self.text:SetMouseVisible(false)

    self:SetHeight(height)
    self:SetMouseVisible(true)

    self:LanguageChanged()
end

function Options2.Elements.CheckRow:MouseClick(sender, args)
    self.checkbox:SetChecked(not self.checkbox:IsChecked())
    self.func(self.checkbox:IsChecked())
    self.parent:Hide()
end

function Options2.Elements.CheckRow:MouseEnter(sender, args)
    self:Hover(true)
    self.parent:HoverChanged(self)
end

function Options2.Elements.CheckRow:Hover(value)
    if value == true then
        self:SetBackColor(Options.Defaults.rc_menu.hover_color)
    else
        self:SetBackColor(nil)
    end
end

function Options2.Elements.CheckRow:SetChecked(value)
    self.checkbox:SetChecked(value)
end

function Options2.Elements.CheckRow:IsChecked()
    return self.checkbox:IsChecked()
end

function Options2.Elements.CheckRow:LanguageChanged()
    self.text:SetText(UTILS.GetText(self.text_control, self.text_description))
end

function Options2.Elements.CheckRow:SizeChanged()
end

function Options2.Elements.CheckRow:SetSuper(parent)
    self.parent = parent
end
