--=================================================================================================
--= Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
CounterWindowElement = class( Turbine.UI.Window )

-- function table for window constructors
Window[ Window.Types.COUNTER_WINDOW ].Constructor = function ( index )

    return CounterWindowElement( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Constructor
---------------------------------------------------------------------------------------------------
function CounterWindowElement:Constructor( index )
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
    -- self:FillPermanentTimers() -- TODO Permanent COUNTERS

    -- load selection and move state
    self:SelectionChanged()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] timer action call from trigger
---------------------------------------------------------------------------------------------------
function CounterWindowElement:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

    -- split the call into the relevant actions

    -- add value to counter
    if triggerData.action == Action.Add then
        self:ActionAdd( triggerData.value, timerData, timerIndex, icon, text, entity, key )

    -- subtract value from counter
    elseif triggerData.action == Action.Subtract then
        self:ActionSubtract( triggerData.value, timerData, timerIndex, icon, text, entity, key )

    -- remove timer
    elseif triggerData.action == Action.Remove then
        self:ActionRemove( timerIndex, key )

    else
        -- error!

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] window action call from trigger
---------------------------------------------------------------------------------------------------
function CounterWindowElement:WindowAction( triggerData )

    -- split the call into the relevant actions

    -- reset timer counters and display window
    if triggerData.action == Action.Reset then
        self:ActionReset()

    -- remove all timer and hide window
    elseif triggerData.action == Action.Clear then
        self:ActionClear()

    else
        -- error!

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] selection changed
---------------------------------------------------------------------------------------------------
function CounterWindowElement:SelectionChanged()

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
function CounterWindowElement:MoveChanged()

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
function CounterWindowElement:DataChanged()

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
-- [required] reset all timer with  the reset attribute
---------------------------------------------------------------------------------------------------
function CounterWindowElement:Reset()

    -- iterrate from the back because the table can change from resets
    for i = #self.children, 1, -1 do

        self.children[i]:Reset()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] close everything
---------------------------------------------------------------------------------------------------
function CounterWindowElement:Finish()

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
function CounterWindowElement:ChildFinished( child )

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
-- resize window
---------------------------------------------------------------------------------------------------
function CounterWindowElement:Resize()

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
-- add value to counter
---------------------------------------------------------------------------------------------------
function CounterWindowElement:ActionAdd( value, timerData, timerIndex, icon, text, entity, key )

    local child = self:CheckForRunningTimer( timerIndex, key )

    -- stop when no timer is found
    if child == nil then
        return
    end

    child:UpdateContent( value, icon, text, entity, key, true  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- add value to counter
---------------------------------------------------------------------------------------------------
function CounterWindowElement:ActionSubtract( value, timerData, timerIndex, icon, text, entity, key )

    local child = self:CheckForRunningTimer( timerIndex, key )

    value = value * (-1)

    -- stop when no timer is found
    if child == nil then
        return
    end

    child:UpdateContent( value, icon, text, entity, key, true  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- add value to counter
---------------------------------------------------------------------------------------------------
function CounterWindowElement:ActionRemove( timerIndex, key )
    
    -- iterrate from the back because the table can change from remove
    for i = #self.children, 1, -1 do

        if self.children[i].index == timerIndex then

            -- key problem from diffrent trigger not sure what to do so not used for now
            -- if key == nil or self.children[i].key == key then

                self.children[i]:Finish()
                self:Resize()

            -- end

        end

    end
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- add value to counter
---------------------------------------------------------------------------------------------------
function CounterWindowElement:ActionReset()

    -- clear all children
    self:ActionClear()

    -- create all children
    self:FillChildren()

    -- set active
    self:Activ( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- add value to counter
---------------------------------------------------------------------------------------------------
function CounterWindowElement:ActionClear()

    -- clear all children
    for i = #self.children, 1, -1 do

        self.children[i]:Finish()

    end

    self:Activ( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- changes activ status of the window
---------------------------------------------------------------------------------------------------
function CounterWindowElement:Activ( value )

    if value == true then

        self:SetVisible( true )

    else

        self:SetVisible( false )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fill window with all children
---------------------------------------------------------------------------------------------------
function CounterWindowElement:FillChildren()

        -- iterrate all timers and create them
        for j, timerData in ipairs(self.data.timerList) do

            local index = #self.children + 1
            self.children[ index ] = Timer[ timerData.type ].Constructor( self, timerData, index )
            self.timerListBox:AddItem( self.children[ index ] )
     
        end

        self:Resize()
        self:SortChildren()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- sort timerListBox
---------------------------------------------------------------------------------------------------
function CounterWindowElement:SortChildren()

    -- sort by sortIndex
    self.timerListBox:Sort(
        function (child1, child2)

            if child1.sortIndex > child2.sortIndex then

                return false

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
function CounterWindowElement:CheckForRunningTimer( timerIndex, key )

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
function CounterWindowElement:GetChildIndex( child )

    for index, control in ipairs(self.children) do

        if child == control then

            return index

        end

    end

    -- not found
    return nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------------------------
function CounterWindowElement:GetRunningTimer()

    return nil

end
---------------------------------------------------------------------------------------------------
