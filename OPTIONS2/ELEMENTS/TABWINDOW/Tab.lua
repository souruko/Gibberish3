local ACCENT_H  = 3
local TAB_BG    = Turbine.UI.Color(0.14, 0.14, 0.14)
local ACCENT_C  = Turbine.UI.Color(0.14, 0.48, 0.72)  -- same blue as nav window stripe

Options2Tab = class(Turbine.UI.Control)
function Options2Tab:Constructor(index, name_control, name_description, parent, width)
    Turbine.UI.Control.Constructor(self)

    self.parent           = parent
    self.selected         = false
    self.index            = index
    self.name_control     = name_control
    self.name_description = name_description

    local frame = Options.Defaults.window.frame
    local th    = Options.Defaults.window.tab_height

    -- inset content panel (shows the frame color as a border when selected)
    self.background1 = Turbine.UI.Control()
    self.background1:SetParent(self)
    self.background1:SetBackColor(TAB_BG)
    self.background1:SetPosition(frame, frame)
    self.background1:SetSize(width - 2 * frame, th - frame)
    self.background1:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self.background1)
    self.label:SetHeight(th)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.label:SetFont(Options.Defaults.window.font)
    self.label:SetForeColor(Options.Defaults.window.textdark)
    self.label:SetMouseVisible(false)

    -- accent bar (shown only on selected tab)
    self.accent = Turbine.UI.Control()
    self.accent:SetParent(self)
    self.accent:SetBackColor(ACCENT_C)
    self.accent:SetSize(width, ACCENT_H)
    self.accent:SetTop(th + frame - ACCENT_H)
    self.accent:SetVisible(false)
    self.accent:SetMouseVisible(false)

    self.MouseClick = function()
        if self.selected == false then
            self.parent:ChangeSelection(index)
        end
    end
    self.MouseEnter = function()
        if self.selected == false then
            self.background1:SetBackColor(Options.Defaults.window.w_window_hover)
        end
    end
    self.MouseLeave = function()
        if self.selected == false then
            self.background1:SetBackColor(TAB_BG)
        end
    end

    self:SetSize(width, th)
    self:LanguageChanged()
end

function Options2Tab:SizeChanged()
    if self.accent == nil then return end
    local w = self:GetWidth()
    local h = self:GetHeight()
    self.label:SetWidth(w)
    self.accent:SetWidth(w)
    self.accent:SetTop(h - ACCENT_H)
end

function Options2Tab:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.name_control, self.name_description))
end

function Options2Tab:Select(index)
    local frame = Options.Defaults.window.frame
    local th    = Options.Defaults.window.tab_height
    if self.index == index then
        self.selected = true
        self:SetBackColor(Options.Defaults.window.framecolor)
        self.background1:SetBackColor(Options.Defaults.window.backcolor1)
        self.label:SetForeColor(Options.Defaults.window.textcolor)
        self:SetHeight(th + frame)
        self.background1:SetHeight(th)
        self.accent:SetVisible(true)
    else
        self.selected = false
        self:SetBackColor(nil)
        self.background1:SetBackColor(TAB_BG)
        self.label:SetForeColor(Options.Defaults.window.textdark)
        self:SetHeight(th)
        self.background1:SetHeight(th - frame)
        self.accent:SetVisible(false)
    end
end
