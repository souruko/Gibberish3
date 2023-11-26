--=================================================================================================
--= ListBox Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
ListBoxElement = class( Turbine.UI.Window )

-- function table for window constructors
Window[ Window.Types.LISTBOX ].Constructor = function ( index )

    return ListBoxElement( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ListBox Constructor
---------------------------------------------------------------------------------------------------
function ListBoxElement:Constructor( index )
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

        end

    end

    self.dragWindow.MouseUp = function (sender, args)

        if args.Button == Turbine.UI.MouseButton.Left then
            
            -- stop dragging
            self.dragging = false

            self.data.left, self.data.top = UTILS.PixelToScreenRatio( self:GetPosition() )

            Options.SaveData()

        end

    end

    -- start up

    -- load window settings
    self:DataChanged()

    -- create all permanently displayed timers
    self:FillPermanentTimers()

    -- load selection and move state
    self:SelectionChanged()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] listbox action call from trigger
---------------------------------------------------------------------------------------------------
function ListBoxElement:Action(windowData, timerData, timerIndex, action, startTime, duration, icon, text, entity, key)

    -- split the call into the relevant actions
    if action == Actions.Add then
        self:Add( windowData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

    elseif action == Action.Remove then
        self:Remove( windowData, timerData, timerIndex, key )

    else
        -- error!

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] selection changed
---------------------------------------------------------------------------------------------------
function ListBoxElement:SelectionChanged()

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
function ListBoxElement:MoveChanged()

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
function ListBoxElement:DataChanged()

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
function ListBoxElement:Reset()

    -- iterrate from the back because the table can change from resets
    for i = #self.children, 1, -1 do

        self.children[i]:Reset()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] close everything
---------------------------------------------------------------------------------------------------
function ListBoxElement:Finish()

    -- timer finish call
    for i = #self.children, 1, -1 do

        self.children[i]:Finish()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- listbox add timer
---------------------------------------------------------------------------------------------------
function ListBoxElement:Add(windowData, timerData, timerIndex, startTime, duration, icon, text, entity, key)



end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- listbox remove timer
---------------------------------------------------------------------------------------------------
function ListBoxElement:Remove(windowData, timerData, timerIndex, key)



end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- listbox remove timer
---------------------------------------------------------------------------------------------------
function ListBoxElement:Resize()

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
function ListBoxElement:FillPermanentTimers()



end
---------------------------------------------------------------------------------------------------
