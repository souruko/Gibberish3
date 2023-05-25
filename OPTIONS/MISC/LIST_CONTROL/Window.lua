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
function Options.Constructor.ListControl:Constructor()
	Turbine.UI.Control.Constructor( self )

    self:SetBackColor( Defaults.Colors.BackgroundColor6 )
    self:SetMouseVisible(false)

    self.frame_size = 2
    self.serachBox_height = 20
    self.addButton_width = 30

    -------------------------------------------------------------------------------------
--  new button  
    self.addButton                        = Turbine.UI.Button()
    self.addButton:SetParent(               self )
    self.addButton:SetPosition(             2,2 )
    self.addButton:SetBackColor(            Turbine.UI.Color.Black )
    self.addButton:SetFont(             Defaults.Fonts.SmallFont )
    self.addButton:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleCenter)

    self.addButton:SetText(         L[Language.Local].Button.Add )
    self.addButton:SetSize(                self.addButton_width, self.serachBox_height )

    self.searchText = ""

    self.serachBox                    = Turbine.UI.Lotro.TextBox()
    self.serachBox:SetPosition(         2*self.frame_size + self.addButton_width , self.frame_size )
    self.serachBox:SetParent(           self )
    self.serachBox:SetHeight(           self.serachBox_height)
    self.serachBox:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
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
	end

    self.list                 = Turbine.UI.ListBox()
    self.list:SetParent(        self)
    self.list:SetPosition(      self.frame_size, 2*self.frame_size + self.serachBox_height )
    self.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
    self.list:SetMouseVisible(false)

    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
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

    self.list:AddItem(item)

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
    self:GetParent():SelectionChanged( selection )
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