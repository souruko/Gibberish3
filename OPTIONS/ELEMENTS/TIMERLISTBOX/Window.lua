--=================================================================================================
--= TimerListbox
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.TimerListbox = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:Constructor( windowType, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent

    self.filterText  = ""
    self.controls = {}

    -- frame
    self:SetBackColor( Options.Defaults.window.framecolor )

    -- add trigger button
    -- new file button

    self.add_back = Turbine.UI.Control()
    self.add_back:SetParent( self )
    self.add_back:SetBackColor( Options.Defaults.window.backcolor2 )
    self.add_back:SetPosition( Options.Defaults.window.frame, Options.Defaults.window.frame )
    self.add_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )

    self.add_button = Turbine.UI.Button()
    self.add_button:SetParent( self.add_back )
    self.add_button:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
	self.add_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.add_button:SetBackground( "Gibberish3/RESOURCES/file_new.tga" )
	self.add_button:SetPosition( 0, 0 )
	self.add_button.MouseClick = function ()
        local left, top = self.add_back:PointToScreen(0, Options.Defaults.window.toolbar_height + Options.Defaults.window.frame )
		self:NewTimerPressed()
	end
	Options.Elements.Tooltip.AddTooltip( self.add_button, "tooltip", "button_new_timer", false )

    -- filter listbox
    self.filter_back = Turbine.UI.Control()
    self.filter_back:SetBackColor( Options.Defaults.window.backcolor2 )
	self.filter_back:SetParent( self )
    self.filter_back:SetPosition( Options.Defaults.window.toolbar_height + (2*Options.Defaults.window.frame), Options.Defaults.window.frame)
    self.filter_back:SetHeight( Options.Defaults.window.toolbar_height )

	self.filter = Turbine.UI.TextBox()
    self.filter:SetParent( self.filter_back )
	self.filter:SetLeft( 4 )
    self.filter:SetHeight( Options.Defaults.window.toolbar_height )
    self.filter:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
	self.filter:SetForeColor( Options.Defaults.window.textcolor )
    self.filter:SetMultiline( false )
	self.filter:SetSelectable( true )
    self.filter:SetFont( Options.Defaults.window.font )
	self.filter.FocusGained = function (sender, args)
		self:FilterFocusChanged(true)
	end
	self.filter.FocusLost = function (sender, args)
		self:FilterFocusChanged(false)
	end
	self.filter.TextChanged = function (sender, args)
		self.filterText = string.lower(self.filter:GetText())

		if self.filterText == "" then
			self.filter_clear:SetVisible(false)
		else
			self.filter_clear:SetVisible(true)
		end

		self:FillContent()
	end

	self.filter_icon = Turbine.UI.Control()
	self.filter_icon:SetParent( self.filter )
	self.filter_icon:SetPosition( -2, 0 )
	self.filter_icon:SetSize( 20, 20 )
	self.filter_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.filter_icon:SetBackground("Gibberish3/Resources/search.tga")
	self.filter_icon:SetMouseVisible(false)

	self.filter_clear = Turbine.UI.Button()
	self.filter_clear:SetSize( 20, 20 )
	self.filter_clear:SetParent( self.filter )
    self.filter_clear:SetTop( 0 )
	self.filter_clear:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.filter_clear:SetBackground("Gibberish3/Resources/cross.tga")
	self.filter_clear:SetVisible(false)
	self.filter_clear.MouseClick = function ()
		self.filter:SetText("")
		self.filterText = ""
		self.filter_clear:SetVisible(false)
		self:FilterFocusChanged( false )
        self:FillContent()
	end

    -- listbox
	self.listbox = Turbine.UI.ListBox()
	self.listbox:SetParent( self )
    self.listbox:SetBackColor( Options.Defaults.window.backcolor2 )
    self.listbox:SetPosition( Options.Defaults.window.frame, (2*Options.Defaults.window.frame) + Options.Defaults.window.toolbar_height )

	self.scrollbar = Turbine.UI.Lotro.ScrollBar()
	self.scrollbar:SetParent( self )
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
	self.scrollbar:SetBackColor( Options.Defaults.window.framecolor )
    self.scrollbar:SetTop( (2*Options.Defaults.window.frame) + Options.Defaults.window.toolbar_height )
    self.scrollbar:SetWidth( 10 )

    self.listbox:SetVerticalScrollBar( self.scrollbar )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:UpdateData()

    for index, item in ipairs(self.controls) do

        item:UpdateData()
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:FillContent()

    self.listbox:ClearItems()

    for index, item in ipairs(self.controls) do

		if item:Filter( self.filterText ) then
            self.listbox:AddItem( item )
        end
        
    end
    self:Sort()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:SizeChanged()

    local width, height = self:GetSize()

    local filter_width = width - (3*Options.Defaults.window.frame) - Options.Defaults.window.toolbar_height
    self.filter_back:SetWidth( filter_width )
    self.filter:SetWidth( filter_width )
    self.filter_clear:SetLeft( filter_width - 30 )
    
    local listbox_width = width - (2*Options.Defaults.window.frame)
    local listbox_height = height - (3*Options.Defaults.window.frame) - Options.Defaults.window.toolbar_height
    self.listbox:SetSize( listbox_width, listbox_height )
    self.scrollbar:SetHeight( listbox_height )
    
    local scroll_left = width - 10
    self.scrollbar:SetLeft( scroll_left )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:Sort()

    self.listbox:Sort(function (a, b)
        if a.data.sortIndex < b.data.sortIndex then
            return true
        end
        return false
    end)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:NewTimerPressed()

    local windowData = Data.window[ Data.selectedIndex ]
    local timerData = Timer.New( windowData.timerType )

    Window.AddTimer( Data.selectedIndex, timerData )
	Options.TimerSelectionChanged( #windowData.timerList )

    self:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:TimerSelectionChanged()

    for i = 1, self.listbox:GetItemCount(), 1 do
        
        local item = self.listbox:GetItem(i)
        item:TimerSelectionChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:ContentChanged( data )

    self.data = data
    self.controls = {}

    -- for typeIndex, typeList in ipairs(self.data) do

    --     for triggerIndex, triggerData in ipairs(typeList) do

    --         self.controls[#self.controls +1] = Item( triggerIndex, triggerData, 200 )
        
    --     end

    -- end

    for index, timerData in ipairs(self.data.timerList) do

        self.controls[ #self.controls+1 ] = Item( index, timerData, 200, self.parent )
        
    end

    self:FillContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:FilterFocusChanged( value )

	if value == true then
		self.filter_icon:SetVisible( false )

	elseif self.filterText == "" then
		self.filter_icon:SetVisible( true )

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TimerListbox:DraggingEnd( timerData )

	local left, top = self.listbox:GetMousePosition()
	local toItem = self.listbox:GetItemAt(left, top)

	if toItem ~= nil and timerData ~= toItem.data then

        local toIndex = toItem.data.sortIndex

        for index, item in ipairs(self.data.timerList) do
            
            if item.sortIndex >= toIndex then
                item.sortIndex = item.sortIndex + 1
            end

        end

        timerData.sortIndex = toIndex

        self:Sort()
    
    end

end
---------------------------------------------------------------------------------------------------
