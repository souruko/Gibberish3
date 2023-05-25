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



-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.MainWindow.Copy( itemType, folderIndex, groupIndex, timerIndex, triggerIndex )

    Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy
    Options.CopyCache.itemType      = itemType
    Options.CopyCache.folderIndex   = folderIndex
    Options.CopyCache.groupIndex    = groupIndex
    Options.CopyCache.timerIndex    = timerIndex
    Options.CopyCache.triggerIndex  = triggerIndex

end

-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.MainWindow.Cut( itemType, folderIndex, groupIndex, timerIndex, triggerIndex )

    Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Cut
    Options.CopyCache.itemType      = itemType
    Options.CopyCache.folderIndex   = folderIndex
    Options.CopyCache.groupIndex    = groupIndex
    Options.CopyCache.timerIndex    = timerIndex
    Options.CopyCache.triggerIndex  = triggerIndex


end


-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.MainWindow.Paste( targetType )

    if Options.CopyCache.itemType ~= nil and targetType == Options.CopyCache.itemType then


        -- change cut to copy after first paste 
        if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
            Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy
        end
        
    end

end
