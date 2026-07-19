Options2DropdownItem = class(Turbine.UI.Control)
function Options2DropdownItem:Constructor(parent, width, text_control, text_description, value, height)
    Turbine.UI.Control.Constructor(self)

    self.parent           = parent
    self.text_control     = text_control
    self.text_description = text_description
    self.value            = value
    self.selected         = false

    self:SetSize(width, height)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetSize(width - 15, height)
    self.label:SetLeft(5)
    self.label:SetMultiline(true)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetFont(Options.Defaults.window.font)
    self.label:SetMouseVisible(false)

    self:LanguageChanged()

    self.MouseClick = function()
        if self.selected == false then
            self.parent:ChangeSelection(self)
        else
            self.parent:Show(false)
        end
    end
    self.MouseEnter = function()
        if self.selected == false then
            self:SetBackColor(Options.Defaults.dropdown.base_color)
        end
    end
    self.MouseLeave = function()
        self:SetBackColor(nil)
    end
end

function Options2DropdownItem:LanguageChanged()
    if self.text_control == nil then
        self.label:SetText(self.text_description)
    else
        self.label:SetText(UTILS.GetText(self.text_control, self.text_description))
    end
end

function Options2DropdownItem:Select(value)
    self.selected = value
    if value == true then
        self.label:SetForeColor(Options.Defaults.dropdown.selected_color)
    else
        self.label:SetForeColor(Options.Defaults.dropdown.nselected_color)
    end
end
