--===================================================================================
--             Name:    OPTION WINDOW Functions
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    openClose
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.MainWindow.OpenClose()

    if Options.MainWindow.Window == nil then
    
        Options.MainWindow.Window = Options.Constructor.OptionsWindow()

    else

        Options.MainWindow.Window:Finish()

        Options.MainWindow.Window = nil

    end
    
end

-------------------------------------------------------------------------------------
--      Description:    show tooltip
-------------------------------------------------------------------------------------
--        Parameter:    left, top, width, height, heading, text
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.MainWindow.ShowTooltip( left, top, width, height, heading, text )

    if Options.MainWindow.Window ~= nil then
    
        Options.MainWindow.Window:ShowTooltip( left, top, width, height, heading, text )

    end
    
end



-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.MainWindow.HideTooltip()

    if Options.MainWindow.Window ~= nil then
    
        Options.MainWindow.Window:HideTooltip()

    end
    
end
