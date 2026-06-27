--=================================================================================================
--= Condition Trigger Listbox
--= ===============================================================================================
--=
--=================================================================================================



Options.Elements.ConditionTriggerListbox = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:Constructor( parent )
    Turbine.UI.Control.Constructor( self )

    self.parent     = parent
    self.controls   = {}
    self.ITEM_WIDTH = 80

    self:SetBackColor( Options.Defaults.window.framecolor )

    -- add button with trigger-type submenu
    self.add_menu = Options.Elements.RightClickMenu( Options.Defaults.window.file_width )
    for key, value in pairs( Trigger.Types ) do
        local item = Options.Elements.Row( "triggerType", value, function ()
            self:NewTriggerPressed( value )
        end, Options.Defaults.rc_menu.item_height )
        self.add_menu:AddRow( item )
    end

    self.add_back = Turbine.UI.Control()
    self.add_back:SetParent( self )
    self.add_back:SetBackColor( Options.Defaults.window.backcolor2 )
    self.add_back:SetPosition( Options.Defaults.window.frame, Options.Defaults.window.frame )
    self.add_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
    self.add_back.MouseEnter = function ()
        self.add_back:SetBackColor( Options.Defaults.window.hovercolor )
    end
    self.add_back.MouseLeave = function ()
        self.add_back:SetBackColor( Options.Defaults.window.backcolor2 )
    end

    self.add_button = Turbine.UI.Button()
    self.add_button:SetParent( self.add_back )
    self.add_button:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
    self.add_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.add_button:SetBackground( "Gibberish3/RESOURCES/file_new.tga" )
    self.add_button:SetPosition( 0, 0 )
    self.add_button.MouseClick = function ()
        local left, top = self.add_back:PointToScreen( 0, Options.Defaults.window.toolbar_height + Options.Defaults.window.frame )
        self.add_menu:Show( left, top )
    end
    Options.Elements.Tooltip.AddTooltip( self.add_button, "tooltip", "button_new_trigger", false )

    self.header = Turbine.UI.Label()
    self.header:SetParent( self )
    self.header:SetPosition( Options.Defaults.window.toolbar_height + (2 * Options.Defaults.window.frame), Options.Defaults.window.frame )
    self.header:SetHeight( Options.Defaults.window.toolbar_height )
    self.header:SetBackColor( Options.Defaults.window.backcolor2 )
    self.header:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
    self.header:SetForeColor( Options.Defaults.window.textcolor )
    self.header:SetFont( Options.Defaults.window.font )
    self.header:SetText( L[ Language.Local ].tab.condition_triggers )

    -- items area: horizontal flow, below toolbar
    self.itemsArea = Turbine.UI.Control()
    self.itemsArea:SetParent( self )
    self.itemsArea:SetBackColor( Options.Defaults.window.backcolor2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:SizeChanged()

    local width, height = self:GetSize()
    local f  = Options.Defaults.window.frame
    local tb = Options.Defaults.window.toolbar_height

    local area_top    = (2 * f) + tb
    local area_height = height - area_top - f

    self.header:SetWidth( width - tb - (3 * f) )

    self.itemsArea:SetPosition( f, area_top )
    self.itemsArea:SetSize( width - 2*f, area_height )

    self:FillContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:ContentChanged( data )

    for _, item in ipairs( self.controls ) do
        item:SetParent( nil )
    end

    self.data     = data
    self.controls = {}

    for typeIndex, typeList in ipairs( data ) do
        for triggerIndex, triggerData in ipairs( typeList ) do
            self.controls[ #self.controls + 1 ] = ConditionTriggerItem( triggerIndex, triggerData, self.ITEM_WIDTH, self.parent )
        end
    end

    self:FillContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:FillContent()

    for _, item in ipairs( self.controls ) do
        item:SetParent( nil )
    end

    local f = Options.Defaults.window.frame
    local _, area_height = self.itemsArea:GetSize()
    local item_height = area_height - 2*f
    if item_height < Options.Defaults.window.t_item_height then
        item_height = Options.Defaults.window.t_item_height
    end

    local x = f
    for _, item in ipairs( self.controls ) do
        item:SetParent( self.itemsArea )
        item:SetHeight( item_height )
        item:SetPosition( x, f )
        x = x + self.ITEM_WIDTH + f
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:TriggerSelectionChanged()

    for _, item in ipairs( self.controls ) do
        item:TriggerSelectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:UpdateData()

    for _, item in ipairs( self.controls ) do
        item:UpdateData()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:NewTriggerPressed( type )

    if self.data == nil then return end

    local triggerData  = Trigger.New( type )
    local triggerIndex = #self.data[ type ] + 1
    self.data[ type ][ triggerIndex ] = triggerData

    self.parent:TriggerSelected( triggerIndex, type )
    self:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionTriggerListbox:DraggingEnd( triggerData )
end
---------------------------------------------------------------------------------------------------
