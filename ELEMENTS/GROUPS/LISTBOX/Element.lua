--===================================================================================
--             Name:    LISTBOX Element
-------------------------------------------------------------------------------------
--      Description:    LISTBOX Class
--===================================================================================
ListBoxElement = class(Turbine.UI.Window)





-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function ListBoxElement:Constructor(index, data)
	Turbine.UI.Window.Constructor( self )


-------------------------------------------------------------------------------------
--  attributes

    self.index      = index
    self.data       = data
    self.children   = {}
    self.selected   = false


-------------------------------------------------------------------------------------
--  construct

    self:SetMouseVisible                    ( false )

    self.MoveWindow = Turbine.UI.Window     ( )
    self.MoveWindow:SetParent               ( self )
    self.MoveWindow:SetMouseVisible         ( false )

    self.MoveLabel = Turbine.UI.Label       ( )
    self.MoveLabel:SetParent                ( self.MoveWindow )
    self.MoveLabel:SetMouseVisible          ( false )
    self.MoveLabel:SetTextAlignment         ( Turbine.UI.ContentAlignment.MiddleCenter )
    self.MoveLabel:SetFont                  ( Turbine.UI.Lotro.Font.Verdana12 )
    self.MoveLabel:SetFontStyle             ( Turbine.UI.FontStyle.Outline )

    self.TimerListBox = Turbine.UI.ListBox  ( )
    self.TimerListBox:SetParent             ( self )
    self.TimerListBox:SetMouseVisible       ( false )


-------------------------------------------------------------------------------------
--  move

    function self.MoveWindow.MouseDown  ( sender, args )

        if args.Button == Turbine.UI.MouseButton.Left then

            Dragging = true
            DragStartX = args.X
            DragStartY = args.Y

            Group.SelectionChanged(self.index)
            
        end
        
    end 

    function self.MoveWindow.MouseMove  ( sender, args )

        if Dragging == true then
            
            local x, y = self:GetPosition()

			x = x + ( args.X - DragStartX )
            y = y + ( args.Y - DragStartY )

            self:SetPosition( x, y )

            self.data.left, self.data.top = Utils.PixelToScreenRatio( x, y )

            Options.SelectedWindowChanged()

        end
        
    end

    function self.MoveWindow.MouseUp    ( sender, args )

        if args.Button == Turbine.UI.MouseButton.Left then
            
            Dragging = false

            self.data.left, self.data.top = Utils.PixelToScreenRatio( self:GetPosition() )

            Options.SaveData()

        end
        
    end


-------------------------------------------------------------------------------------
--  ready

    self:GroupDataChanged                   ( )
    self:SelectionChanged                   ( )
    self:MoveChanged                        ( )

    self:SetVisible                         ( true )

end



-------------------------------------------------------------------------------------
--      Description:    add call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    trigger data 
--                      timer index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:Add(data, timerIndex, startTime, duration, icon, text, entity)

end




-------------------------------------------------------------------------------------
--      Description:    remove call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    trigger data 
--                      timer index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:Remove(data, timer)

end




-------------------------------------------------------------------------------------
--      Description:    reset all timers event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:Reset()

    for i = #self.children, 1, -1 do

        self.children[i]:Reset()
        
    end

end




-------------------------------------------------------------------------------------
--      Description:    selection has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:SelectionChanged()

    if Data.selectedGroupIndex == self.index then
        
        self.selected = true
        self.MoveLabel:SetBackColor     ( Turbine.UI.Color.Orange )
        
        if Data.moveMode == true then
            self:SetZOrder              (11)

        elseif self.data.overlay == true then
            self:SetZOrder              (1)
        
        else
            self:SetZOrder              (nil)

        end

    else

        self.selected = false
        self.MoveLabel:SetBackColor     ( Turbine.UI.Color.Black )
    
        if Data.moveMode == true then
            self:SetZOrder              (10)

        elseif self.data.overlay == true then
            self:SetZOrder              (1)
        
        else
            self:SetZOrder              (nil)

        end

    end

end




-------------------------------------------------------------------------------------
--      Description:    move mode has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:MoveChanged()

    self.MoveWindow:SetVisible      (Data.moveMode)
    self.MoveWindow:SetMouseVisible (Data.moveMode)

    self:SelectionChanged()

end




-------------------------------------------------------------------------------------
--      Description:    group data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:GroupDataChanged()

    self:SetPosition( Utils.ScreenRatioToPixel( self.data.left, self.data.top ) )

    self:ReSize()

    self.TimerListBox:SetReverseFill    (self.data.direction)
    self.TimerListBox:SetFlippedLayout  (self.data.direction)

    for key, child in pairs(self.children) do
        child:GroupDataChanged()
    end

    self.MoveLabel:SetText(self.data.name)

end




-------------------------------------------------------------------------------------
--      Description:    timer data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:TimerDataChanged(timerIndex)

    for key, child in pairs(self.children) do

        if child.index == timerIndex then
            child:TimerDataChanged()
        end

    end

end




-------------------------------------------------------------------------------------
--      Description:    fix size relativ to the amout of children
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:ReSize()

    local childrenCount = self.TimerListBox:GetItemCount() + 1

    if childrenCount == 0 then
        childrenCount = 1
    end

    local width
    local height

    if self.data.orientation == Orientation.Vertical then

        width   = childrenCount * ( self.data.height + ( 2 * self.data.frame ) ) + ( ( childrenCount - 1) * self.data.spacing )
        height  = self.data.width + ( 2 * self.data.frame )

    else

        width   = self.data.width + ( 2 * self.data.frame )
        height  = childrenCount * ( self.data.height + ( 2 * self.data.frame ) ) + ( ( childrenCount - 1) * self.data.spacing )

    end

    self:SetSize                ( width, height )
    self.MoveWindow:SetSize     ( width, height )
    self.MoveLabel:SetSize      ( width, height )
    self.TimerListBox:SetSize   ( width, height )

end