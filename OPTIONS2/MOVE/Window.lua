--=================================================================================================
--= Move window
--=
--= The drag-to-move overlay's control panel. Built on Options2.Elements.PanelWindow so it
--= wears the same frameless chrome as the options panel: 1px border, 30px title bar carrying
--= the selected window's name, close button. No Turbine.UI.Lotro widget is used — the Lotro
--= text box and button draw their own ornate chrome, which cannot be restyled.
--=================================================================================================

local PAD      = 10
local ROW_H    = 22
local LABEL_W  = 44
local GAP      = 6
local BTN_H    = 22
local PAD_BTN  = 24         -- the four arrow buttons are square
local PAD_ICON = 16         -- chevron glyphs, drawn at their native size

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    ROW_H   = F.Px(22)
    LABEL_W = F.Px(44)
    BTN_H   = F.Px(22)
end)

local ARROW = {
    up    = "Gibberish3/RESOURCES/chevron_up.tga",
    down  = "Gibberish3/RESOURCES/chevron_down.tga",
    left  = "Gibberish3/RESOURCES/chevron_left.tga",
    right = "Gibberish3/RESOURCES/chevron_right.tga",
}

-- a bordered pill, matching the editor's Save / Revert buttons
local function make_pill(parent, border, fg, click_fn, tooltip)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H)
    btn:SetBackColor(border)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetBackColor(Options.Defaults.window.bg_sunken)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(Options2.Fonts.BODY)
    label:SetForeColor(fg)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    Options2.Elements.Tooltip.AddTooltip(btn, "tooltip", tooltip, false)
    local tip_enter, tip_leave = btn.MouseEnter, btn.MouseLeave
    btn.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        fill:SetBackColor(Options.Defaults.window.select)
    end
    btn.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        fill:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    btn.MouseClick = click_fn

    btn._label = label
    function btn:SetLabel(text) label:SetText(text) end
    function btn:Layout(left, top, w)
        self:SetPosition(left, top)
        self:SetWidth(w)
        fill:SetSize(math.max(0, w - 2), BTN_H - 2)
        label:SetSize(math.max(0, w - 2), BTN_H - 2)
    end

    return btn
end

-- one square of the D-pad. The glyph is a 16px .tga drawn at its native size
-- and Overlay-blended; stretching it or blending it any other way makes it
-- vanish (see CLAUDE.md, UI gotchas).
local function make_arrow(parent, path, down_fn, up_fn, click_fn, tooltip)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetSize(PAD_BTN, PAD_BTN)
    btn:SetBackColor(Options.Defaults.window.select)
    btn:SetMouseVisible(true)

    local icon = Turbine.UI.Control()
    icon:SetParent(btn)
    icon:SetSize(PAD_ICON, PAD_ICON)
    icon:SetPosition(math.floor((PAD_BTN - PAD_ICON) / 2),
                     math.floor((PAD_BTN - PAD_ICON) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(path)
    icon:SetMouseVisible(false)

    Options2.Elements.Tooltip.AddTooltip(btn, "tooltip", tooltip, false)
    local tip_enter, tip_leave = btn.MouseEnter, btn.MouseLeave
    btn.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        btn:SetBackColor(Options.Defaults.window.line)
    end
    btn.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        btn:SetBackColor(Options.Defaults.window.select)
    end
    btn.MouseDown  = down_fn
    btn.MouseUp    = up_fn
    btn.MouseClick = click_fn

    btn.icon = icon
    return btn
end

Options.Move = {}
Options.Move.Constructor = class(Options2.Elements.PanelWindow)
---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:Constructor()
    Options2.Elements.PanelWindow.Constructor(self, {
        resizable  = false,
        min_width  = Options.Defaults.move.width,
        min_height = Options.Defaults.move.height,
    })

    self:SetSize( Options.Defaults.move.width,  Options.Defaults.move.height )
    self:SetPosition( 0, ( ( Options.ScreenHeight - Options.Defaults.move.height ) / 2 ) )
    self:SetZOrder(1)

    local M = Options2.Elements.EditorRow

    -- left value of the selected window
    self.left_label = Turbine.UI.Label()
    self.left_label:SetParent( self.client )
    self.left_label:SetSize( LABEL_W, ROW_H )
    self.left_label:SetFont( M.FONT_LABEL )
    self.left_label:SetForeColor( Options.Defaults.window.text_muted )
    self.left_label:SetTextAlignment( Options.Defaults.move.labelalignment )

    self.left_field   = M.MakeField( self.client, false )
    self.left_textbox = self.left_field.box

    -- top value of the selected window
    self.top_label = Turbine.UI.Label()
    self.top_label:SetParent( self.client )
    self.top_label:SetSize( LABEL_W, ROW_H )
    self.top_label:SetFont( M.FONT_LABEL )
    self.top_label:SetForeColor( Options.Defaults.window.text_muted )
    self.top_label:SetTextAlignment( Options.Defaults.move.labelalignment )

    self.top_field   = M.MakeField( self.client, false )
    self.top_textbox = self.top_field.box

    -- update changes
    self.update_button = make_pill( self.client,
        Options.Defaults.window.accent, Options.Defaults.window.accent,
        function() self:UpdateClicked() end, "o2_move_update" )

    -- move selected window 1 pixel per buttonpress, repeating while held
    self.up_button = make_arrow( self.client, ARROW.up,
        function() self:ArrowDown( 0, -1 ) end,
        function() self:ArrowUp() end,
        function() self:ArrowClicked( 0, -1 ) end, "o2_move_up" )

    self.left_button = make_arrow( self.client, ARROW.left,
        function() self:ArrowDown( -1, 0 ) end,
        function() self:ArrowUp() end,
        function() self:ArrowClicked( -1, 0 ) end, "o2_move_left" )

    self.right_button = make_arrow( self.client, ARROW.right,
        function() self:ArrowDown( 1, 0 ) end,
        function() self:ArrowUp() end,
        function() self:ArrowClicked( 1, 0 ) end, "o2_move_right" )

    self.down_button = make_arrow( self.client, ARROW.down,
        function() self:ArrowDown( 0, 1 ) end,
        function() self:ArrowUp() end,
        function() self:ArrowClicked( 0, 1 ) end, "o2_move_down" )

    -- end movemode
    self.close_button = make_pill( self.client,
        Options.Defaults.window.line, Options.Defaults.window.text_muted,
        function() Options.MoveChanged( false ) end, "o2_move_close" )

    -- screen-centre guides, drawn over the game world
    self.x_line = Turbine.UI.Window()
    self.x_line:SetSize( Options.ScreenWidth, 4 )
    self.x_line:SetBackColor( Options.Defaults.move.guide )
    self.x_line:SetPosition( 0, (Options.ScreenHeight/2) - 2)
    self.x_line:SetVisible(true)
    self.x_line:SetMouseVisible(false)

    self.x_fill = Turbine.UI.Control()
    self.x_fill:SetParent(self.x_line)
    self.x_fill:SetSize( Options.ScreenWidth, 2 )
    self.x_fill:SetBackColor( Options.Defaults.move.guide_core )
    self.x_fill:SetPosition( 0, 1)
    self.x_fill:SetMouseVisible(false)

    self.y_line = Turbine.UI.Window()
    self.y_line:SetSize( 4,Options.ScreenHeight )
    self.y_line:SetBackColor( Options.Defaults.move.guide )
    self.y_line:SetPosition( (Options.ScreenWidth/2) - 2, 0)
    self.y_line:SetVisible(true)
    self.y_line:SetMouseVisible(false)

    self.y_fill = Turbine.UI.Control()
    self.y_fill:SetParent(self.y_line)
    self.y_fill:SetSize( 2 , Options.ScreenHeight )
    self.y_fill:SetBackColor( Options.Defaults.move.guide_core )
    self.y_fill:SetPosition( 1, 0 )
    self.y_fill:SetMouseVisible(false)

    self:SizeChanged()
    self:LanguageChanged()
    self:SelectionChanged()
    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- laid out by PanelWindow whenever the window resizes
---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:OnLayout( w, h )

    if self.left_label == nil then
        return
    end

    local field_left  = PAD + LABEL_W + GAP
    local field_width = math.max( 0, w - field_left - PAD )
    local y           = PAD

    self.left_label:SetPosition( PAD, y )
    self.left_field:Layout( field_left, y, field_width, ROW_H )
    y = y + ROW_H + GAP

    self.top_label:SetPosition( PAD, y )
    self.top_field:Layout( field_left, y, field_width, ROW_H )
    y = y + ROW_H + PAD

    self.update_button:Layout( PAD, y, math.max( 0, w - 2 * PAD ) )
    y = y + BTN_H + PAD

    -- D-pad, centred
    local cx = math.floor( ( w - PAD_BTN ) / 2 )
    self.up_button:SetPosition( cx, y )
    self.left_button:SetPosition( cx - PAD_BTN - GAP, y + PAD_BTN + GAP )
    self.right_button:SetPosition( cx + PAD_BTN + GAP, y + PAD_BTN + GAP )
    self.down_button:SetPosition( cx, y + 2 * ( PAD_BTN + GAP ) )

    -- close sits on the bottom edge
    self.close_button:Layout( PAD, h - PAD - BTN_H, math.max( 0, w - 2 * PAD ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- the title bar's close button ends move mode rather than just hiding
---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:CloseWindow()

    Options.MoveChanged( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:SelectionChanged()

    if Data.selectedIndex > 0 and Data.window[ Data.selectedIndex ] then

        local selected  = Data.window[ Data.selectedIndex ]
        local left, top = UTILS.ScreenRatioToPixel( selected.left, selected.top)

        self:SetTitleText( selected.name )
        self.left_textbox:SetText( tostring(left) )
        self.top_textbox:SetText( tostring(top) )

    else
        self:SetTitleText( UTILS.GetText( "move", "no_selection" ) )
        self.left_textbox:SetText( "" )
        self.top_textbox:SetText( "" )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:UpdateClicked()

    -- convert text to number
    local left = tonumber( self.left_textbox:GetText() )
    local top  = tonumber( self.top_textbox:GetText() )

    -- check
    if left == nil or top == nil then
        return
    end

    self:UpdateChanges( left, top )
    Options.SaveData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:ArrowClicked( left_value, top_value )

    if Data.selectedIndex ~= 0 then

        -- selected data
        local selected  = Data.window[ Data.selectedIndex ]
        local left, top = UTILS.ScreenRatioToPixel( selected.left, selected.top)

        left = left + left_value
        top  = top + top_value

        self:UpdateChanges( left, top )
        self:SelectionChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:ArrowDown( left_value, top_value )

    self.left_value = left_value
    self.top_value  = top_value
    self.next      = Turbine.Engine.GetGameTime() + 0.5

    self:SetWantsUpdates( true )

end
------------n---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:ArrowUp()

    self:SetWantsUpdates( false )
    Options.SaveData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:Update()

    local time = Turbine.Engine.GetGameTime()

    if Data.selectedIndex ~= 0 and time > self.next  then

        self:ArrowClicked( self.left_value, self.top_value )

        self.next = time + 0.01

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:UpdateChanges( left, top )

    if Data.selectedIndex ~= 0 then

        -- selected data
        local selected  = Data.window[ Data.selectedIndex ]

        -- clamp to screen bounds, using the window's actual size where available
        local width, height = 20, 20
        if Windows[ Data.selectedIndex ] ~= nil then
            width, height = Windows[ Data.selectedIndex ]:GetSize()
        end

        if left < 0 then
            left = 0
        end
        if top < 0 then
            top = 0
        end
        if left > Options.ScreenWidth - width then
           left =  Options.ScreenWidth - width
        end
        if top > Options.ScreenHeight - height then
            top = Options.ScreenHeight - height
        end

        -- update data
        selected.left,  selected.top = UTILS.PixelToScreenRatio( left, top )

        -- update window
        Windows.DataChanged( Data.selectedIndex )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:LanguageChanged()

    self.left_label:SetText( UTILS.GetText( "move", "left"))
    self.top_label:SetText( UTILS.GetText( "move", "top"))
    self.update_button:SetLabel( UTILS.GetText( "move", "update"))
    self.close_button:SetLabel( UTILS.GetText( "move", "close"))

    self:SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:Closing()

    self.x_line:Close()
    self.y_line:Close()

end
---------------------------------------------------------------------------------------------------
