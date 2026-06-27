--=================================================================================================
--= Condition Listbox Window
--= ===============================================================================================
--=
--=================================================================================================



Options.Elements.ConditionListbox = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionListbox:Constructor( parent )
    Turbine.UI.Control.Constructor( self )

    self.parent     = parent
    self.controls   = {}
    self.ITEM_WIDTH = 80

    self:SetBackColor( Options.Defaults.window.framecolor )

    -- add button
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
        self:NewConditionPressed()
    end
    Options.Elements.Tooltip.AddTooltip( self.add_button, "tooltip", "button_new_condition", false )

    self.header = Turbine.UI.Label()
    self.header:SetParent( self )
    self.header:SetPosition( Options.Defaults.window.toolbar_height + (2 * Options.Defaults.window.frame), Options.Defaults.window.frame )
    self.header:SetHeight( Options.Defaults.window.toolbar_height )
    self.header:SetBackColor( Options.Defaults.window.backcolor2 )
    self.header:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
    self.header:SetForeColor( Options.Defaults.window.textcolor )
    self.header:SetFont( Options.Defaults.window.font )
    self.header:SetText( L[ Language.Local ].tab.conditions )

    -- items area: horizontal flow, below toolbar
    self.itemsArea = Turbine.UI.Control()
    self.itemsArea:SetParent( self )
    self.itemsArea:SetBackColor( Options.Defaults.window.backcolor2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionListbox:SizeChanged()

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
function Options.Elements.ConditionListbox:ContentChanged( data )

    for _, item in ipairs( self.controls ) do
        item:SetParent( nil )
    end

    self.data     = data
    self.controls = {}

    local list = data.conditionList or {}
    for i, conditionData in ipairs( list ) do
        self.controls[i] = ConditionItem( i, conditionData, self.ITEM_WIDTH, self.parent )
    end

    self:FillContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionListbox:FillContent()

    -- detach existing items
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
function Options.Elements.ConditionListbox:ConditionsSelectionChanged()

    for _, item in ipairs( self.controls ) do
        item:ConditionsSelectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionListbox:NewConditionPressed()

    if self.data == nil then return end

    local condition = Condition.New()
    local index = #self.data.conditionList + 1
    self.data.conditionList[index] = condition

    Options.ConditionsSelectionChanged( index )
    Options.SaveData()
    self:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ConditionListbox:UpdateData()

    for _, item in ipairs( self.controls ) do
        item:UpdateData()
    end

end
---------------------------------------------------------------------------------------------------
