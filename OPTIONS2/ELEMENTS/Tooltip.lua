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

    -- Around 26 characters fit on a line at the box's fixed width, but whole
    -- words are never split, so 23 is what a line reliably holds. A line break
    -- starts a new line whatever is left of the old one, so the lines are
    -- counted one break-separated piece at a time: measuring the whole string
    -- instead loses a line for every break in it, which is what used to cut the
    -- longer tooltips off at the bottom. One spare line covers an awkward wrap.
    local lines = 0

    for segment in string.gmatch(text .. "\n", "([^\n]*)\n") do
        lines = lines + math.max(1, math.ceil(string.len(segment) / 23))
    end

    -- only the line height follows the panel's font size; the box keeps its width
    local child_height = (lines + 1) * Options2.Fonts.Px(14)
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
