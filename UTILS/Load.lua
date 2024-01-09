--=================================================================================================
--= Load        
--= ===============================================================================================
--= 
--=================================================================================================

--this is just to unload the reloader plugin if it is loaded on load up
local status  = 0
Close_reload_plugin = Turbine.UI.Control()
 
function Close_reload_plugin:Update()
	if status == 1 then
        Turbine.PluginManager.UnloadScriptState( "Gibberish3Reloader" )
    elseif status > 1 then
        self:SetWantsUpdates( false )
        
        Close_reload_plugin = nil
	end

    status = status + 1
end

Close_reload_plugin:SetWantsUpdates( true )