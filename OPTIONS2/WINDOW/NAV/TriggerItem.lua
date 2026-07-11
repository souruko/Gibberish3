local H = 28
local STRIPE = 4
local INDENT = 12
local ARROW_W = 18
local BADGE_W = 160
local TOG_W   = 18
local TOG_S   = 10
local COL_ON  = Turbine.UI.Color(0.2, 0.75, 0.3)
local COL_OFF = Turbine.UI.Color(0.25, 0.25, 0.25)

local function truncate(s)
    if s == nil or s == "" then return "" end
    if #s <= 24 then return s end
    return s:sub(1, 23) .. "…"
end

Options2NavTrigger = class(Turbine.UI.Control)
function Options2NavTrigger:Constructor(navWin, trigData, trigType, trigIdx, winIdx, timerIdx, key, depth)
    Turbine.UI.Control.Constructor(self)

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 3
    self.nodeData = {
        nodeType     = "trigger",
        key          = key,
        data         = trigData,
        windowIndex  = winIdx,
        timerIndex   = timerIdx,
        triggerType  = trigType,
        triggerIndex = trigIdx,
    }

    self:SetHeight(H)

    self.stripe = Turbine.UI.Control()
    self.stripe:SetParent(self)
    self.stripe:SetPosition(0, 0)
    self.stripe:SetSize(STRIPE, H)
    self.stripe:SetBackColor(Options.Defaults.window.color_trigger)
    self.stripe:SetMouseVisible(false)

    local win_line_x = STRIPE + (self.depth - 2) * INDENT + math.floor((ARROW_W - 2) / 2)
    self.win_line = Turbine.UI.Control()
    self.win_line:SetParent(self)
    self.win_line:SetPosition(win_line_x, 0)
    self.win_line:SetSize(2, H)
    self.win_line:SetBackColor(Options.Defaults.window.color_window)
    self.win_line:SetMouseVisible(false)

    local cx = STRIPE + self.depth * INDENT

    self.spacer = Turbine.UI.Control()
    self.spacer:SetParent(self)
    self.spacer:SetPosition(cx, 0)
    self.spacer:SetSize(ARROW_W, H)
    self.spacer:SetMouseVisible(false)

    local lang = L[Language.Local] or L[Language.English]
    local type_name = (lang.triggerType and lang.triggerType[trigType]) or ("Type " .. tostring(trigType))
    local lbl = (trigData.description ~= nil and trigData.description ~= "")
        and trigData.description or type_name

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetPosition(cx + ARROW_W, 0)
    self.label:SetHeight(H)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetFont(Options.Defaults.window.font)
    self.label:SetForeColor(Options.Defaults.window.color_trigger)
    self.label:SetText(lbl)
    self.label:SetMouseVisible(false)

    self.badge = Turbine.UI.Label()
    self.badge:SetParent(self)
    self.badge:SetHeight(H)
    self.badge:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.badge:SetFont(Options.Defaults.window.font)
    self.badge:SetForeColor(Options.Defaults.window.textdark)
    self.badge:SetText(truncate(trigData.token))
    self.badge:SetMouseVisible(false)

    self.toggle = Turbine.UI.Control()
    self.toggle:SetParent(self)
    self.toggle:SetSize(TOG_S, TOG_S)
    self.toggle:SetTop(math.floor((H - TOG_S) / 2))
    self.toggle:SetMouseVisible(true)
    self.toggle:SetBackColor(trigData.enabled == true and COL_ON or COL_OFF)
    self.toggle.MouseClick = function()
        trigData.enabled = not trigData.enabled
        self.toggle:SetBackColor(trigData.enabled and COL_ON or COL_OFF)
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

function Options2NavTrigger:SizeChanged()
    if self.label == nil then return end
    local w  = self:GetWidth()
    local cx = STRIPE + self.depth * INDENT
    self.label:SetWidth(w - cx - ARROW_W - BADGE_W - TOG_W - 2)
    self.badge:SetPosition(w - BADGE_W - TOG_W - 2, 0)
    self.badge:SetWidth(BADGE_W)
    self.toggle:SetLeft(w - TOG_S - 4)
end

function Options2NavTrigger:SetSelected(v)
    self.selected = v
    self:SetBackColor(v and Options.Defaults.window.w_window_select or nil)
end

function Options2NavTrigger:GetKey()       return self.key end
function Options2NavTrigger:IsExpandable() return false end
function Options2NavTrigger:SetExpanded(v) end
