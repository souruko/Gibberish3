Options2.Elements.NumberBoxRow = class(Turbine.UI.Control)
function Options2.Elements.NumberBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)
    local M = Options2.Elements.EditorRow

    self.label_control     = label_control
    self.label_description = label_description

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    self.field = M.MakeField(self, false)

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.NumberBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.NumberBoxRow:SizeChanged()
    if self.field == nil then return end
    local M = Options2.Elements.EditorRow
    local h = self:GetHeight()
    self.label:SetHeight(h)
    -- a number is narrow, so it keeps a fixed width rather than filling the row
    self.field:Layout(M.CTRL_LEFT, M.CentreTop(h, M.CTRL_H), M.NUM_W, M.CTRL_H)
end

function Options2.Elements.NumberBoxRow:SetText(value)
    self.field.box:SetText(value)
end

function Options2.Elements.NumberBoxRow:GetText()
    return tonumber(self.field.box:GetText())
end
