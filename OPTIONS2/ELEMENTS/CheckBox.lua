-- 15x15 checkbox: sunken fill, 1px border that turns accent when checked, and
-- an accent tick. Drawn rather than a .tga so the states can carry colour.

local SIZE = 15

Options2.Elements.CheckBox = class(Turbine.UI.Control)
function Options2.Elements.CheckBox:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.checked = false
    self:SetSize(SIZE, SIZE)
    self:SetMouseVisible(true)

    self.inner = Turbine.UI.Control()
    self.inner:SetParent(self)
    self.inner:SetPosition(1, 1)
    self.inner:SetSize(SIZE - 2, SIZE - 2)
    self.inner:SetBackColor(Options.Defaults.window.bg_sunken)
    self.inner:SetMouseVisible(false)

    self.tick = Turbine.UI.Label()
    self.tick:SetParent(self.inner)
    self.tick:SetSize(SIZE - 2, SIZE - 2)
    self.tick:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.tick:SetForeColor(Options.Defaults.window.accent)
    self.tick:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.tick:SetText("x")
    self.tick:SetMouseVisible(false)

    self.MouseClick = function()
        self:SetChecked(not self.checked)
        self.CheckedChanged(self.checked)
    end

    self:SetChecked(false)
end

function Options2.Elements.CheckBox:SetChecked(value)
    self.checked = value
    self.tick:SetVisible(value == true)
    if value == true then
        self:SetBackColor(Options.Defaults.window.accent)
    else
        self:SetBackColor(Options.Defaults.window.line)
    end
end

function Options2.Elements.CheckBox:IsChecked()
    return self.checked
end

function Options2.Elements.CheckBox.CheckedChanged(value)
end
