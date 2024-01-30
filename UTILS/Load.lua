--=================================================================================================
--= Load        
--= ===============================================================================================
--= 
--=================================================================================================

--this is just to unload the reloader plugin if it is loaded on load up
local status  = 0
Close_reload_plugin = Turbine.UI.Window()
 
function Close_reload_plugin:Update()
	if status == 1 then
        Turbine.PluginManager.UnloadScriptState( "Gibberish3Reloader" )
    elseif status > 1 then
        self:SetWantsUpdates( false )
        self:Close()
        Close_reload_plugin = nil
	end

    status = status + 1
end

Close_reload_plugin:SetWantsUpdates( true )
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- load data
---------------------------------------------------------------------------------------------------
function Options.LoadData()

    -- account data
    local global_data = Turbine.PluginData.Load( Turbine.DataScope.Account, "gibberish_global_" .. Language[ Language.Local ], nil)

    -- no global data > create new data struct
    if global_data == nil then
        return DataFunction.New()

    end

    -- fix data for non english clients
    if Language.Local ~= Language.English then
        global_data = Options.ConvertFromEuro( global_data )

    end

    -- char data
    local char_data = Turbine.PluginData.Load( Turbine.DataScope.Character, "gibberish_char_" .. Language[ Language.Local ], nil)

    -- no char data > use global_data
    if char_data == nil then
        return global_data

    end

    return Options.OverwriteCharData( global_data, char_data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- overwrite global data with char data
---------------------------------------------------------------------------------------------------
function Options.OverwriteCharData( global_data, char_data )

    -- windows
    for index, window_data in ipairs( global_data.window ) do
        local data = Options.GetWindowByID( window_data.id, char_data )

        -- char data found
        if data ~= nil then
            window_data.enabled = data.enabled

            -- use char position if saveGlobaly == false
            if window_data.saveGlobaly == false then
                window_data.left = data.left
                window_data.top = data.top

            end

        else
            -- no char data found
            window_data.enabled = false

        end
       
    end

    return global_data

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get window by id
---------------------------------------------------------------------------------------------------
function Options.FillPersistantCollection()

    for i, data in ipairs(Data.persistent_collection.effects) do
        local index = #Options.Collection.Effects + 1

        Options.Collection.Effects[index] = data
    end

    for i, data in ipairs(Data.persistent_collection.chat) do
        local index = #Options.Collection.Chat + 1

        Options.Collection.Chat[index] = data
    end

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get window by id
---------------------------------------------------------------------------------------------------
function Options.GetWindowByID( id, char_data )

    for index, data in ipairs( char_data.window ) do

        if data.id == id then
            return data
        end
        
    end

    return nil

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- startup options if the were saved as open
---------------------------------------------------------------------------------------------------
function Options.StartUp()

    if Data.options.window.open == true then
        Options.OptionsWindow( Data.options.window.open )

    end

    if Data.moveMode == true then
        Options.MoveChanged( Data.moveMode )
        
    end

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fix for german/french client
---------------------------------------------------------------------------------------------------

function Options.ConvertFromEuro(dataRaw)
	local newData = {}
	for i, myData in pairs(dataRaw) do
		local tempIndex = tonumber(i);
		if (tempIndex == nil) then
			tempIndex = i;
		end
		local tempData = nil;

		if (type(myData) == "table") then
			tempData = Options.ConvertFromEuro(myData);
		else
			tempData = tonumber(myData);
			if (tempData == nil) then
				tempData = myData;
			end
		end
		newData[tempIndex] = tempData;
	end
	return newData;
	
end

---------------------------------------------------------------------------------------------------