--===================================================================================
--             Name:    RightClickSubMenu
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.RightClickSubMenu = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    RightClickSubMenu constructor
-------------------------------------------------------------------------------------
--        Parameter:    width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.RightClickSubMenu:Constructor( width )
	Turbine.UI.Control.Constructor( self )

    self.width                  = width
    self.item_height            = 24
    self.seperator_height       = 8
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


    self:SetWidth(              self.width )
    self.list:SetWidth(         self.width )


    self:SetVisible(false)

end




-------------------------------------------------------------------------------------
--      Description:    show right click Control
-------------------------------------------------------------------------------------
--        Parameter:    left
--                      top
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function  Options.Constructor.RightClickSubMenu:Show( left, top, focus )

    if left == nil then
        self:SetPosition( Turbine.UI.Display.GetMousePosition() )

    else
        self:SetPosition( left, top )

    end

    self:SetVisible( true )

end


-------------------------------------------------------------------------------------
--      Description:    hide right click Control
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function  Options.Constructor.RightClickSubMenu:Hide()

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
function Options.Constructor.RightClickSubMenu:AddRow( text, func )

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
function Options.Constructor.RightClickSubMenu:AddSeperator()

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
function Options.Constructor.RightClickSubMenu:AddSubMenuRow( text, subMenu )

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
function Options.Constructor.RightClickSubMenu:HoverChanged( selected )

    for i = 1, self.list:GetItemCount() do
 
        local child = self.list:GetItem(i)

        if child ~= selected then
            child:Deactivate()
            
        end

    end
    

end


