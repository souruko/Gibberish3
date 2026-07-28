Options2.Elements.SliderBoxRow = class(Turbine.UI.Control)
function Options2.Elements.SliderBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description
    self.updating          = false

    self:SetBackColor(back_color)

    local M = Options2.Elements.EditorRow

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    self.field   = M.MakeField(self, false)
    self.textbox = self.field.box

    self.slider_frame = Turbine.UI.Control()
    self.slider_frame:SetParent(self)
    self.slider_frame:SetBackColor(Options.Defaults.window.bg_sunken)
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
    if self.field == nil then return end
    local M = Options2.Elements.EditorRow
    local width, height = self:GetSize()
    local top = M.CentreTop(height, M.CTRL_H)

    self.label:SetHeight(height)
    self.field:Layout(M.CTRL_LEFT, top, M.NUM_W, M.CTRL_H)

    local frame_left  = M.CTRL_LEFT + M.NUM_W + 6
    local frame_width = math.max(0, width - frame_left - M.RIGHT_PAD)
    self.slider_frame:SetPosition(frame_left, top)
    self.slider_frame:SetSize(frame_width, M.CTRL_H)

    local pad = 2
    self.slider:SetPosition(pad, math.floor(M.CTRL_H / 2) - 5)
    self.slider:SetWidth(math.max(0, frame_width - 2 * pad))
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
