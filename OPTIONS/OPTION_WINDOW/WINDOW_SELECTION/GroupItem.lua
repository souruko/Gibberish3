--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
GroupItem = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:Constructor( groupData, index, width )
	Turbine.UI.Control.Constructor( self )

    self.groupData = groupData
    self.index = index

    local height = 50

    local name_left = 90
    local name_width = width - name_left

    self:SetSize( width, height + 2 )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetSize(width, height)
    self.frame:SetMouseVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetPosition(0, 1)
    self.background:SetSize(width, height - 2)
    self.background:SetBackColor(Defaults.Colors.BackgroundColor1)
    self.background:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay )
    self.background:SetMouseVisible(false)


    self.enabledCheckBox = Turbine.UI.Lotro.CheckBox()
    self.enabledCheckBox:SetParent(self)
    self.enabledCheckBox:SetSize(width, height)
    self.enabledCheckBox:SetText("")
    self.enabledCheckBox:SetSize(30, 30)
    self.enabledCheckBox:SetPosition( 30, 18)
    self.enabledCheckBox:SetMouseVisible(false)

    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(self)
    self.nameLabel:SetPosition( name_left, 0)
    self.nameLabel:SetSize(name_width, height)
    self.nameLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont( Defaults.Fonts.HeadingFont )
    self.nameLabel:SetText( groupData.name)
    self.nameLabel:SetMouseVisible(  false )
    self.nameLabel:SetMouseVisible(false)

    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent(self)
    self.typeLabel:SetPosition(30, 3)
    self.typeLabel:SetSize(50, 20)
    self.typeLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.typeLabel:SetFont( Defaults.Fonts.SmallFont )
    self.typeLabel:SetText(L[Language.Local].Terms.GroupTypes[groupData.type])
    self.typeLabel:SetMouseVisible(  false )
    self.typeLabel:SetMouseVisible(false)

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:MouseClick( sender, args )

    Data.selectedGroupIndex = self.index
    Options.SelectedWindowChanged()

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:MouseEnter( sender, args )

    if self.index == Data.selectedGroupIndex then

    else

        self.background:SetBackColor(Defaults.Colors.BackgroundColor2)

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:MouseLeave( sender, args )

    if self.index == Data.selectedGroupIndex then

    else

        self.background:SetBackColor(Defaults.Colors.BackgroundColor1)

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:SelectionChanged()

    if self.index == Data.selectedGroupIndex then

        self.frame:SetBackColor( Defaults.Colors.Selected )
        self.background:SetBackColor(Turbine.UI.Color.Black)

    else

        self.frame:SetBackColor( Defaults.Colors.BackgroundColor1 )
        self.background:SetBackColor(Defaults.Colors.BackgroundColor1)

    end

end


