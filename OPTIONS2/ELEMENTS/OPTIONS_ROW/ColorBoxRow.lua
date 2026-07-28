Options2.Elements.ColorBoxRow = class(Turbine.UI.Control)
function Options2.Elements.ColorBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description

    local M = Options2.Elements.EditorRow

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    self.color = Turbine.UI.Control()
    self.color:SetParent(self)
    self.color:SetSize(M.CTRL_H, M.CTRL_H)
    self.color:SetBackColor(Turbine.UI.Color.Black)
    self.color:SetMouseVisible(false)

    self.field = M.MakeField(self, false)
    self.textbox = self.field.box
    self.textbox.TextChanged = function()
        self:TextChanged()
    end

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.ColorBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.ColorBoxRow:SizeChanged()
    if self.field == nil then return end
    local M = Options2.Elements.EditorRow
    local w, h = self:GetSize()
    local top  = M.CentreTop(h, M.CTRL_H)
    self.label:SetHeight(h)
    self.color:SetPosition(M.CTRL_LEFT, top)
    local field_left = M.CTRL_LEFT + M.CTRL_H + 6
    self.field:Layout(field_left, top,
        math.max(0, w - field_left - M.RIGHT_PAD), M.CTRL_H)
end

function Options2.Elements.ColorBoxRow:SetText(value)
    self.textbox:SetText(UTILS.ColorToText(value))
    self:TextChanged()
end

function Options2.Elements.ColorBoxRow:GetText()
    return UTILS.TextToColor(self.textbox:GetText())
end

function Options2.Elements.ColorBoxRow:TextChanged()
    local color = UTILS.TextToColor(self.textbox:GetText())
    self.color:SetBackColor(UTILS.ColorFix(color))
end
