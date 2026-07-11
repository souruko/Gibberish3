Options2.Elements.SliderBoxRow = class(Turbine.UI.Control)
function Options2.Elements.SliderBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description
    self.updating          = false

    self:SetBackColor(back_color)

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
    self.textbox:SetSize(55, height - 2 * sp)
    self.textbox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.textbox:SetForeColor(Options.Defaults.window.textcolor)
    self.textbox:SetSelectable(true)
    self.textbox:SetFont(Options.Defaults.window.font)
    self.textbox:SetMultiline(false)

    self.slider_frame = Turbine.UI.Control()
    self.slider_frame:SetParent(self)
    self.slider_frame:SetBackColor(Turbine.UI.Color(0.25, 0.25, 0.25))
    self.slider_frame:SetMouseVisible(false)

    self.slider = Turbine.UI.Lotro.ScrollBar()
    self.slider:SetParent(self.slider_frame)
    self.slider:SetOrientation(Turbine.UI.Orientation.Horizontal)
    self.slider:SetMinimum(0)
    self.slider:SetMaximum(100)
    self.slider:SetHeight(10)

    self.slider.ValueChanged = function(sender, args)
        if self.updating then return end
        self.updating = true
        self.textbox:SetText(string.format("%.2f", self.slider:GetValue() / 100))
        self.updating = false
    end

    self.textbox.TextChanged = function(sender, args)
        if self.updating then return end
        local val = tonumber(self.textbox:GetText())
        if val == nil then return end
        self.updating = true
        if val < 0 then val = 0 end
        if val > 1 then val = 1 end
        self.slider:SetValue(math.floor(val * 100 + 0.5))
        self.updating = false
    end

    self:SetHeight(height)
    self:LanguageChanged()
end

function Options2.Elements.SliderBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.SliderBoxRow:SizeChanged()
    local width, height = self:GetSize()
    local sp = Options.Defaults.window.spacing

    local textbox_left = 130 + 2 * sp
    self.textbox:SetPosition(textbox_left, sp)

    local frame_left  = textbox_left + 55 + sp
    local frame_width = width - frame_left - sp
    local frame_height = height - 2 * sp
    self.slider_frame:SetPosition(frame_left, sp)
    self.slider_frame:SetSize(frame_width, frame_height)

    local pad = 2
    self.slider:SetPosition(pad, frame_height / 2 - 4)
    self.slider:SetWidth(frame_width - 2 * pad)
end

function Options2.Elements.SliderBoxRow:SetText(value)
    local val = tonumber(value) or 0
    if val < 0 then val = 0 end
    if val > 1 then val = 1 end
    self.updating = true
    self.textbox:SetText(string.format("%.2f", val))
    self.slider:SetValue(math.floor(val * 100 + 0.5))
    self.updating = false
end

function Options2.Elements.SliderBoxRow:GetText()
    local val = tonumber(self.textbox:GetText()) or 0
    if val < 0 then return 0 end
    if val > 1 then return 1 end
    return val
end
