-- Small standalone window hosting Options2.Window.SettingsPanel.
-- Opened from the gear in the options panel title bar.

local WIN_W = 380
local WIN_H = 190

Options2.Window.SettingsWindow = class(Options2.Elements.PanelWindow)
function Options2.Window.SettingsWindow:Constructor()
    Options2.Elements.PanelWindow.Constructor(self, {
        min_width  = WIN_W,
        min_height = WIN_H,
    })

    self.panel = Options2.Window.SettingsPanel()
    self.panel:SetParent(self.client)
    self.panel:SetPosition(0, 0)

    self:SetTitleText(UTILS.GetText("options2", "settings"))
    self:SetSize(WIN_W, WIN_H)

    self:SetWantsKeyEvents(true)
    self.KeyDown = function(sender, args)
        if args.Action == Turbine.UI.Lotro.Action.Escape then
            self:SetVisible(false)
        end
    end

    self:_CenterOnPanel()
    self:SetVisible(true)
end

function Options2.Window.SettingsWindow:OnLayout(w, h)
    if self.panel == nil then return end
    self.panel:SetSize(w, h)
end

function Options2.Window.SettingsWindow:_CenterOnPanel()
    local parent = Options2.Window.Object
    if parent ~= nil then
        local pl, pt = parent:GetPosition()
        local pw, ph = parent:GetSize()
        self:SetPosition(
            pl + math.floor((pw - WIN_W) / 2),
            pt + math.floor((ph - WIN_H) / 2))
        return
    end

    self:SetPosition(
        math.floor((Options.ScreenWidth  - WIN_W) / 2),
        math.floor((Options.ScreenHeight - WIN_H) / 2))
end

function Options2.Window.SettingsWindow:LanguageChanged()
    if self.panel == nil then return end
    self:SetTitleText(UTILS.GetText("options2", "settings"))
    self.panel:LanguageChanged()
end

function Options2.Window.SettingsWindow:AutoReloadChanged()
    if self.panel == nil then return end
    self.panel:AutoReloadChanged()
end

-- open, or toggle if it already exists
function Options2.ToggleSettingsWindow()
    if Options2.Window.SettingsWindowObject == nil then
        Options2.Window.SettingsWindowObject = Options2.Window.SettingsWindow()
        return
    end

    local win = Options2.Window.SettingsWindowObject
    local show = not win:IsVisible()
    if show then
        win:_CenterOnPanel()
        win:Activate()
    end
    win:SetVisible(show)
end
