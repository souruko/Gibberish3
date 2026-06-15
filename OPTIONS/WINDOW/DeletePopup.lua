--=================================================================================================
--= DeletePopup
--= ===============================================================================================
--= Blocking confirmation overlay for destructive window / folder deletion.
--=================================================================================================



Options.Elements.DeletePopup = class(Turbine.UI.Window)
---------------------------------------------------------------------------------------------------
function Options.Elements.DeletePopup:Constructor()
    Turbine.UI.Window.Constructor( self )

    self.onConfirm = nil

    self:SetBackColor( Turbine.UI.Color( 0.1, 0.1, 0.1 ) )
    self:SetOpacity( 0.9 )
    self:SetVisible( false )

    -- card
    local card_w, card_h = 280, 90
    self.card_frame = Turbine.UI.Window()
    self.card_frame:SetParent( self )
    self.card_frame:SetSize( card_w + 2, card_h + 2 )
    self.card_frame:SetBackColor( Options.Defaults.window.framecolor )
    self.card_frame:SetMouseVisible( false )
    self.card_frame:SetVisible( false )

    self.card = Turbine.UI.Control()
    self.card:SetParent( self.card_frame )
    self.card:SetPosition( 1, 1 )
    self.card:SetSize( card_w, card_h )
    self.card:SetBackColor( Options.Defaults.window.backcolor1 )
    self.card:SetMouseVisible( false )

    -- name label
    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent( self.card )
    self.nameLabel:SetSize( card_w - 20, 40 )
    self.nameLabel:SetPosition( 10, 8 )
    self.nameLabel:SetFont( Options.Defaults.window.w_font )
    self.nameLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.nameLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
    self.nameLabel:SetMouseVisible( false )

    local btn_w, btn_h = 110, 28
    local btn_top = card_h - btn_h - 10
    local gap = 10

    -- delete button
    self.delete_back = Turbine.UI.Control()
    self.delete_back:SetParent( self.card )
    self.delete_back:SetSize( btn_w, btn_h )
    self.delete_back:SetPosition( (card_w / 2) - btn_w - (gap / 2), btn_top )
    self.delete_back:SetBackColor( Turbine.UI.Color( 0.55, 0.05, 0.05 ) )

    self.delete_label = Turbine.UI.Label()
    self.delete_label:SetParent( self.delete_back )
    self.delete_label:SetSize( btn_w, btn_h )
    self.delete_label:SetFont( Options.Defaults.window.font )
    self.delete_label:SetForeColor( Options.Defaults.window.textcolor )
    self.delete_label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
    self.delete_label:SetMouseVisible( false )

    self.delete_back.MouseEnter = function ()
        self.delete_back:SetBackColor( Turbine.UI.Color( 0.75, 0.08, 0.08 ) )
    end
    self.delete_back.MouseLeave = function ()
        self.delete_back:SetBackColor( Turbine.UI.Color( 0.55, 0.05, 0.05 ) )
    end
    self.delete_back.MouseClick = function ()
        local cb = self.onConfirm
        self:Hide()
        if cb then cb() end
    end

    -- cancel button
    self.cancel_back = Turbine.UI.Control()
    self.cancel_back:SetParent( self.card )
    self.cancel_back:SetSize( btn_w, btn_h )
    self.cancel_back:SetPosition( (card_w / 2) + (gap / 2), btn_top )
    self.cancel_back:SetBackColor( Options.Defaults.window.backcolor2 )

    self.cancel_label = Turbine.UI.Label()
    self.cancel_label:SetParent( self.cancel_back )
    self.cancel_label:SetSize( btn_w, btn_h )
    self.cancel_label:SetFont( Options.Defaults.window.font )
    self.cancel_label:SetForeColor( Options.Defaults.window.textcolor )
    self.cancel_label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
    self.cancel_label:SetMouseVisible( false )

    self.cancel_back.MouseEnter = function ()
        self.cancel_back:SetBackColor( Options.Defaults.window.hovercolor )
    end
    self.cancel_back.MouseLeave = function ()
        self.cancel_back:SetBackColor( Options.Defaults.window.backcolor2 )
    end
    self.cancel_back.MouseClick = function ()
        self:Hide()
    end

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DeletePopup:LanguageChanged()

    self.delete_label:SetText( UTILS.GetText( "selection", "delete" ) )
    self.cancel_label:SetText( UTILS.GetText( "selection", "cancel" ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DeletePopup:SizeChanged()

    local width, height = self:GetSize()
    local fw = self.card_frame:GetWidth()
    local fh = self.card_frame:GetHeight()
    self.card_frame:SetPosition( (width - fw) / 2, (height - fh) / 2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DeletePopup:Show( name, onConfirm )

    self.onConfirm = onConfirm
    self.nameLabel:SetText( name )
    self:SetVisible( true )
    self.card_frame:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DeletePopup:Hide()

    self.onConfirm = nil
    self:SetVisible( false )
    self.card_frame:SetVisible( false )

end
---------------------------------------------------------------------------------------------------
