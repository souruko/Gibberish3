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

    if self.sub_menu == nil then return end

    -- all of this is in canvas coordinates - the submenu is a child control of
    -- the menu window, so it has to stay inside the canvas or it gets clipped
    local left, top          = self.parent:GetPos()
    local canvas_w, canvas_h = self.parent:GetCanvasSize()
    local sub_width          = self.sub_menu:GetWidth()
    local sub_height         = self.sub_menu:GetHeight()

    -- beside the row, and to its left when the menu itself opened leftwards or
    -- there is no room on the right
    local sub_left = left + self:GetWidth()
    if self.parent:FlipsLeft() or sub_left + sub_width > canvas_w then
        sub_left = left - sub_width
    end

    local sub_top = top + self:GetTop()

    sub_left = math.max(0, math.min(sub_left, canvas_w - sub_width))
    sub_top  = math.max(0, math.min(sub_top,  canvas_h - sub_height))

    self.sub_menu:Show(sub_left, sub_top)
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
