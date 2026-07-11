local H = 28
local STRIPE = 4
local INDENT = 12
local ARROW_W = 18
local BADGE_W = 160

local function truncate(s)
    if s == nil or s == "" then return "" end
    if #s <= 24 then return s end
    return s:sub(1, 23) .. "…"
end

Options2NavWindowTrigger = class(Turbine.UI.Control)
function Options2NavWindowTrigger:Constructor(navWin, trigData, trigType, trigIdx, winIdx, key, depth)
    Turbine.UI.Control.Constructor(self)

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 2
    self.nodeData = {
        nodeType     = "windowtrigger",
        key          = key,
        data         = trigData,
        windowIndex  = winIdx,
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

    local win_line_x = STRIPE + (self.depth - 1) * INDENT + math.floor((ARROW_W - 2) / 2)
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

function Options2NavWindowTrigger:SizeChanged()
    if self.label == nil then return end
    local w  = self:GetWidth()
    local cx = STRIPE + self.depth * INDENT
    self.label:SetWidth(w - cx - ARROW_W - BADGE_W - 2)
    self.badge:SetPosition(w - BADGE_W - 2, 0)
    self.badge:SetWidth(BADGE_W)
end

function Options2NavWindowTrigger:SetSelected(v)
    self.selected = v
    self:SetBackColor(v and Options.Defaults.window.w_window_select or nil)
end

function Options2NavWindowTrigger:GetKey()       return self.key end
function Options2NavWindowTrigger:IsExpandable() return false end
function Options2NavWindowTrigger:SetExpanded(v) end
