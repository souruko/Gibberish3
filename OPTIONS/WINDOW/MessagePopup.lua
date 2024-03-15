


Options.Elements.MessagePopup = class(Turbine.UI.Window)
---------------------------------------------------------------------------------------------------
function Options.Elements.MessagePopup:Constructor()
	Turbine.UI.Window.Constructor( self )

    self:SetSize( 70, 35)
    self:SetBackColor(Turbine.UI.Color.Red)
    self:SetVisible(false)

    self.label = Turbine.UI.Label()
	self.label:SetParent( self )
    self.label:SetSize( 70, 35)
	self.label:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
	self.label:SetForeColor( Options.Defaults.window.textcolor )
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)

    self.duration = 5
    self.messageEND = 0

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.MessagePopup:Show( message )

    self.messageEND = Turbine.Engine.GetGameTime() + self.duration
    self.label:SetText(message)

    self:SetVisible(true)
    self:SetWantsUpdates(true)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.MessagePopup:Update()

    local gameTime = Turbine.Engine.GetGameTime()

    if self.messageEND < gameTime then
        self:SetVisible(false)
        self:SetWantsUpdates(false)
    else
        local timeLeft =self.messageEND - gameTime
        local opacity = timeLeft/self.duration
        self:SetOpacity( opacity )

    end

end
---------------------------------------------------------------------------------------------------
