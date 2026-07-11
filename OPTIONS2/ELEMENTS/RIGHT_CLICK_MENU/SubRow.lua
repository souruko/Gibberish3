Options2.Elements.SubRow = class(Turbine.UI.Control)
function Options2.Elements.SubRow:Constructor(text_control, text_description, sub_menu, height)
    Turbine.UI.Control.Constructor(self)

    self.parent           = nil
    self.sub_menu         = sub_menu
    self.text_control     = text_control
    self.text_description = text_description

    self.text = Turbine.UI.Label()
    self.text:SetParent(self)
    self.text:SetHeight(height)
    self.text:SetLeft(Options.Defaults.rc_menu.text_left)
    self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.text:SetFont(Options.Defaults.rc_menu.font)
    self.text:SetMouseVisible(false)

    self.arrow = Turbine.UI.Label()
    self.arrow:SetParent(self)
    self.arrow:SetSize(20, height)
    self.arrow:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.arrow:SetFont(Options.Defaults.rc_menu.font)
    self.arrow:SetText(">")
    self.arrow:SetMouseVisible(false)

    self:SetHeight(height)
    self:SetMouseVisible(true)

    self:LanguageChanged()
end

function Options2.Elements.SubRow:MouseEnter(sender, args)
    self:Hover(true)
    self.parent:HoverChanged(self)
    self:ShowSubMenu()
end

function Options2.Elements.SubRow:Hover(value)
    if value == true then
        self:SetBackColor(Options.Defaults.rc_menu.hover_color)
    else
        self:SetBackColor(nil)
        if self.sub_menu ~= nil then self.sub_menu:Hide() end
    end
end

function Options2.Elements.SubRow:ShowSubMenu()
    local left, top = self.parent:GetPos()
    local item_top  = self:GetTop()
    local orientation = self.parent.orientation

    if self.sub_menu ~= nil then
        self.sub_menu:Show(left + self:GetWidth(), top + item_top, orientation)
    end
end

function Options2.Elements.SubRow:LanguageChanged()
    self.text:SetText(UTILS.GetText(self.text_control, self.text_description))
end

function Options2.Elements.SubRow:SizeChanged()
    local width = self:GetWidth()
    self.text:SetWidth(width - Options.Defaults.rc_menu.text_left - 20)
    self.arrow:SetLeft(width - 20)
end

function Options2.Elements.SubRow:SetSuper(parent)
    self.parent = parent
end
