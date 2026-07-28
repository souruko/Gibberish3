Options2.Elements.DropDownRow = class(Turbine.UI.Control)
function Options2.Elements.DropDownRow:Constructor(back_color, label_control, label_description, tooltip_description, height, lines)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description

    local M = Options2.Elements.EditorRow

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    self.dropdown = Options2.Elements.Dropdown(M.DROP_W, lines)
    self.dropdown:SetParent(self)
    self.dropdown:SetPosition(M.CTRL_LEFT, M.CentreTop(height, M.CTRL_H))
    self.dropdown:SetHeight(M.CTRL_H)

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.DropDownRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.DropDownRow:SizeChanged()
    if self.dropdown == nil then return end
    local M = Options2.Elements.EditorRow
    local h = self:GetHeight()
    self.label:SetHeight(h)
    self.dropdown:SetTop(M.CentreTop(h, M.CTRL_H))
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
