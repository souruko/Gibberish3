local H = 28
local STRIPE = 4
local INDENT = 12
local ARROW_W = 18
local BADGE_W = 52
local ICON_S  = 10
local TOG_W   = 18
local TOG_S   = 10
local COL_ON  = Turbine.UI.Color(0.2, 0.75, 0.3)
local COL_OFF = Turbine.UI.Color(0.25, 0.25, 0.25)

Options2NavWindow = class(Turbine.UI.Control)
function Options2NavWindow:Constructor(navWin, winIdx, winData, key, expanded, depth)
    Turbine.UI.Control.Constructor(self)

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 1
    self.nodeData = {
        nodeType    = "window",
        key         = key,
        data        = winData,
        windowIndex = winIdx,
    }

    self:SetHeight(H)

    self.stripe = Turbine.UI.Control()
    self.stripe:SetParent(self)
    self.stripe:SetPosition(0, 0)
    self.stripe:SetSize(STRIPE, H)
    self.stripe:SetBackColor(Options.Defaults.window.color_window)
    self.stripe:SetMouseVisible(false)

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
    self.label:SetForeColor(Options.Defaults.window.color_window)
    self.label:SetText(winData.name or "(window)")
    self.label:SetMouseVisible(false)

    local lang = L[Language.Local] or L[Language.English]
    local type_name  = (lang.type and winData.timerType and lang.type[winData.timerType]) or ""
    local type_label = (winData.type == Window.Types.COUNTER_WINDOW and type_name ~= "")
                       and ("Counter " .. type_name) or type_name

    self.badge = Turbine.UI.Label()
    self.badge:SetParent(self)
    self.badge:SetHeight(H)
    self.badge:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.badge:SetFont(Options.Defaults.window.font)
    self.badge:SetForeColor(Options.Defaults.window.textdark)
    self.badge:SetText(type_label)
    self.badge:SetMouseVisible(false)

    self.toggle = Turbine.UI.Control()
    self.toggle:SetParent(self)
    self.toggle:SetSize(TOG_S, TOG_S)
    self.toggle:SetTop(math.floor((H - TOG_S) / 2))
    self.toggle:SetMouseVisible(true)
    self.toggle:SetBackColor(winData.enabled == true and COL_ON or COL_OFF)
    self.toggle.MouseClick = function()
        winData.enabled = not winData.enabled
        self.toggle:SetBackColor(winData.enabled and COL_ON or COL_OFF)
        Options.SaveData()
        Options.DataChanged(winIdx)
        Windows.EnabledChanged(winIdx)
    end

    self.MouseEnter = function()
        if not self.selected then
            self:SetBackColor(Options.Defaults.window.hovercolor)
        end
    end
    self.MouseLeave = function()
        if not self.selected then self:SetBackColor(nil) end
    end
    self.MouseDoubleClick = function(sender, args)
        if args.Button ~= Turbine.UI.MouseButton.Right then
            navWin:_ToggleExpand(self)
        end
    end
    self.MouseClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            navWin:ItemRightClicked(self)
        else
            navWin:ItemClicked(self)
        end
    end
end

function Options2NavWindow:SizeChanged()
    if self.label == nil then return end
    local w  = self:GetWidth()
    local cx = STRIPE + self.depth * INDENT
    self.label:SetWidth(w - cx - ARROW_W - BADGE_W - TOG_W - 2)
    self.badge:SetPosition(w - BADGE_W - TOG_W - 2, 0)
    self.badge:SetWidth(BADGE_W)
    self.toggle:SetLeft(w - TOG_S - 4)
end

function Options2NavWindow:SetSelected(v)
    self.selected = v
    self:SetBackColor(v and Options.Defaults.window.w_window_select or nil)
end

function Options2NavWindow:GetKey()       return self.key end
function Options2NavWindow:IsExpandable() return true end

function Options2NavWindow:SetExpanded(v)
    self.arrow:SetBackground(v and "Gibberish3/RESOURCES/nav_arrow_down.tga" or "Gibberish3/RESOURCES/nav_arrow_right.tga")
end
