
ListBoxOptions = class(Turbine.UI.Control)

function ListBoxOptions:Constructor(displayType, data, width, height, parent)
	Turbine.UI.Control.Constructor( self )

    self.displayType = displayType
    self.data = data

    self:SetSize(width, height)

    self.label  = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetText(data.name)

    self:SetParent(parent)

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function ListBoxOptions:SizeChanged()



end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function ListBoxOptions:Finish()

    self:SetParent(nil)

end