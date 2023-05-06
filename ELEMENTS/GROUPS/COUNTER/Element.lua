--===================================================================================
--             Name:    COUNTER Element
-------------------------------------------------------------------------------------
--      Description:    COUNTER Class
--===================================================================================
CounterElement = class(Turbine.UI.Window)





-------------------------------------------------------------------------------------
--      Description:    template constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group template element
-------------------------------------------------------------------------------------
function CounterElement:Constructor( index, data )
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

	self:SetVisible                         ( true )


end



-------------------------------------------------------------------------------------
--      Description:    add call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    timer data 
--                      key
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:Add(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    local child = self:CheckRunningTimer(timerIndex, key)

    if child == nil then
        return
    end

    local activ = true

	if groupData.counterDirection == Direction.Descending then

        counter = -1

        child:UpdateTimer( startTime, counter, icon, text, entity, key, activ )
	
	else

        counter = 1

        child:UpdateTimer( startTime, counter, icon, text, entity, key, activ )

	end

end



-------------------------------------------------------------------------------------
--      Description:    remove call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    groupData
--						timerData 
--    					trigger data 
--                      timer index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:Remove(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    local child = self:CheckRunningTimer(timerIndex, key)

    if child == nil then
        return
    end

    local activ = true

	if groupData.counterDirection == Direction.Descending then

        counter = 1

        child:UpdateTimer( startTime, counter, icon, text, entity, key, activ )
	
	else

        counter = -1

        child:UpdateTimer( startTime, counter, icon, text, entity, key, activ )

	end

end


-------------------------------------------------------------------------------------
--      Description:    reset action from trigger from triggers
-------------------------------------------------------------------------------------
--        Parameter:    groupData
--						timerData 
--						timer index
--                      key
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:ResetAction(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    local child = self:CheckRunningTimer(timerIndex, key)

    if child ~= nil then
        child:Finish()
    end

    local index = #self.children + 1
    local activ = true

        
    self.children[index] = Timer.Constructor[timerData.type](self, groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key, activ)
    self.TimerListBox:AddItem(self.children[index])

    self:SortList()

end


-------------------------------------------------------------------------------------
--      Description:    sort children
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:SortList()

	self.TimerListBox:Sort(

		function (child1, child2)

			if child1.index < child2.index then         -- sort by index
				return true

			else
				return false

			end

		end

	)

end




-------------------------------------------------------------------------------------
--      Description:    reset all timers event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:Reset()

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
function CounterElement:SelectionChanged()

	if Data.selectedGroupIndex == self.index then
        
        self.selected = true
        self.MoveWindow:SetBackColor     ( Defaults.Colors.Selected )
        self.MoveLabel:SetBackColor      ( Turbine.UI.Color.Black )

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
function CounterElement:MoveChanged()

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
function CounterElement:GroupDataChanged()

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
function CounterElement:TimerDataChanged(timerIndex)

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
function CounterElement:ReSize()

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
function CounterElement:RemoveChild( child )

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
function CounterElement:FindChildIndex(child)

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
function CounterElement:FillTimers()

    for i, child in pairs(self.children) do                 -- kill all permanent children!

	  	child:Finish()


    end

    for j, timerData in ipairs(self.data.timerList) do

            local index = #self.children + 1

            self.children[index] = Timer.Constructor[timerData.type](self, self.data, timerData, j, 0, 10, timerData.icon, "", nil, nil, false)
            self.TimerListBox:AddItem(self.children[index])

        end

    self:SortList()

end

-------------------------------------------------------------------------------------
--      Description:    close group
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:Finish()

    for key, child in pairs(self.children) do
        
        child:Finish()

    end

    self.MoveLabel:Close()
    self.MoveWindow:Close()
    self.TimerListBox:Close()
    self:Close()

end



-------------------------------------------------------------------------------------
--      Description:    add call from triggers
-------------------------------------------------------------------------------------
--        Parameter:    trigger data 
--                      timer index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterElement:CheckRunningTimer(timerIndex, key)

    for index, child in pairs(self.children) do

        if child.index == timerIndex and child.key == key then

            return child
            
        end
        
    end

    return nil

end
