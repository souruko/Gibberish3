--===================================================================================
--             Name:    LISTBOX Element
-------------------------------------------------------------------------------------
--      Description:    LISTBOX Class
--===================================================================================
ListBoxElement = class(Turbine.UI.Window)






-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
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
    self.MoveWindow:SetZOrder               ( 5 )

    local moveFrame = 2
    self.MoveLabel = Turbine.UI.Label       ( )
    self.MoveLabel:SetParent                ( self.MoveWindow )
    self.MoveLabel:SetMouseVisible          ( false )
    self.MoveLabel:SetTextAlignment         ( Turbine.UI.ContentAlignment.MiddleCenter )
    self.MoveLabel:SetFont                  ( Turbine.UI.Lotro.Font.Verdana12 )
    self.MoveLabel:SetFontStyle             ( Turbine.UI.FontStyle.Outline )
    self.MoveLabel:SetPosition              ( moveFrame, moveFrame )
    self.MoveLabel:SetZOrder               ( 4 )

    self.TimerListBox = Turbine.UI.ListBox  ( )
    self.TimerListBox:SetParent             ( self )
    self.TimerListBox:SetMouseVisible       ( false )
    self.TimerListBox:SetZOrder               ( 3 )


-------------------------------------------------------------------------------------
--  move

    function self.MoveWindow.MouseDown  ( sender, args )

        if args.Button == Turbine.UI.MouseButton.Left then

            Dragging = true
            DragStartX = args.X
            DragStartY = args.Y

            
            Data.selectedGroupIndex = {}
            Data.selectedFolderIndex = {}
            
            Data.selectedGroupIndex[1] = self.index
            
            Options.SelectionChanged()
            
        end
        
    end 

    function self.MoveWindow.MouseMove  ( sender, args )

        if Dragging == true then
            
            local x, y = self:GetPosition()

			x = x + ( args.X - DragStartX )
            y = y + ( args.Y - DragStartY )

            self:SetPosition( x, y )

            self.data.left, self.data.top = Utils.PixelToScreenRatio( x, y )

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

    self:FillPermanentTimers()

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
function ListBoxElement:Add(groupData, timerData, timerIndex, startTime, duration, icon, text, entity, key)

    local child = self:CheckRunningTimer(timerIndex, key)
    local activ = true

    if child then
    
        child:UpdateTimer( startTime, duration, icon, text, entity, key, activ )

    else

        local index = #self.children + 1
        
        self.children[index] = Timer.Constructor[timerData.type](self, groupData, timerData, timerIndex, startTime, duration, icon, text, entity, key, activ)
        self.TimerListBox:AddItem(self.children[index])

    end

    self:SortList()

end


-------------------------------------------------------------------------------------
--      Description:    remove call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    timer index
--                      key
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:SortList()

    self.TimerListBox:Sort(

        function (child1, child2)

            if child1.timerData.permanent == true then

                if child2.timerData.permanent == true then

                    if child1.index < child2.index then         -- both permanent sort by index
                        return true

                    else
                        return false

                    end

                else                                            -- only 1 permanent sort by that
                    return true

                end

            else

                if child2.timerData.permanent == true then      -- only 1 permanent sort by that
                    return false

                else
                    if child1.endTime < child2.endTime then     -- both not permanent sort by endTime
                        return true

                    else
                        return false

                    end
                end

            end

        end

    )

end



-------------------------------------------------------------------------------------
--      Description:    remove call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    timer index
--                      key
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:Remove(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    for i = #self.children, 1, -1 do

        if self.children[i].index == timerIndex then

            if key == nil or self.children[i].key == key then

                self.children[i]:Remove()

            end

        end

    end

end




-------------------------------------------------------------------------------------
--      Description:    add call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    trigger data 
--                      timer index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:CheckRunningTimer(timerIndex, key)

    for index, child in pairs(self.children) do

        if child.index == timerIndex and child.key == key then

            return child
            
        end
        
    end

    return nil

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
        self.MoveWindow:SetBackColor     ( Defaults.Colors.Selected )
        self.MoveLabel:SetBackColor      ( Defaults.Colors.BackgroundColor1 )

        if Data.moveMode == true then
            self:SetZOrder              (11)

        elseif self.data.overlay == true then
            self:SetZOrder              (1)
        
        else
            self:SetZOrder              (nil)

        end

    else

        self.selected = false
        self.MoveWindow:SetBackColor     ( Defaults.Colors.NotSelected )
        self.MoveLabel:SetBackColor     ( Defaults.Colors.BackgroundColor1 )
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

    if self.data.orientation == Orientation.Horizontal then

        width   = childrenCount * ( self.data.height + ( 2 * self.data.frame ) ) + ( ( childrenCount - 1) * self.data.spacing )
        height  = self.data.width + ( 2 * self.data.frame )

    else

        width   = self.data.width + ( 2 * self.data.frame )
        height  = childrenCount * ( self.data.height + ( 2 * self.data.frame ) ) + ( ( childrenCount - 1) * self.data.spacing )

    end

    local moveFrame = 2
    self:SetSize                ( width, height )
    self.MoveWindow:SetSize     ( width, height )
    self.MoveLabel:SetSize      ( width - 2 * moveFrame, height - 2 * moveFrame )
    self.TimerListBox:SetSize   ( width, height )

end




-------------------------------------------------------------------------------------
--      Description:    remove child
-------------------------------------------------------------------------------------
--        Parameter:    child
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function ListBoxElement:RemoveChild( child )

    local index = self:FindChildIndex( child )

    if index ~= nil then

        self.children[index] = self.children[#self.children]
        self.children[#self.children] = nil

    end

    self.TimerListBox:RemoveItem(child)

end




-------------------------------------------------------------------------------------
--      Description:    get index of a child
-------------------------------------------------------------------------------------
--        Parameter:    child
-------------------------------------------------------------------------------------
--           Return:    index
-------------------------------------------------------------------------------------
function ListBoxElement:FindChildIndex(child)

    for index, control in ipairs(self.children) do

        if child == control then

            return index

        end

    end

    return nil

end



-------------------------------------------------------------------------------------
--      Description:    fill permanent timers
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function ListBoxElement:FillPermanentTimers()

    for i, child in pairs(self.children) do                 -- kill all permanent children!

        if child.timerData.permanent == true then
            child:Finish()
        end

    end

    for j, timerData in ipairs(self.data.timerList) do

        if timerData.permanent == true then

            local index = #self.children + 1

            self.children[index] = Timer.Constructor[timerData.type](self, self.data, timerData, j, 0, 10, timerData.icon, "", nil, nil, false)
            self.TimerListBox:AddItem(self.children[index])

        end

    end

    self:SortList()

end




-------------------------------------------------------------------------------------
--      Description:    close the group
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function ListBoxElement:Finish()

    for key, child in pairs(self.children) do
        
        child:Finish()

    end

    self.MoveLabel:Close()
    self.MoveWindow:Close()
    self.TimerListBox:Close()
    self:Close()

end