--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



Options.Shortcut = {}
Options.Shortcut.Constructor = class(Turbine.UI.Window)
---------------------------------------------------------------------------------------------------
function Options.Shortcut.Constructor:Constructor()
	Turbine.UI.Window.Constructor( self )

    -- set self
    self:SetSize( Options.Defaults.shortcut.size, Options.Defaults.shortcut.size )
    self:SetPosition( UTILS.ScreenRatioToPixel( Data.options.shortcut.left, Data.options.shortcut.top ) )
    self:SetBackground("Gibberish3/RESOURCES/gibberish_new_icon.tga")

    -- mouse interaction
    self.dragging = false
    self.dragStartX = 0
    self.dragStartY = 0

    self.MouseDown = function (sender, args)

        -- only allow move with leftclick and movemode
        if args.Button == Turbine.UI.MouseButton.Left and Data.moveMode == true then

            -- set state to dragging and save start positions
            self.dragging = true
            self.dragStartX = args.X
            self.dragStartY = args.Y

        end

    end

    self.MouseMove = function (sender, args)

        if self.dragging == true then
            
            local x, y = self:GetPosition()
            
            -- calculate the new position
			x = x + ( args.X - self.dragStartX )
            y = y + ( args.Y - self.dragStartY )

            -- set new position
            self:SetPosition( x, y )

        end

    end

    self.MouseUp = function (sender, args)

        if args.Button == Turbine.UI.MouseButton.Left then
            
            -- stop dragging
            self.dragging = false

            Data.options.shortcut.left, Data.options.shortcut.top = UTILS.PixelToScreenRatio( self:GetPosition() )

            Options.SaveData()

        end

    end

    self.MouseClick = function (sender, args)

        if args.Button == Turbine.UI.MouseButton.Right then

            self.rightClickMenu:Show( self:GetMenuPos() )

        end

    end

    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.shortcut.menu_width )
    self.rightClickMenu:AddItem( UTILS.GetText( "shortcut", "reset"), nil)
    self.rightClickMenu:AddItem( UTILS.GetText( "shortcut", "reload"), nil)
    self.rightClickMenu:AddItem( UTILS.GetText( "shortcut", "options"), nil)
    self.rightClickMenu:AddItem( UTILS.GetText( "shortcut", "move"), function ()
        Options.MoveChanged( not( Data.moveMode ) )
    end)

    self.menu_height = self.rightClickMenu.background:GetHeight()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Shortcut.Constructor:GetMenuPos()

    -- get shortcut position
    local left, top = self:GetPosition()
    local orientation = nil

    local horizontal = Options.ScreenWidth  / 2
    local vertical   = Options.ScreenHeight / 2

    if left > horizontal and top > vertical then
        orientation = Turbine.UI.ContentAlignment.BottomRight
        left = left - 1000
        top = top - 1000

    elseif left <= horizontal and top > vertical then
        orientation = Turbine.UI.ContentAlignment.BottomLeft
        left = left + Options.Defaults.shortcut.size
        top = top - 1000

    elseif left <= horizontal and top <= vertical then
        orientation = Turbine.UI.ContentAlignment.TopLeft
        left = left + Options.Defaults.shortcut.size
        top = top + Options.Defaults.shortcut.size

    elseif left > horizontal and top <= vertical then
        orientation = Turbine.UI.ContentAlignment.TopRight
        left = left - 1000
        top = top + Options.Defaults.shortcut.size

    end

    return left, top, orientation

end
---------------------------------------------------------------------------------------------------