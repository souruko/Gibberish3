local H = 28
local STRIPE = 8
local INDENT = 12
local ARROW_W = 18
local COLOR_COND = Turbine.UI.Color(0.55, 0.18, 0.75)
local ICON_S  = 10
local TOG_W   = 18
local TOG_S   = 10
local COL_ON  = Turbine.UI.Color(0.2, 0.75, 0.3)
local COL_OFF = Turbine.UI.Color(0.25, 0.25, 0.25)

Options2NavCondition = class(Turbine.UI.Control)
function Options2NavCondition:Constructor(navWin, winIdx, timerIdx, condIdx, condData, key, expanded, depth)
    Turbine.UI.Control.Constructor(self)

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 3
    self.nodeData = {
        nodeType       = "condition",
        key            = key,
        data           = condData,
        windowIndex    = winIdx,
        timerIndex     = timerIdx,
        conditionIndex = condIdx,
    }

    self:SetHeight(H)

    self.stripe = Turbine.UI.Control()
    self.stripe:SetParent(self)
    self.stripe:SetPosition(0, 0)
    self.stripe:SetSize(STRIPE, H)
    self.stripe:SetBackColor(COLOR_COND)
    self.stripe:SetMouseVisible(false)

    local win_line_x = STRIPE + (self.depth - 2) * INDENT + math.floor((ARROW_W - 2) / 2)
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
    self.label:SetForeColor(COLOR_COND)
    self.label:SetText(
        (condData.description ~= nil and condData.description ~= "")
        and condData.description or "(condition)"
    )
    self.label:SetMouseVisible(false)

    self.toggle = Turbine.UI.Control()
    self.toggle:SetParent(self)
    self.toggle:SetSize(TOG_S, TOG_S)
    self.toggle:SetTop(math.floor((H - TOG_S) / 2))
    self.toggle:SetMouseVisible(true)
    self.toggle:SetBackColor(condData.enabled == true and COL_ON or COL_OFF)
    self.toggle.MouseClick = function()
        condData.enabled = not condData.enabled
        self.toggle:SetBackColor(condData.enabled and COL_ON or COL_OFF)
        Options.SaveData()
        if winIdx ~= nil then
            Options.DataChanged(winIdx)
            Windows.EnabledChanged(winIdx)
        end
    end

    self.MouseEnter = function()
        if not self.selected then
            self:SetBackColor(Options.Defaults.window.hovercolor)
        end
    end
    self.MouseLeave = function()
        if not self.selected then self:SetBackColor(nil) end
    end
    self.MouseDown = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then navWin:_DragBegin(self, args) end
    end
    self.MouseMove = function(sender, args) navWin:_DragMove(self, args) end
    self.MouseUp = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then navWin:_DragFinish(self, args) end
    end
    self.MouseDoubleClick = function(sender, args)
        if args.Button ~= Turbine.UI.MouseButton.Right then
            navWin:_ToggleExpand(self)
        end
    end
    self.MouseClick = function(sender, args)
        if navWin._drag_just_ended then navWin._drag_just_ended = false; return end
        if args.Button == Turbine.UI.MouseButton.Right then
            navWin:ItemRightClicked(self)
        else
            navWin:ItemClicked(self)
        end
    end
end

function Options2NavCondition:SizeChanged()
    if self.label == nil then return end
    local w  = self:GetWidth()
    local cx = STRIPE + self.depth * INDENT
    self.label:SetWidth(w - cx - ARROW_W - TOG_W - 2)
    self.toggle:SetLeft(w - TOG_S - 4)
end

function Options2NavCondition:SetSelected(v)
    self.selected = v
    self:SetBackColor(v and Options.Defaults.window.w_window_select or nil)
end

function Options2NavCondition:GetKey()       return self.key end
function Options2NavCondition:IsExpandable() return true end

function Options2NavCondition:SetExpanded(v)
    self.arrow:SetBackground(v and "Gibberish3/RESOURCES/nav_arrow_down.tga" or "Gibberish3/RESOURCES/nav_arrow_right.tga")
end
