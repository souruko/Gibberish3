local H = 28
local STRIPE = 4
local INDENT = 12
local ARROW_W = 18
local ICON_SIZE = 20
local ICON_MARGIN = 4
local ICON_S  = 10

Options2NavTimer = class(Turbine.UI.Control)
function Options2NavTimer:Constructor(navWin, winIdx, timerIdx, timerData, key, expanded, depth)
    Turbine.UI.Control.Constructor(self)

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 2
    self.nodeData = {
        nodeType    = "timer",
        key         = key,
        data        = timerData,
        windowIndex = winIdx,
        timerIndex  = timerIdx,
    }

    self:SetHeight(H)

    self.stripe = Turbine.UI.Control()
    self.stripe:SetParent(self)
    self.stripe:SetPosition(0, 0)
    self.stripe:SetSize(STRIPE, H)
    self.stripe:SetBackColor(Options.Defaults.window.color_timer)
    self.stripe:SetMouseVisible(false)

    local win_line_x = STRIPE + (self.depth - 1) * INDENT + math.floor((ARROW_W - 2) / 2)
    self.win_line = Turbine.UI.Control()
    self.win_line:SetParent(self)
    self.win_line:SetPosition(win_line_x, 0)
    self.win_line:SetSize(2, H)
    self.win_line:SetBackColor(Options.Defaults.window.color_window)
    self.win_line:SetMouseVisible(false)

    local cx = STRIPE + self.depth * INDENT

    self.arrow = Turbine.UI.Control()
    self.arrow:SetParent(self)
    self.arrow:SetPosition(cx + math.floor((ARROW_W - ICON_S) / 2), math.floor((H - ICON_S) / 2))
    self.arrow:SetSize(ICON_S, ICON_S)
    self.arrow:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.arrow:SetBackground(expanded and "Gibberish3/RESOURCES/nav_arrow_down.tga" or "Gibberish3/RESOURCES/nav_arrow_right.tga")
    self.arrow:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(cx + ARROW_W, 0)
    self.label:SetHeight(H)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetFont(Options.Defaults.window.font)
    self.label:SetForeColor(Options.Defaults.window.color_timer)
    self.label:SetText(timerData.description ~= "" and timerData.description or "(timer)")
    self.label:SetMouseVisible(false)

    local has_icon = timerData.icon ~= nil and timerData.icon ~= 0
    self.icon_preview = Turbine.UI.Control()
    self.icon_preview:SetParent(self)
    self.icon_preview:SetSize(ICON_SIZE, ICON_SIZE)
    self.icon_preview:SetTop(math.floor((H - ICON_SIZE) / 2))
    self.icon_preview:SetMouseVisible(false)
    if has_icon then
        self.icon_preview:SetBackground(timerData.icon)
        self.icon_preview:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    else
        self.icon_preview:SetVisible(false)
    end

    self._has_icon = has_icon

    self.MouseEnter = function()
        if not self.selected then
            self:SetBackColor(Options.Defaults.window.hovercolor)
        end
    end
    self.MouseLeave = function()
        if not self.selected then self:SetBackColor(nil) end
    end
    self.MouseClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            navWin:ShowContextMenu(self.nodeData)
        else
            navWin:ItemClicked(self)
        end
    end
end

function Options2NavTimer:SizeChanged()
    if self.label == nil then return end
    local w = self:GetWidth()
    local cx = STRIPE + self.depth * INDENT
    local reserve = self._has_icon and (ICON_SIZE + ICON_MARGIN * 2) or 0
    self.label:SetWidth(w - cx - ARROW_W - reserve - 2)
    if self._has_icon then
        self.icon_preview:SetLeft(w - ICON_SIZE - ICON_MARGIN)
    end
end

function Options2NavTimer:SetSelected(v)
    self.selected = v
    self:SetBackColor(v and Options.Defaults.window.w_window_select or nil)
end

function Options2NavTimer:GetKey()       return self.key end
function Options2NavTimer:IsExpandable() return true end

function Options2NavTimer:SetExpanded(v)
    self.arrow:SetBackground(v and "Gibberish3/RESOURCES/nav_arrow_down.tga" or "Gibberish3/RESOURCES/nav_arrow_right.tga")
end
