-- Contents column: 20px band separating the sections of a container.
-- Not selectable and holds no nodeData.

local H   = 20
local PAD = 10

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    H = F.Px(20)
end)

Options2ContentSection = class(Turbine.UI.Control)
function Options2ContentSection:Constructor(key, text)
    Turbine.UI.Control.Constructor(self)

    self.key      = key
    self.nodeData = nil
    self.depth    = 0

    self:SetHeight(H)
    self:SetBackColor(Options.Defaults.window.row_even)
    self:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(PAD, 0)
    self.label:SetHeight(H)
    self.label:SetFont(Options2.Fonts.SMALL)
    self.label:SetForeColor(Options.Defaults.window.text_faint)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetMouseVisible(false)

    self.sep = Turbine.UI.Control()
    self.sep:SetParent(self)
    self.sep:SetHeight(1)
    self.sep:SetBackColor(Options.Defaults.window.line)
    self.sep:SetMouseVisible(false)

    self:SetText(text)
end

function Options2ContentSection:SetText(text)
    self._text = text or ""
    self.label:SetText(self._text)
end

function Options2ContentSection:SizeChanged()
    if self.label == nil then return end
    local w = self:GetWidth()
    self.label:SetWidth(math.max(0, w - 2 * PAD))
    self.sep:SetPosition(0, H - 1)
    self.sep:SetWidth(w)
end

-- uniform row interface so the controller can treat every entry alike
function Options2ContentSection:GetKey()          return self.key end
function Options2ContentSection:IsSelectable()    return false end
function Options2ContentSection:SetSelected(v)    end
function Options2ContentSection:Refresh()         end
