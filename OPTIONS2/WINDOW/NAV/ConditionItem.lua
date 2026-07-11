local H = 28
local STRIPE = 4
local INDENT = 12
local ARROW_W = 18
local COLOR_COND = Turbine.UI.Color(0.55, 0.18, 0.75)
local ICON_S  = 10

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

function Options2NavCondition:SizeChanged()
    if self.label == nil then return end
    local w  = self:GetWidth()
    local cx = STRIPE + self.depth * INDENT
    self.label:SetWidth(w - cx - ARROW_W - 2)
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
