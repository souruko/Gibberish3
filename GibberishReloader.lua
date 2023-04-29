import "Turbine"
import "Turbine.UI"

local check  = 0
Control_check = Turbine.UI.Control()

function Control_check:Update()
	if check == 50 then
		Turbine.PluginManager.UnloadScriptState( "Gibberish3" )
	elseif check == 51 then
		Turbine.PluginManager.LoadPlugin( "Gibberish3" )
	elseif check > 51 then
        self:SetWantsUpdates( false )

		Control_check = nil
	end

	check = check + 1
end

Control_check:SetWantsUpdates( true )