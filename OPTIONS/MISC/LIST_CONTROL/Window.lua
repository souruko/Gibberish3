--===================================================================================
--             Name:    ListControl
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.ListControl = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    ListControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:Constructor( func )
	Turbine.UI.Control.Constructor( self )

    self:SetBackColor( Defaults.Colors.BackgroundColor6 )
    self:SetMouseVisible(false)

    self.children = {}

    self.frame_size = 2
    self.serachBox_height = 20
    self.addButton_width = 30

    -------------------------------------------------------------------------------------
--  new button  
    self.addButton                        = Turbine.UI.Button()
    self.addButton:SetParent(               self )
    self.addButton:SetPosition(             2,2 )
    self.addButton:SetBackColor(            Defaults.Colors.BackgroundColor1 )
    self.addButton:SetFont(             Defaults.Fonts.MediumFont )
    self.addButton:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleCenter)
    self.addButton:SetForeColor( Defaults.Colors.BackgroundColor6 )
    self.addButton:SetBackColor(            Defaults.Colors.BackgroundColor1 )

    self.addButton:SetText(         "+" )
    self.addButton:SetSize(                self.addButton_width, self.serachBox_height )
    self.addButton.MouseClick = function ()
        func()
    end

    self.searchText = ""

    self.serachBox                    = Turbine.UI.Lotro.TextBox()
    self.serachBox:SetPosition(         2*self.frame_size + self.addButton_width , self.frame_size )
    self.serachBox:SetParent(           self )
    self.serachBox:SetHeight(           self.serachBox_height)
    self.serachBox:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
    self.serachBox:SetMultiline(        false)
    self.serachBox:SetFont(             Defaults.Fonts.SmallFont )
    self.serachBox:SetForeColor(       Turbine.UI.Color.White)
    self.serachBox:SetText(             L[Language.Local].Text.SearchBoxDefault)

    self.serachBox.FocusGained = function(sender, args)
		if self.searchText == "" then
			self.serachBox:SetText("")
		end		
	end
	self.serachBox.FocusLost = function(sender, args)
		if self.searchText == "" then
			self.serachBox:SetText(L[Language.Local].Text.SearchBoxDefault )
		end
	end
	self.serachBox.TextChanged = function(sender, args)		
		self.searchText = string.lower(self.serachBox:GetText())
        self:FilterContent()
	end

    self.list                 = Turbine.UI.ListBox()
    self.list:SetParent(        self)
    self.list:SetPosition(      self.frame_size, 2*self.frame_size + self.serachBox_height )
    self.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
    self.list:SetMouseVisible(false)

    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetBackColor(Defaults.Colors.BackgroundColor6)
    self.scroll:SetTop(  2*self.frame_size + self.serachBox_height  )
    self.scroll:SetParent(self)
    self.scroll:SetWidth(10)
    self.scroll:SetZOrder(50)
    self.list:SetVerticalScrollBar(self.scroll)

end

-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:SizeChanged()

    local width, height = self:GetSize()
    local content_width = width - 2*self.frame_size

    self.serachBox:SetWidth(content_width- self.frame_size - self.addButton_width)
    self.list:SetSize( content_width, height - 3*self.frame_size - self.serachBox_height )
    self.scroll:SetLeft(  self.list:GetLeft() + content_width - 10  )

    self.serachBox:SetText(self.serachBox:GetText())

end



-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:ClearItems()

    self.list:ClearItems()

end



-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:AddItem( item )

    self.children[#self.children+1] = item

    if item:MatchesSearch(self.searchText) then
        self.list:AddItem(item)
    end

    self:Sort()
  
end


-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:FilterContent()

    self.list:ClearItems()

    for index, child in ipairs(self.children) do
  
        if child:MatchesSearch(self.searchText) then
            self.list:AddItem(child)
        end
        
    end
  
    self:Sort()
  
end

-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:Sort()

    self.list:Sort(function (itema, itemb)

        if itema.data.sortIndex < itemb.data.sortIndex then
            return true
        end
        return false
        
    end)

end


-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:GetItemAtMousePos()

    local left, top = self.list:GetMousePosition()

    local item = self.list:GetItemAt(left, top)

    if item == nil then

        if top <= 0 then

            item = self.list:GetItem(1)

        else

            item = self.list:GetItem(self.list:GetItemCount())

        end

    end

   return item

end


-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:ItemSelected( selected )

    for i = 1, self.list:GetItemCount() do

        local item = self.list:GetItem(i)

        if item == selected then
            item:Select()
        else
            item:Deselect()
        end
        
    end
    
end



-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:ResetSelection()

    local selection = nil
    if self.list:GetItemCount() ~= 0 then
        selection = self.list:GetItem(1)
    end

    -- self:ItemSelected(selection)
    if selection == nil then
        self:GetParent():SelectionChanged( nil, nil, nil )
    else
        self:GetParent():SelectionChanged( selection.data, selection.index, false )
    end
end


-------------------------------------------------------------------------------------
--      Description:    ListControl 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.ListControl:SelectionChanged( func )

    for i = 1, self.list:GetItemCount() do

        local item = self.list:GetItem(i)

        if func(item.index) then
            item:Select()
        else
            item:Deselect()
        end

    end

end