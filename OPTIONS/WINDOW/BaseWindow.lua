--=================================================================================================
--= Options Window base
--= ===============================================================================================
--= 
--=================================================================================================



Options.Window.Constructor = class(Turbine.UI.Lotro.Window)
---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:Constructor()
	Turbine.UI.Lotro.Window.Constructor( self )

    self.window_selection  = Options.Elements.WindowSelection()
    self.window_selection:SetParent( self )

    self.selection_options = Options.Elements.SelectionOptions()
    self.selection_options:SetParent( self )

    self.general_options   = Options.Elements.GeneralOptions()
    self.general_options:SetParent( self )

    self.collection_window = Options.Elements.CollectionWindow()
    self.collection_window:SetParent( self )

    self.messagePopup = Options.Elements.MessagePopup()
    self.messagePopup:SetParent( self )

    self:LanguageChanged()
    self:SelectionChanged()

    if Data.options.window.width < Options.Defaults.window.min_width then
        Data.options.window.width = Options.Defaults.window.min_width
    end

    if Data.options.window.height < Options.Defaults.window.min_height then
        Data.options.window.height = Options.Defaults.window.min_height
    end

    if Data.options.window.width > Options.Defaults.window.max_width then
        Data.options.window.width = Options.Defaults.window.max_width
    end

    -- base window
    self:SetText( "Gibberish" )
    self:SetPosition( UTILS.ScreenRatioToPixel( Data.options.window.left, Data.options.window.top ) )
    self:SetMinimumSize( Options.Defaults.window.min_width, Options.Defaults.window.min_height )
    self:SetMaximumWidth( Options.Defaults.window.max_width )
    self:SetResizable( true )
    self:SetSize( Data.options.window.width, Data.options.window.height )
    self:SetVisible(true)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:Closed()

    -- fix the object from the outside
    Options.OptionsWindow( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:LanguageChanged()

    self.window_selection:LanguageChanged()
    self.selection_options:LanguageChanged()
    self.general_options:LanguageChanged()
    self.collection_window:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:SelectionChanged()

    self.window_selection:SelectionChanged()
    self.selection_options:SelectionChanged()
    self.general_options:SelectionChanged()
    self.collection_window:SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:TimerSelectionChanged()

    self.selection_options:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:TriggerSelectionChanged()

    self.selection_options:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:Trigger2SelectionChanged()

    self.selection_options:Trigger2SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:DataChanged( index )

    self.window_selection:DataChanged( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:Save()

    self.messagePopup:Show( L[ Data.options.language ] )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:ResetSelectedContent()

    self.window_selection:ReFill()
    self.window_selection:SelectionChanged()
    self.selection_options:SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:SizeChanged()

    local width, height = self:GetSize()
    Data.options.window.width  = width
    Data.options.window.height = height

    local window_selection_width  = Options.Defaults.window.ws_width
    -- height - outer_spacing - top_spacing
    local window_selection_height = height -  Options.Defaults.window.outer_spacing - Options.Defaults.window.top_spacing - Options.Defaults.window.g_height - Options.Defaults.window.spacing 

    local collection_width  = Options.Defaults.window.c_width
    -- height - outer_spacing - top_spacing
    local collection_height = height - ( Options.Defaults.window.outer_spacing + Options.Defaults.window.top_spacing )

    -- width - 2x out_spacing - 2x spacing - windowselection - collection
    local general_width  = window_selection_width
    local general_height = Options.Defaults.window.g_height

    -- width - 2x out_spacing - 2x spacing - windowselection - collection
    local selection_options_width  = width - window_selection_width - collection_width - ( 2 * ( Options.Defaults.window.outer_spacing + Options.Defaults.window.spacing ) )
    local selection_options_height = height - ( Options.Defaults.window.outer_spacing + Options.Defaults.window.top_spacing )

    self.window_selection:SetSize( window_selection_width, window_selection_height )
    self.general_options:SetSize( general_width, general_height )
    self.selection_options:SetSize( selection_options_width, selection_options_height )
    self.collection_window:SetSize( collection_width, collection_height)

    self.window_selection:SetPosition( Options.Defaults.window.outer_spacing, Options.Defaults.window.top_spacing )
    self.general_options:SetPosition(  Options.Defaults.window.outer_spacing, ( height - Options.Defaults.window.outer_spacing - general_height ) )
    self.selection_options:SetPosition( ( Options.Defaults.window.outer_spacing + Options.Defaults.window.spacing + Options.Defaults.window.ws_width ),  Options.Defaults.window.top_spacing )
    self.collection_window:SetPosition( ( Data.options.window.width - Options.Defaults.window.outer_spacing - Options.Defaults.window.c_width ), Options.Defaults.window.top_spacing )
    self.messagePopup:SetPosition( selection_options_width + ( Options.Defaults.window.outer_spacing + Options.Defaults.window.spacing + Options.Defaults.window.ws_width ) - 110, selection_options_height - 40 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:PositionChanged()

    local left, top = UTILS.PixelToScreenRatio( self:GetPosition() )
    Data.options.window.left = left
    Data.options.window.top  = top

    self.general_options:PositionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:EffectCollectionChanged()

    self.collection_window:EffectCollectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:ChatCollectionChanged()

    self.collection_window:ChatCollectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:Closing()

    self.general_options:Closing()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:CollectionItemClicked( data )
    self.selection_options:BuildCollectionRightClickMenu( data )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Window.Constructor:ShowExport( data, type, index )

    self.selection_options:ShowExport( data, type, index )

end
---------------------------------------------------------------------------------------------------
