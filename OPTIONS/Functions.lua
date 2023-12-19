--=================================================================================================
--= Option Functions
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- selection changed
---------------------------------------------------------------------------------------------------
function Options.SelectionChanged( index )

    -- index = 0: clear selection
    -- index > 0: window selected
    -- index < 0: folder selected
    
    -- do nothing if selection didnt change
    if index == Data.selectedIndex then
        return
    end

    -- save new selection
    Data.selectedIndex = index


    Options.TimerSelectionChanged( 0 )
    Options.TriggerSelectionChanged( 0 )

    Windows.SelectionChanged()
    -- Folders.SelectionChanged()
    -- Move.SelectionChanged()
    -- OptionsWindow:SelectionChanged()
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer selection changed
---------------------------------------------------------------------------------------------------
function Options.TimerSelectionChanged( index )

    -- do nothing if selection didnt change
    if index == Data.selectedTimerIndex then
        return
    end
    
    -- OptionsWindow:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger selection changed
---------------------------------------------------------------------------------------------------
function Options.TriggerSelectionChanged( index )

    -- do nothing if selection didnt change
    if index == Data.selectedTriggerIndex then
        return
    end

    -- OptionsWindow:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- move changed
---------------------------------------------------------------------------------------------------
function Options.MoveChanged( value )

    -- do nothing if selection didnt change
    if value == Data.moveMode then
        return
    end

    -- save new selection
    Data.moveMode = value

    Windows.MoveChanged()
    
end
---------------------------------------------------------------------------------------------------
