Options2.Elements.Tooltip = class(Turbine.UI.Window)
function Options2.Elements.Tooltip:Constructor()
    Turbine.UI.Window.Constructor(self)

    self.delay = nil

    self:SetMouseVisible(false)
    self:SetBackColor(Options.Defaults.tooltip.backcolor1)
    self:SetZOrder(200)
    self:SetVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetPosition(Options.Defaults.tooltip.frame, Options.Defaults.tooltip.frame)
    self.background:SetBackColor(Options.Defaults.tooltip.backcolor2)
    self.background:SetMouseVisible(false)

    self.text = Turbine.UI.Label()
    self.text:SetParent(self.background)
    self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.text:SetFont(Options.Defaults.tooltip.font)
    self.text:SetMouseVisible(false)
end

function Options2.Elements.Tooltip:Show(left, top, text_control, text_description)
    local text = UTILS.GetText(text_control, text_description)

    self.text:SetText(text)
    local child_height = (math.floor(string.len(text) / 35) + 2) * 14
    local child_width  = Options.Defaults.tooltip.width - (2 * Options.Defaults.tooltip.frame)
    local height       = child_height + (2 * Options.Defaults.tooltip.frame)

    self:SetPosition(left, top)
    self:SetSize(Options.Defaults.tooltip.width, height)
    self.background:SetSize(child_width, child_height)
    self.text:SetSize(child_width, child_height)

    self.delay = Turbine.Engine.GetGameTime() + Options.Defaults.tooltip.activation_delay
    self:SetWantsUpdates(true)
end

function Options2.Elements.Tooltip:Update()
    if self.delay ~= nil and self.delay <= Turbine.Engine.GetGameTime() then
        self:SetWantsUpdates(false)
        self:SetVisible(true)
    end
end

function Options2.Elements.Tooltip:Hide()
    self:SetWantsUpdates(false)
    self:SetVisible(false)
end

function Options2.Elements.Tooltip.AddTooltip(control, text_control, text_description, always)
    control.MouseEnter = function()
        if always == true or Data.showTooltips == true then
            local left, top = control:PointToScreen(
                (control:GetWidth() / -2) - Options.Defaults.tooltip.left_shift,
                Options.Defaults.tooltip.top_shift)
            if Options2.Elements.TooltipObject ~= nil then
                Options2.Elements.TooltipObject:Show(left, top, text_control, text_description)
            end
        end
    end
    control.MouseLeave = function()
        if Options2.Elements.TooltipObject ~= nil then
            Options2.Elements.TooltipObject:Hide()
        end
    end
end
