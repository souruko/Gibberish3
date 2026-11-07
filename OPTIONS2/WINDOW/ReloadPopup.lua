-- The reload prompt, shown when ReloadMode.Prompt is set and a group change asks
-- for a reload. A small standalone window centred on the screen, so it is seen
-- with the options panel closed - unlike DeletePopup, which lives inside it.
--
-- Built fresh each time it is shown and dropped when it is answered: every metric
-- it holds is read in the constructor, so it needs no font refresh callback and
-- nothing to restore after a font size change.

local PAD   = 10
local BTN_H = 28
local BTN_W = 120
local GAP   = 10
local MSG_H = 54

Options2.Window.ReloadPopup = class(Options2.Elements.PanelWindow)

function Options2.Window.ReloadPopup:Constructor()

    local F     = Options2.Fonts
    local pad   = F.Px(PAD)
    local btn_h = F.Px(BTN_H)
    local btn_w = F.Px(BTN_W)
    local gap   = F.Px(GAP)
    local msg_h = F.Px(MSG_H)

    -- the client area holds the message with the two buttons beneath it
    local win_w = F.Px(360)
    local client_h = pad + msg_h + gap + btn_h + pad
    local win_h = client_h + F.Px(33)

    Options2.Elements.PanelWindow.Constructor(self, {
        min_width  = win_w,
        min_height = win_h,
    })

    self:SetTitleText(UTILS.GetText("reload_prompt", "title"))

    self.message = Turbine.UI.Label()
    self.message:SetParent(self.client)
    self.message:SetPosition(pad, pad)
    self.message:SetHeight(msg_h)
    self.message:SetFont(Options.Defaults.window.font)
    self.message:SetForeColor(Options.Defaults.window.text)
    self.message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.message:SetMultiline(true)
    self.message:SetMouseVisible(false)
    self.message:SetText(UTILS.GetText("reload_prompt", "message"))

    local function make_button(text, base, hover, fn)
        local btn = Turbine.UI.Control()
        btn:SetParent(self.client)
        btn:SetSize(btn_w, btn_h)
        btn:SetBackColor(base)
        btn:SetMouseVisible(true)

        local lbl = Turbine.UI.Label()
        lbl:SetParent(btn)
        lbl:SetSize(btn_w, btn_h)
        lbl:SetFont(Options.Defaults.window.font)
        lbl:SetForeColor(Options.Defaults.window.text)
        lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
        lbl:SetText(text)
        lbl:SetMouseVisible(false)

        btn.MouseEnter = function() btn:SetBackColor(hover) end
        btn.MouseLeave = function() btn:SetBackColor(base) end
        btn.MouseClick = function() fn() end

        return btn
    end

    self.btn_reload = make_button(
        UTILS.GetText("reload_prompt", "reload"),
        Options.Defaults.window.select,
        Options.Defaults.window.accent,
        function() self:_Reload() end)

    self.btn_later = make_button(
        UTILS.GetText("reload_prompt", "later"),
        Options.Defaults.window.bg_sunken,
        Options.Defaults.window.select,
        function() self:CloseWindow() end)

    self._btn_h = btn_h
    self._btn_w = btn_w
    self._gap   = gap
    self._pad   = pad

    self:SetWantsKeyEvents(true)
    self.KeyDown = function(sender, args)
        if args.Action == Turbine.UI.Lotro.Action.Escape then
            self:CloseWindow()
        end
    end

    self:SetSize(win_w, win_h)
    self:MoveTo(self:_AnchorPosition(win_w, win_h))

    self:SetVisible(true)
    self:Activate()

end

-- Hangs off the shortcut button, on whichever side of it has room, using the
-- same corner logic as that button's right-click menu. The prompt turns up
-- where the player already looks for the plugin rather than over the middle of
-- the screen, and MoveTo keeps its title bar on screen wherever the button sits.
function Options2.Window.ReloadPopup:_AnchorPosition(w, h)

    local shortcut = Options.Shortcut.Object

    if shortcut == nil then
        return math.floor((Options.ScreenWidth  - w) / 2),
               math.floor((Options.ScreenHeight - h) / 2)
    end

    -- the point the window hangs off, and which of its corners lands on it
    local x, y, orientation = shortcut:GetMenuPos()
    local alignment = Turbine.UI.ContentAlignment

    local left = x
    local top  = y

    if orientation == alignment.TopRight or orientation == alignment.BottomRight then
        left = x - w
    end

    if orientation == alignment.BottomLeft or orientation == alignment.BottomRight then
        top = y - h
    end

    return left, top

end

function Options2.Window.ReloadPopup:OnLayout(w, h)

    if self.message == nil then return end

    self.message:SetWidth(w - 2 * self._pad)

    local btn_top = h - self._pad - self._btn_h
    local half    = math.floor(self._gap / 2)

    self.btn_reload:SetPosition(math.floor(w / 2) - self._btn_w - half, btn_top)
    self.btn_later:SetPosition(math.floor(w / 2) + half, btn_top)

end

function Options2.Window.ReloadPopup:_Reload()

    self:CloseWindow()
    Options.Reload()

end

-- answered either way, so the prompt goes; the next group change builds a new one
function Options2.Window.ReloadPopup:CloseWindow()

    if self._closing == true then
        return
    end
    self._closing = true

    if Options2.Window.ReloadPopupObject == self then
        Options2.Window.ReloadPopupObject = nil
    end

    -- Hide now, close on the next tick: this runs from a mouse event on a button
    -- inside this very window, so the window is one of that button's ancestors.
    -- Same trick as the font size rebuild in OPTIONS2/Functions.lua.
    self:SetVisible(false)

    local tick = Turbine.UI.Window()
    tick.Update = function(sender)
        sender:SetWantsUpdates(false)
        self:Close()
        sender:Close()
    end
    tick:SetWantsUpdates(true)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ask the player whether to reload
---------------------------------------------------------------------------------------------------
-- A group change is often several chat lines at once - somebody leaving and
-- somebody joining - so an open prompt is raised rather than replaced.
---------------------------------------------------------------------------------------------------
function Options2.ShowReloadPrompt()

    if Options2.Window.ReloadPopupObject ~= nil then
        Options2.Window.ReloadPopupObject:Activate()
        return
    end

    Options2.Window.ReloadPopupObject = Options2.Window.ReloadPopup()

end
---------------------------------------------------------------------------------------------------
