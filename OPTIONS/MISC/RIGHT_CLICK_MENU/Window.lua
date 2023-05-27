--===================================================================================
--             Name:    RightClickMenu
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.RightClickMenu = class( Turbine.UI.Window )






-------------------------------------------------------------------------------------
--      Description:    RightClickMenu constructor
-------------------------------------------------------------------------------------
--        Parameter:    width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.RightClickMenu:Constructor( width )
	Turbine.UI.Window.Constructor( self )

    self.width                  = width
    self.item_height            = 24
    self.seperator_height       = 12
    self.height                 = 10

    self:SetZOrder(             100 )

    self.background             = Turbine.UI.Control()
    self.background:SetParent(  self )
    self.background:SetWidth(   self.width )
    self.background:SetBackColor(Defaults.Colors.MenuColor1 )

    self.list                   = Turbine.UI.ListBox()
    self.list:SetParent(        self )
    self.list:SetTop(           5 )
    self.list:SetOpacity(       0.9 )
    self.list:SetMouseVisible(  false )
    
    
    self:SetWidth(              2 * self.width + 5 )
    self.list:SetWidth(         self.width )

end




-------------------------------------------------------------------------------------
--      Description:    show right click window
-------------------------------------------------------------------------------------
--        Parameter:    left
--                      top
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function  Options.Constructor.RightClickMenu:Show( left, top, focus )

    if left == nil then
        self:SetPosition( Turbine.UI.Display.GetMousePosition() )

    else
        self:SetPosition( left, top )

    end

    self:SetVisible( true )

    if focus == true then
        self:Activate()
        self:Focus()
    end

end


-------------------------------------------------------------------------------------
--      Description:    show right click window
-------------------------------------------------------------------------------------
--        Parameter:    left
--                      top
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function  Options.Constructor.RightClickMenu:FocusGained()


    
end



-------------------------------------------------------------------------------------
--      Description:    show right click window
-------------------------------------------------------------------------------------
--        Parameter:    left
--                      top
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function  Options.Constructor.RightClickMenu:FocusLost()

    self:Hide()
 
end


-------------------------------------------------------------------------------------
--      Description:    hide right click window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function  Options.Constructor.RightClickMenu:Hide()

    self:SetVisible(            false )
  
    local parent                = self:GetParent()
    if parent ~= nil then
        parent:Hide()

    end

end


-------------------------------------------------------------------------------------
--      Description:    add row
-------------------------------------------------------------------------------------
--        Parameter:    text
--                      function()
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.RightClickMenu:AddRow( text, func )

    local row = Row(        self, self.width, self.item_height, text, func)

    self.list:AddItem(      row )

    self.height           = self.height + self.item_height
    self:SetHeight(         self.height + 200 )
    self.list:SetHeight(    self.height )
    self.background:SetHeight(    self.height )
end

-------------------------------------------------------------------------------------
--      Description:    add seperator
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.RightClickMenu:AddSeperator()

    local seperator   = Seperator(self, self.width, self.seperator_height )

    self.list:AddItem(  seperator )

    self.height       = self.height + self.seperator_height
    self:SetHeight(     self.height + 200 )
    self.list:SetHeight( self.height )
    self.background:SetHeight( self.height )

end

-------------------------------------------------------------------------------------
--      Description:    add sub menu row
-------------------------------------------------------------------------------------
--        Parameter:    text
--                      subMenu
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.RightClickMenu:AddSubMenuRow( text, subMenu )

    local row = SubMenuRow(self, self.width, self.item_height, text, subMenu)

    subMenu:SetParent(self)

    self.list:AddItem( row )

    self.height = self.height + self.item_height
    self:SetHeight( self.height + 200 )
    self.list:SetHeight( self.height )
    self.background:SetHeight( self.height )


end


-------------------------------------------------------------------------------------
--      Description:    hover changed
-------------------------------------------------------------------------------------
--        Parameter:    selected row
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Options.Constructor.RightClickMenu:HoverChanged( selected )

    for i = 1, self.list:GetItemCount() do
 
        local child = self.list:GetItem(i)

        if child ~= selected then
            child:Deactivate()
            
        end

    end
    

end


