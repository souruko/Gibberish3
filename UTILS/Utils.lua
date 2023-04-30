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



-------------------------------------------------------------------------------------
--      Description:    fix font from savedata
-------------------------------------------------------------------------------------
--        Parameter:    font number
-------------------------------------------------------------------------------------
--           Return:    font
-------------------------------------------------------------------------------------
function Utils.FontFix( number )
    
    if number == 1 then
        return Turbine.UI.Lotro.Font.Arial12;
    elseif number == 2 then
        return Turbine.UI.Lotro.Font.TrajanPro13;
    elseif number == 3 then
        return Turbine.UI.Lotro.Font.TrajanPro14;
    elseif number == 4 then
        return Turbine.UI.Lotro.Font.TrajanPro15;
    elseif number == 5 then
        return Turbine.UI.Lotro.Font.TrajanPro16;
    elseif number == 6 then
        return Turbine.UI.Lotro.Font.TrajanPro18;
    elseif number == 7 then
        return Turbine.UI.Lotro.Font.TrajanPro19;
    elseif number == 8 then
        return Turbine.UI.Lotro.Font.TrajanPro20;
    elseif number == 9 then
        return Turbine.UI.Lotro.Font.TrajanPro21;
    elseif number == 10 then
        return Turbine.UI.Lotro.Font.TrajanPro23;
    elseif number == 11 then
        return Turbine.UI.Lotro.Font.TrajanPro24;
    elseif number == 12 then
        return Turbine.UI.Lotro.Font.TrajanPro25;
    elseif number == 13 then
        return Turbine.UI.Lotro.Font.TrajanPro26;
    elseif number == 14 then
        return Turbine.UI.Lotro.Font.TrajanPro28;
    elseif number == 15 then
        return Turbine.UI.Lotro.Font.TrajanProBold16;
    elseif number == 16 then
        return Turbine.UI.Lotro.Font.TrajanProBold22;
    elseif number == 17 then
        return Turbine.UI.Lotro.Font.TrajanProBold24;
    elseif number == 18 then
        return Turbine.UI.Lotro.Font.TrajanProBold25;
    elseif number == 19 then
        return Turbine.UI.Lotro.Font.TrajanProBold30;
    elseif number == 20 then
        return Turbine.UI.Lotro.Font.TrajanProBold36;
    elseif number == 21 then
        return Turbine.UI.Lotro.Font.Verdana10;
    elseif number == 22 then
        return Turbine.UI.Lotro.Font.Verdana12;
    elseif number == 23 then
        return Turbine.UI.Lotro.Font.Verdana14;
    elseif number == 24 then
        return Turbine.UI.Lotro.Font.Verdana16;
    elseif number == 25 then
        return Turbine.UI.Lotro.Font.Verdana18;
    elseif number == 26 then
        return Turbine.UI.Lotro.Font.Verdana20;
    elseif number == 27 then
        return Turbine.UI.Lotro.Font.Verdana22;
    elseif number == 28 then
        return Turbine.UI.Lotro.Font.Verdana23;
    end

end