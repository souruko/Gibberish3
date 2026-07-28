Options2.Elements.IconBoxRow = class(Turbine.UI.Control)
function Options2.Elements.IconBoxRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description
    local M = Options2.Elements.EditorRow

    self.label = M.MakeLabel(self, tooltip_description)
    self.label:SetHeight(height)

    -- a game icon: native size, no stretch, and no Overlay blend (which would
    -- render it invisible against the dark panel)
    self.icon = Turbine.UI.Control()
    self.icon:SetParent(self)
    self.icon:SetSize(Options2.Elements.RowParts.ICON_NATIVE,
                      Options2.Elements.RowParts.ICON_NATIVE)
    self.icon:SetMouseVisible(false)

    self.field   = M.MakeField(self, false)
    self.textbox = self.field.box
    self.textbox.TextChanged = function()
        self:SetIcon()
    end

    self.externalMode = false

    self:SetHeight(height)
    self:SetBackColor(back_color)
    self:LanguageChanged()
end

function Options2.Elements.IconBoxRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
end

function Options2.Elements.IconBoxRow:SizeChanged()
    if self.field == nil then return end
    local M  = Options2.Elements.EditorRow
    local IC = Options2.Elements.RowParts.ICON_NATIVE
    local width, height = self:GetSize()

    self.label:SetHeight(height)
    self.icon:SetPosition(M.CTRL_LEFT, M.CentreTop(height, IC))

    local field_left = M.CTRL_LEFT + IC + 6
    self.field:Layout(field_left, M.CentreTop(height, M.CTRL_H),
        math.max(0, width - field_left - M.RIGHT_PAD), M.CTRL_H)
end

function Options2.Elements.IconBoxRow:SetText(value)
    self.textbox:SetText(value)
    self:SetIcon()
end

function Options2.Elements.IconBoxRow:GetText()
    if self.externalMode then
        return self.textbox:GetText()
    end
    return tonumber(self.textbox:GetText())
end

function Options2.Elements.IconBoxRow:SetExternalMode(value)
    self.externalMode = value == true
    self:SetIcon()
end

function Options2.Elements.IconBoxRow:SetIcon()
    local icon_id = self.externalMode and self.textbox:GetText() or tonumber(self.textbox:GetText())
    if icon_id == nil or icon_id == "" then
        self.icon:SetBackground()
        return
    end
    local resolved = UTILS.ResolveTimerIcon(icon_id, self.externalMode)
    Options2.Elements.RowParts.SetNativeIcon(self.icon, resolved)
end
