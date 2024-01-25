--=================================================================================================
--= Dropdown Tab
--= ===============================================================================================
--= 
--=================================================================================================



Tab = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Tab:Constructor( index, name_control, name_description, parent, width )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.selected = false

    self.index = index
    self.name_control = name_control
    self.name_description = name_description

	self.background1 = Turbine.UI.Control()
	self.background1:SetParent( self )
	self.background1:SetBackColor( Options.Defaults.window.backcolor1 )
    self.background1:SetPosition( Options.Defaults.window.frame, Options.Defaults.window.frame )
    self.background1:SetMouseVisible( false )

    self.label = Turbine.UI.Label()
    self.label:SetParent( self.background1 )
    self.label:SetHeight( Options.Defaults.window.tab_height )
	self.label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
	self.label:SetFont( Options.Defaults.window.w_font )
    self.label:SetForeColor( Options.Defaults.window.textcolor )
    self.label:SetMouseVisible( false ) 

    self.MouseClick = function ()

        if self.selected == false then

            self.parent:ChangeSelection( index )

        end

    end
    self.MouseEnter = function ()

        if self.selected == false then
            self.background1:SetBackColor( Options.Defaults.window.w_window_hover )
        end
        
    end
    self.MouseLeave = function ()
        
        if self.selected == false then
            self.background1:SetBackColor( nil )
        end
        
    end

    self:SetSize( width, Options.Defaults.window.tab_height )
    self.background1:SetSize( width - (2*Options.Defaults.window.frame), Options.Defaults.window.tab_height - Options.Defaults.window.frame )

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Tab:SizeChanged()

    local width = self:GetWidth()

    self.label:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Tab:LanguageChanged()

    self.label:SetText( UTILS.GetText( self.name_control, self.name_description ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Tab:Select( index )

    if self.index == index then
        self.selected = true
        self:SetBackColor( Options.Defaults.window.framecolor )
        self.background1:SetBackColor( Options.Defaults.window.backcolor1 )
        self:SetHeight( Options.Defaults.window.tab_height + Options.Defaults.window.frame )
        self.background1:SetHeight( Options.Defaults.window.tab_height )

    else
        self.selected = false
        self:SetBackColor( nil )
        self.background1:SetBackColor( nil )
        self:SetHeight( Options.Defaults.window.tab_height )
        self.background1:SetHeight( Options.Defaults.window.tab_height - Options.Defaults.window.frame )

    end

end
---------------------------------------------------------------------------------------------------