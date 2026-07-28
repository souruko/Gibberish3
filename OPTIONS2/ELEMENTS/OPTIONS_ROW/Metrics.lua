-- Shared metrics and chrome for the editor's setting rows.
-- Per SPEC-metrics "Column 3 — Editor".
--
-- Lives on Options2.Elements so every package can reach it: a bare global
-- assigned here would only be visible inside OPTIONS_ROW/.

Options2.Elements.EditorRow = {}
local M = Options2.Elements.EditorRow

M.ROW_H       = 28          -- 40 when the control is a multiline box
M.ROW_H_MULTI = 40
M.LABEL_W     = 104
M.LABEL_GAP   = 10
M.CTRL_LEFT   = M.LABEL_W + M.LABEL_GAP
M.CTRL_H      = 22
M.PAD         = 10          -- editor content padding
M.ROW_GAP     = 2
M.NUM_W       = 64
M.DROP_W      = 140
M.CHECK       = 15
M.RIGHT_PAD   = 10

M.FONT_LABEL = Turbine.UI.Lotro.Font.Verdana12
M.FONT_FIELD = Turbine.UI.Lotro.Font.Verdana12

-- 104px right-aligned label in text_muted
function M.MakeLabel(row, tooltip_description)
    local label = Turbine.UI.Label()
    label:SetParent(row)
    label:SetPosition(0, 0)
    label:SetWidth(M.LABEL_W)
    label:SetFont(M.FONT_LABEL)
    label:SetForeColor(Options.Defaults.window.text_muted)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    if tooltip_description ~= nil then
        Options2.Elements.Tooltip.AddTooltip(label, "tooltip", tooltip_description, false)
    end
    return label
end

-- A sunken field with a 1px border, built from a plain TextBox rather than
-- Turbine.UI.Lotro.TextBox: the Lotro one draws its own ornate chrome, which
-- cannot be restyled.
-- Returns the frame (position/size this) and the textbox inside it.
function M.MakeField(row, multiline)
    local frame = Turbine.UI.Control()
    frame:SetParent(row)
    frame:SetBackColor(Options.Defaults.window.line)
    frame:SetMouseVisible(false)

    local box = Turbine.UI.TextBox()
    box:SetParent(frame)
    box:SetPosition(1, 1)
    box:SetBackColor(Options.Defaults.window.bg_sunken)
    box:SetForeColor(Options.Defaults.window.text)
    box:SetFont(M.FONT_FIELD)
    box:SetSelectable(true)
    box:SetMultiline(multiline == true)
    box:SetMarkupEnabled(false)
    if multiline ~= true then
        box:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    else
        box:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    end

    frame.box = box
    function frame:Layout(left, top, w, h)
        self:SetPosition(left, top)
        self:SetSize(w, h)
        box:SetSize(math.max(0, w - 2), math.max(0, h - 2))
    end

    return frame
end

-- vertical offset that centres a control of this height in the row
function M.CentreTop(row_h, ctrl_h)
    return math.floor((row_h - ctrl_h) / 2)
end

-- alternating row fills, applied by the editors as they stack rows
function M.Fill(index)
    if index % 2 == 1 then
        return Options.Defaults.window.row_odd
    end
    return Options.Defaults.window.row_even
end
