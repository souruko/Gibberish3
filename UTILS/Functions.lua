--=================================================================================================
--= Utility Functions        
--= ===============================================================================================
--= global library for utility functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- screen ratio to pixel ( for loading position )
---------------------------------------------------------------------------------------------------
function ScreenRatioToPixel( left, top )

    return math.round( left * Options.ScreenWidth ), math.round( top * Options.ScreenHeight )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- pixel to screen ratio ( for saving position )
---------------------------------------------------------------------------------------------------
function PixelToScreenRatio( left, top )

    return (left / Options.ScreenWidth), (top / Options.ScreenHeight)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fix get tourbine color from data
---------------------------------------------------------------------------------------------------
function ColorFix( color )

    return Turbine.UI.Color(color.R, color.G, color.B)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fix get tourbine color from data
---------------------------------------------------------------------------------------------------
local size_item = Turbine.UI.Control()
function GetImageSize( image )

    if image == nil then
        return 32, 32
    end

	size_item:SetBackground(image)
	size_item:SetStretchMode(2)

	return size_item:GetSize()
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- format timer 
---------------------------------------------------------------------------------------------------
function TimerFormat( seconds, format )

    -- plain seconds
    if format == NumberFormat.Seconds then

        return tostring( math.floor(seconds) )

    -- minutes and seconds
    elseif format == NumberFormat.Minutes then

        if seconds <= 0 then
            return "00:00";
        else

            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            return mins..":"..secs
        end

    -- one decimal place
    elseif format == NumberFormat.OneDecimal then

        -- local value =  tostring( math.floor(seconds * 10) / 10)
        local value = string.format("%.1f", seconds)

        return value

    end

end
---------------------------------------------------------------------------------------------------
