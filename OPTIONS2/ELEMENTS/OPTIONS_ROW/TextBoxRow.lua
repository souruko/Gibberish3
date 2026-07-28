Options2.Elements.TextBoxRow = class(Turbine.UI.Control)
function Options2.Elements.TextBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height, allow_multiline)
    Turbine.UI.Control.Constructor(self)
    local M = Options2.Elements.EditorRow

    self.label_control     = label_control
    self.label_description = label_description
    self.multiline         = (allow_multiline == true)

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    self.field = M.MakeField(self, self.multiline)

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.TextBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.TextBoxRow:SizeChanged()
    if self.field == nil then return end
    local M = Options2.Elements.EditorRow
    local w, h = self:GetSize()
    self.label:SetHeight(h)

    -- a multiline box fills the row height; a single-line one is 22 and centred
    local fh  = self.multiline and math.max(0, h - 6) or M.CTRL_H
    local top = self.multiline and 3 or M.CentreTop(h, fh)
    self.field:Layout(M.CTRL_LEFT, top,
        math.max(0, w - M.CTRL_LEFT - M.RIGHT_PAD), fh)
end

function Options2.Elements.TextBoxRow:SetMarkupEnabled(enabled)
    self.field.box:SetMarkupEnabled(enabled)
end

function Options2.Elements.TextBoxRow:SetText(value)
    self.field.box:SetText(value)
end

function Options2.Elements.TextBoxRow:GetText()
    return self.field.box:GetText()
end
