-- On/off switch, 22x12: a 1px-bordered track with a knob that sits left when
-- off and right when on. Off it is dark and muted, on it fills with the accent.
--
-- Drawn from plain controls rather than a .tga on purpose. A .tga cannot be
-- tinted (SetBackColor fills the control behind the glyph rather than colouring
-- it), so a checkmark image could not take the accent the way the rest of the
-- panel's active states do, and it would bring the usual blend-mode pitfalls
-- with it. Primitives keep every state in the palette.
--
-- The name stays CheckBox: it is the same boolean control with the same API
-- (SetChecked / IsChecked / CheckedChanged), only drawn differently.

local W     = 22
local H     = 12
local KNOB  = 8
local INSET = 2

Options2.Elements.CheckBox = class(Turbine.UI.Control)

-- so callers can lay out around it without restating the numbers
Options2.Elements.CheckBox.WIDTH  = W
Options2.Elements.CheckBox.HEIGHT = H

function Options2.Elements.CheckBox:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.checked = false
    self:SetSize(W, H)
    self:SetMouseVisible(true)

    -- self is the 1px border; track is the fill inside it
    self.track = Turbine.UI.Control()
    self.track:SetParent(self)
    self.track:SetPosition(1, 1)
    self.track:SetSize(W - 2, H - 2)
    self.track:SetMouseVisible(false)

    self.knob = Turbine.UI.Control()
    self.knob:SetParent(self)
    self.knob:SetSize(KNOB, KNOB)
    self.knob:SetTop(math.floor((H - KNOB) / 2))
    self.knob:SetMouseVisible(false)

    self.MouseClick = function()
        self:SetChecked(not self.checked)
        self.CheckedChanged(self.checked)
    end

    self:SetChecked(false)
end

function Options2.Elements.CheckBox:SetChecked(value)
    self.checked = (value == true)

    if self.checked then
        self:SetBackColor(Options.Defaults.window.accent)
        self.track:SetBackColor(Options.Defaults.window.accent)
        self.knob:SetBackColor(Options.Defaults.window.text)
        self.knob:SetLeft(W - INSET - KNOB)
    else
        self:SetBackColor(Options.Defaults.window.off_border)
        self.track:SetBackColor(Options.Defaults.window.bg_sunken)
        self.knob:SetBackColor(Options.Defaults.window.text_muted)
        self.knob:SetLeft(INSET)
    end
end

function Options2.Elements.CheckBox:IsChecked()
    return self.checked
end

function Options2.Elements.CheckBox.CheckedChanged(value)
end
