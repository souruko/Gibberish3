--=================================================================================================
--= Save        
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- save data
---------------------------------------------------------------------------------------------------
function Options.SaveData()

    if Language.Local == Language.English then
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_char_" .. Language[ Language.English ], Data, nil)
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_global_" .. Language[ Language.English ], Data, nil)

    else
        local converted = Options.ConvertToEuro(Data)
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_char_" .. Language[ Language.Local ], converted, nil)
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_global_" .. Language[ Language.Local ], converted, nil)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reload plugin
---------------------------------------------------------------------------------------------------
function Options.Reload()

    Turbine.PluginManager.LoadPlugin( "Gibberish3Reloader" )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- plugin unload
---------------------------------------------------------------------------------------------------
function Turbine.Plugin.Unload()

    Options.SaveData()
	Options.SaveRunningTimer()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- save running timer
---------------------------------------------------------------------------------------------------
function Options.SaveRunningTimer()

	local running_data = {}

	for index, data in ipairs(Data.window) do

		if data.enabled == true and Windows[ index ] ~= nil then
			running_data[ index ] = Windows[ index ]:GetRunningTimer()
		end

	end


    if Language.Local == Language.English then
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_running_timer_" .. Language[ Language.English ], running_data, nil)

    else
        local converted = Options.ConvertToEuro(running_data)
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_running_timer_" .. Language[ Language.Local ], converted, nil)

    end

end
---------------------------------------------------------------------------------------------------





























---------------------------------------------------------------------------------------------------
-- fix for german/french client
---------------------------------------------------------------------------------------------------

function Options.ConvertToEuro(dataRaw)
	local newData = {};
	for i, myData in pairs(dataRaw) do
		local tempIndex = nil;
		local tempData = nil;
		if (type(i) == "number") then
			tempIndex = tostring(i);
		else
			tempIndex = i;
		end
		if (type(myData) == "table") then
			tempData = Options.ConvertToEuro(myData);
		elseif (type(myData) == "number") then
			tempData = tostring(myData);
		else
			tempData = myData;
		end
		newData[tempIndex] = tempData;
	end
	return newData;
end

---------------------------------------------------------------------------------------------------