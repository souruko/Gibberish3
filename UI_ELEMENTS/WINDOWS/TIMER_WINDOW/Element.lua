--=================================================================================================
--= ListBox Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
TimerWindowElement = class( Turbine.UI.Window )

-- function table for window constructors
Window[ Window.Types.TIMER_WINDOW ].Constructor = function ( index )

    return TimerWindowElement( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ListBox Constructor
---------------------------------------------------------------------------------------------------
function TimerWindowElement:Constructor( index )
	Turbine.UI.Window.Constructor( self )

    -- window data index
    self.index      = index
    -- window data
    self.data       = Data.window[ self.index ]
    -- timer table
    self.children   = {}


    -- build elements
    self:SetMouseVisible( false )

    self.dragWindow = Turbine.UI.Window()
    self.dragWindow:SetParent( self )
    self.dragWindow:SetMouseVisible( false )
    self.dragWindow:SetZOrder( 5 )

    self.dragLabel = Turbine.UI.Label()
    self.dragLabel:SetParent( self.dragWindow )
    self.dragLabel:SetMouseVisible( false )
    self.dragLabel:SetTextAlignment( Options.Defaults.move.TextAlignment )
    self.dragLabel:SetFont( Options.Defaults.move.Font )
    self.dragLabel:SetFontStyle( Options.Defaults.move.FontStyle )
    self.dragLabel:SetPosition( Options.Defaults.move.FrameSize, Options.Defaults.move.FrameSize )
    self.dragLabel:SetZOrder( 4 )

    self.timerListBox = Turbine.UI.ListBox()
    self.timerListBox:SetParent( self )
    self.timerListBox:SetMouseVisible( false )
    self.timerListBox:SetZOrder( 3 )

    -- move functions
    self.dragging = false
    self.dragStartX = 0
    self.dragStartY = 0
    
    self.dragWindow.MouseDown = function (sender, args)

        -- only allow move with leftclick
        if args.Button == Turbine.UI.MouseButton.Left then

            -- set state to dragging and save start positions
            self.dragging = true
            self.dragStartX = args.X
            self.dragStartY = args.Y

            Options.SelectionChanged( self.index )

        end

    end

    self.dragWindow.MouseMove = function (sender, args)

        if self.dragging == true then
            
            local x, y = self:GetPosition()
            
            -- calculate the new position
			x = x + ( args.X - self.dragStartX )
            y = y + ( args.Y - self.dragStartY )

            -- set new position
            self:SetPosition( x, y )

            self.data.left, self.data.top = UTILS.PixelToScreenRatio( x, y )
            Options.SelectionMoved()

        end

    end

    self.dragWindow.MouseUp = function (sender, args)

        if args.Button == Turbine.UI.MouseButton.Left then
            
            -- stop dragging
            self.dragging = false
            
            Options.SaveData()

        end

    end

    -- start up

    -- load window settings
    self:DataChanged()

    -- create all permanently displayed timers
    self:FillPermanentChildren()

    -- load selection and move state
    self:SelectionChanged()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] listbox action call from trigger
---------------------------------------------------------------------------------------------------
function TimerWindowElement:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

    -- split the call into the relevant actions
    if triggerData.action == Action.Add then
        self:ActionAdd( timerData, timerIndex, startTime, duration, icon, text, entity, key )

    elseif triggerData.action == Action.Remove then
        self:ActionRemove( timerIndex, key )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] window action call from trigger
---------------------------------------------------------------------------------------------------
function TimerWindowElement:WindowAction( triggerData )

    -- split the call into the relevant actions
    if triggerData.action == Action.Reset then
        self:Reset()

    end
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] selection changed
---------------------------------------------------------------------------------------------------
function TimerWindowElement:SelectionChanged()

    if Data.selectedIndex == self.index then

        -- set colors
        self.dragWindow:SetBackColor( Options.Defaults.move.seleced )
        self.dragLabel:SetBackColor( Options.Defaults.move.sbackground )

    else

        -- set colors
        self.dragWindow:SetBackColor( Options.Defaults.move.notSeleced )
        self.dragLabel:SetBackColor( Options.Defaults.move.nbackground )

    end

    self:MoveChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] move changed
---------------------------------------------------------------------------------------------------
function TimerWindowElement:MoveChanged()

    -- set dragWindow visibility to movemode
    self.dragWindow:SetVisible( Data.moveMode )
    self.dragWindow:SetMouseVisible( Data.moveMode )

    -- moveMode and selected
    if Data.moveMode == true and
       Data.selectedIndex == self.index then

        self:SetZOrder(11)

    -- moveMode and not selected
    elseif Data.moveMode == true then

        self:SetZOrder(10)

    -- overlay 
    elseif self.data.overlay == true then

        self:SetZOrder(1)

    -- default
    else
   
        self:SetZOrder(0)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] data changed
---------------------------------------------------------------------------------------------------
function TimerWindowElement:DataChanged()

    -- window data
    -- get position from screen ratio
    self:SetPosition( UTILS.ScreenRatioToPixel( self.data.left, self.data.top ) )

    -- resize depending from children
    self:Resize()

    -- set the fill direction for children
    self.timerListBox:SetReverseFill    (self.data.direction)
    self.timerListBox:SetFlippedLayout  (self.data.direction)

    -- set dragLabel text to name
    self.dragLabel:SetText( self.data.name )

    -- timer data calls
    for index, child in pairs( self.children ) do
        child:DataChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] listbox reset all timer with  the reset attribute
---------------------------------------------------------------------------------------------------
function TimerWindowElement:Reset()

    -- iterrate from the back because the table can change from resets
    for i = #self.children, 1, -1 do

        self.children[i]:Reset()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] close everything
---------------------------------------------------------------------------------------------------
function TimerWindowElement:Finish()

    -- timer finish call
    for i = #self.children, 1, -1 do

        self.children[i]:Finish()

    end

    self.dragWindow:Close()
    self:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] remove finishing child
---------------------------------------------------------------------------------------------------
function TimerWindowElement:ChildFinished( child )

    -- get child index
    local index = self:GetChildIndex( child )

    if index ~= nil then
        
        -- remove child from table
        self.children[ index ] = self.children[ #self.children ]
        self.children[ #self.children ] = nil

    end

    -- remove child from timerListBox
    self.timerListBox:RemoveItem( child )

    self:Resize()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- listbox add timer
---------------------------------------------------------------------------------------------------
function TimerWindowElement:ActionAdd( timerData, timerIndex, startTime, duration, icon, text, entity, key )

    local child = self:CheckForRunningTimer( timerIndex, key )

    -- create new timer
    if child == nil then

        local index = #self.children + 1
        self.children[ index ] = Timer[ timerData.type ].Constructor( self, timerData, timerIndex, startTime, duration, icon, text, entity, key, true )
        self.timerListBox:AddItem( self.children[ index ] )
        self:Resize()

    -- update running timer
    else

        child:UpdateContent( startTime, duration, icon, text, entity, key, true )

    end

    self:SortChildren()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- listbox remove timer
---------------------------------------------------------------------------------------------------
function TimerWindowElement:ActionRemove( timerIndex, key )

    -- iterrate from the back because the table can change from remove
    for i = #self.children, 1, -1 do

        if self.children[i].index == timerIndex then
            
            if self.children[i].key == nil or self.children[i].key == key then

                self.children[i]:Finish()
                self:Resize()

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- resize window
---------------------------------------------------------------------------------------------------
function TimerWindowElement:Resize()

    local childCount = self.timerListBox:GetItemCount() + 1

    local width, height

    -- calculate width and heights depending on orientation
    if self.data.orientation == Orientation.Horizontal then

        width   = childCount * ( self.data.height + ( 2 * self.data.frame ) ) + ( ( childCount - 1) * self.data.spacing )
        height  = self.data.width + ( 2 * self.data.frame )

    else

        width   = self.data.width + ( 2 * self.data.frame )
        height  = childCount * ( self.data.height + ( 2 * self.data.frame ) ) + ( ( childCount - 1) * self.data.spacing )

    end

    self:SetSize( width, height )
    self.timerListBox:SetSize( width, height ) 
    self.dragWindow:SetSize( width, height )
    self.dragLabel:SetSize( width - 2 * Options.Defaults.move.FrameSize,
                            height - 2 * Options.Defaults.move.FrameSize )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fill permanent timers
---------------------------------------------------------------------------------------------------
function TimerWindowElement:FillPermanentChildren()

    -- kill all permanent children!
    for i, child in pairs(self.children) do                 

        if child.timerData.permanent == true then
            child:Finish()
        end

    end

    -- iterrate all timers and create the permanent ones
    for j, timerData in ipairs(self.data.timerList) do

        if timerData.permanent == true then

            local index = #self.children + 1

            local icon = timerData.icon
            local text = ""
            if timerData.textOption == TimerTextOptions.CustomText then
                text = timerData.textValue
            end

            self.children[ index ] = Timer[ timerData.type ].Constructor( self, timerData, j, 0, 0, icon, text, nil, nil, false )
            self.timerListBox:AddItem( self.children[ index ] )

        end

    end

    self:SortChildren()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- sort timerListBox
---------------------------------------------------------------------------------------------------
function TimerWindowElement:SortChildren()

    self.timerListBox:Sort(
        function (child1, child2)

            -- both permanent > sort by index > child2 first
            if child1.data.permanent == true and
            child1.data.permanent == true and
            child1.sortIndex > child2.sortIndex then

                return false

            -- both permanent > sort by index > child1 first
            elseif child1.data.permanent == true and
            child1.data.permanent == true and
            child1.sortIndex < child2.sortIndex then

                return true

            -- child1 permanent = first
            elseif child1.data.permanent == true then

                return true
                
            -- child2 permanent = first
            elseif child2.data.permanent == true then

                return false

            -- both not permanent sort ty endTime > child2 first
            elseif child1.endTime > child2.endTime then

                return false

            -- both not permanent sort ty endTime > child1 first
            else

                return true

            end
            
        end
    )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if timer is running and return control
---------------------------------------------------------------------------------------------------
function TimerWindowElement:CheckForRunningTimer( timerIndex, key )

    for index, child in pairs(self.children) do

        if child.index == timerIndex and child.key == key then

            return child
            
        end
        
    end

    return nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------------------------
function TimerWindowElement:GetChildIndex( child )

    for index, control in ipairs(self.children) do

        if child == control then

            return index

        end

    end

    -- not found
    return nil

end
---------------------------------------------------------------------------------------------------
