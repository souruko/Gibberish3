--===================================================================================
--             Name:    OPTIONS WINDOW
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================

Options.Constructor.ShortcutButton = class(Turbine.UI.Window)






-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.Constructor.ShortcutButton:Constructor()
	Turbine.UI.Window.Constructor( self )

    self.menu_width = 125
    self.menu_height = 154
    self.size = 50

    self:SetSize(self.size, self.size)
    self:LoadIcon()
    self:SetPosition( Utils.ScreenRatioToPixel( Data.options.shortcut.left, Data.options.shortcut.top ) ) 

    self.MouseDown = function (sender, args)
        
        if Data.options.shortcut.moveable == true then

            Dragging = true
            DragStartX = args.X
            DragStartY = args.Y

        end

    end
    self.MouseMove = function (sender, args)

        if Dragging == true then
            
            local x, y = self:GetPosition()

			x = x + ( args.X - DragStartX )
            y = y + ( args.Y - DragStartY )

            if x > ScreenWidth then
                x = ScreenWidth
            elseif 0 > x then
                x = 0
            end
            
            if y > ScreenHeight then
                y = ScreenHeight
            elseif 0 > y then
                y = 0
            end

            self:SetPosition( x, y )

            Data.options.shortcut.left, Data.options.shortcut.top = Utils.PixelToScreenRatio( x, y )

        end

    end
    self.MouseUp = function (sender, args)

        if Dragging == true then

            Dragging = false
            Options.SaveData()

        end

    end

    self.rightClickMenu = Options.Constructor.RightClickMenu(self.menu_width)
    self.rightClickMenu:AddRow( L[Language.Local].Menu.Reset, function ()
        Group.Reset()
    end)
    self.rightClickMenu:AddRow( L[Language.Local].Menu.Reload, function ()
        Options.Reload()
    end)
    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Options, function ()
        Options.MainWindow.OpenClose()
    end)
    self.rightClickMenu:AddRow( L[Language.Local].Menu.Collection, function ()

    end)
    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.MoveWindows, function ()
        Options.Move.UpdateMode(not(Data.moveMode), true)
    end)

    self.MouseClick = function (sender, args)

        if args.Button == Turbine.UI.MouseButton.Right then

            local left, top = self:CalcMenuPos()
            
            self.rightClickMenu:Show(left, top, true)

        end

    end


    self:SetVisible(true)

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.Constructor.ShortcutButton:LoadIcon()

    self:SetBackground("Gibberish3/RESOURCES/gibberish_new_icon.tga")

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.Constructor.ShortcutButton:CalcMenuPos()

    local left, top = self:GetPosition()

    if left > (ScreenWidth/2) then
        left = left - self.menu_width
    else
        left = left + self.size
    end

    if top > (ScreenHeight/2) then
        top = top - self.menu_height
    else
        top = top + self.size
    end

    return left, top

end