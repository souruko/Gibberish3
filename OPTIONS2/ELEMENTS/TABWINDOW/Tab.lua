-- Flat editor tab: equal width, 26 high, selected = bg fill plus a 2px
-- underline in the node's colour.

local TAB_H    = 26
local ACCENT_H = 2

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    TAB_H = F.Px(26)
end)

Options2Tab = class(Turbine.UI.Control)
function Options2Tab:Constructor(index, name_control, name_description, parent, width)
    Turbine.UI.Control.Constructor(self)

    self.parent           = parent
    self.selected         = false
    self.index            = index
    self.name_control     = name_control
    self.name_description = name_description

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(0, 0)
    self.label:SetHeight(TAB_H)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.label:SetFont(Options2.Fonts.BODY)
    self.label:SetForeColor(Options.Defaults.window.text_muted)
    self.label:SetMouseVisible(false)

    self.accent = Turbine.UI.Control()
    self.accent:SetParent(self)
    self.accent:SetBackColor(Options.Defaults.window.accent)
    self.accent:SetHeight(ACCENT_H)
    self.accent:SetVisible(false)
    self.accent:SetMouseVisible(false)

    self.MouseClick = function()
        if self.selected == false then
            self.parent:ChangeSelection(index)
        end
    end
    self.MouseEnter = function()
        if self.selected == false then
            self:SetBackColor(Options.Defaults.window.row_even)
        end
    end
    self.MouseLeave = function()
        if self.selected == false then
            self:SetBackColor(nil)
        end
    end

    self:SetSize(width, TAB_H)
    self:LanguageChanged()
end

function Options2Tab:SetAccentColor(color)
    self.accent:SetBackColor(color)
end

function Options2Tab:SizeChanged()
    if self.accent == nil then return end
    local w, h = self:GetSize()
    self.label:SetWidth(w)
    self.accent:SetWidth(w)
    self.accent:SetTop(h - ACCENT_H)
end

function Options2Tab:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.name_control, self.name_description))
end

function Options2Tab:Select(index)
    if self.index == index then
        self.selected = true
        self:SetBackColor(Options.Defaults.window.bg)
        self.label:SetForeColor(Options.Defaults.window.text)
        self.accent:SetVisible(true)
    else
        self.selected = false
        self:SetBackColor(nil)
        self.label:SetForeColor(Options.Defaults.window.text_muted)
        self.accent:SetVisible(false)
    end
end
