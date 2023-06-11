--===================================================================================
--             Name:    TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.TabWindow = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    TabWindow constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TabWindow:Constructor( parent, width, header_width )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.children = {}
    self.activChild = nil
    self.header_width = header_width

    self:SetWidth( width )
    self:SetParent(parent)

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetSize( width, 30 )
    self.list:SetMaxItemsPerLine(1)
    self.list:SetBackColor( Defaults.Colors.BackgroundColor1 )

end


-------------------------------------------------------------------------------------
--      Description:    Add Tab
-------------------------------------------------------------------------------------
--        Parameter:    Tab
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TabWindow:AddTab( tab )

    self.children[#self.children+1] = tab
    self.list:AddItem( tab.header )

end


-------------------------------------------------------------------------------------
--      Description:    fix size of children
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TabWindow:SizeChanged()

    self.list:SetSize( self:GetWidth(), 30 )

    for index, child in ipairs(self.children) do

        child:SetSize( self:GetSize() )

    end

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
--        Parameter:    childheader
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TabWindow:SelectionChanged(selected)

    if self.activChild ~= nil then
        self.activChild:SetParent(nil)
    end

    for index, child in ipairs(self.children) do

        if child ~= selected then
            child:Deselect()
        else
            self.parent:TabChanged(index)
        end


    end

    if selected ~= nil then
        self.activChild = selected
        selected:SetParent(self)
    end




end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
--        Parameter:    childheader
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TabWindow:SetTab(index)

    for index, child in ipairs(self.children) do

        child:Deselect()

    end

    if self.children[index] ~= nil then
        self.children[index]:Select()

    elseif self.children[1] ~= nil then
        self.children[1]:Select()
        
    end


end
