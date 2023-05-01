--===================================================================================
--             Name:    Utils
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    convert screen ratio to pixel
-------------------------------------------------------------------------------------
--        Parameter:    left    as % of screen
--                      top     as % of screen
-------------------------------------------------------------------------------------
--           Return:    left    in pixel
--                      top     in pixel
-------------------------------------------------------------------------------------
function Utils.ScreenRatioToPixel( left, top )
    return math.round( left * ScreenWidth ), math.round( top * ScreenHeight )
end



-------------------------------------------------------------------------------------
--      Description:    convert pixel to screen ratio
-------------------------------------------------------------------------------------
--        Parameter:    left    in pixel
--                      top     in pixel
-------------------------------------------------------------------------------------
--           Return:    left    as % of screen
--                      top     as % of screen
-------------------------------------------------------------------------------------
function Utils.PixelToScreenRatio( left, top )

    return (left / ScreenWidth), (top / ScreenHeight)

end



-------------------------------------------------------------------------------------
--      Description:    fix color from savedata
-------------------------------------------------------------------------------------
--        Parameter:    color
-------------------------------------------------------------------------------------
--           Return:    color R / G / B
-------------------------------------------------------------------------------------
function Utils.ColorFix( color )

    return Turbine.UI.Color(color.R, color.G, color.B)

end




local size_item = Turbine.UI.Control()
-------------------------------------------------------------------------------------
--      Description:    get image size
-------------------------------------------------------------------------------------
--        Parameter:    image
-------------------------------------------------------------------------------------
--           Return:    width / height
-------------------------------------------------------------------------------------
function Utils.GetImageSize(image)

	size_item:SetBackground(image)
	size_item:SetStretchMode(2)

	return size_item:GetSize()
    
end



-------------------------------------------------------------------------------------
--      Description:    format time
-------------------------------------------------------------------------------------
--        Parameter:    seconds
--                      format
-------------------------------------------------------------------------------------
--           Return:    formated string
-------------------------------------------------------------------------------------
function Utils.SecondsToClock(seconds, format)

    if format == 1 then

        return tostring( math.floor(seconds) )

    elseif format == 2 then

        local seconds = tonumber(seconds)

        if seconds <= 0 then
            return "00:00";
        else

            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            return mins..":"..secs
        end

    end

end