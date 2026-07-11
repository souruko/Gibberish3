Options2.Elements.IconBoxRow = class(Turbine.UI.Control)
function Options2.Elements.IconBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description
    self.content_height    = height - 2 * Options.Defaults.window.spacing

    local sp = Options.Defaults.window.spacing

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(sp, sp)
    self.label:SetSize(110, self.content_height)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.label:SetFont(Options.Defaults.window.font)
    Options2.Elements.Tooltip.AddTooltip(self.label, "tooltip", tooltip_description, false)

    self.icon = Turbine.UI.Control()
    self.icon:SetParent(self)
    self.icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.icon:SetPosition(130 + 2 * sp, sp)
    self.icon:SetSize(self.content_height, self.content_height)

    self.textbox = Turbine.UI.Lotro.TextBox()
    self.textbox:SetParent(self)
    self.textbox:SetPosition(130 + 3 * sp + self.content_height, sp)
    self.textbox:SetHeight(self.content_height)
    self.textbox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.textbox:SetForeColor(Options.Defaults.window.textcolor)
    self.textbox:SetSelectable(true)
    self.textbox:SetFont(Options.Defaults.window.font)
    self.textbox:SetMultiline(false)
    self.textbox.TextChanged = function()
        self:SetIcon()
    end

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.IconBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.IconBoxRow:SizeChanged()
    local width = self:GetWidth()
    self.textbox:SetWidth(width - 130 - 4 * Options.Defaults.window.spacing - self.content_height)
end

function Options2.Elements.IconBoxRow:SetText(value)
    self.textbox:SetText(value)
    self:SetIcon()
end

function Options2.Elements.IconBoxRow:GetText()
    return tonumber(self.textbox:GetText())
end

function Options2.Elements.IconBoxRow:SetIcon()
    local icon_id = tonumber(self.textbox:GetText())
    if icon_id == nil then
        self.icon:SetBackground()
        return
    end
    self.icon:SetSize(UTILS.GetImageSize(icon_id))
    self.icon:SetBackground(icon_id)
end
