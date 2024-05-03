--=================================================================================================
--= Window Struct        
--= ===============================================================================================
--= window struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create new window struct and return index
---------------------------------------------------------------------------------------------------
function Window.New(name, type)

    local window = {}

    -- general
    window.id                    = DataFunction.GetNextWindowID()
    window.sortIndex             = DataFunction.GetNextSortIndex()
    window.nextTimerSortIndex    = 1
    window.name                  = name
    window.folder                = nil
    window.type                  = type
    window.timerType             = Window[type].Defaults.timerType
    window.enabled               = true
    window.saveGlobaly           = true
    window.description           = Window[type].Defaults.description
    window.resetOnTargetChanged   = Window[type].Defaults.resetOnTargetChanged
    window.useTargetEntity       = Window[type].Defaults.useTargetEntity

    -- position / size
    window.left                  = Window[type].Defaults.left
    window.top                   = Window[type].Defaults.top
    window.width                 = Window[type].Defaults.width
    window.height                = Window[type].Defaults.height
    window.frame                 = Window[type].Defaults.frame
    window.spacing               = Window[type].Defaults.spacing
    window.direction             = Window[type].Defaults.direction
    window.orientation           = Window[type].Defaults.orientation
    window.sort_direction        = Window[type].Defaults.sort_direction
    window.overlay               = Window[type].Defaults.overlay

    -- color / opacity
    window.color1                = Window[type].Defaults.color1
    window.color2                = Window[type].Defaults.color2
    window.color3                = Window[type].Defaults.color3
    window.color4                = Window[type].Defaults.color4
    window.color5                = Window[type].Defaults.color5
    window.color6                = Window[type].Defaults.color6
    window.color7                = Window[type].Defaults.color7
    window.color8                = Window[type].Defaults.color8
    window.color9                = Window[type].Defaults.color9

    window.opacityActiv          = Window[type].Defaults.opacityActiv
    window.opacityPassiv         = Window[type].Defaults.opacityPassiv
    window.opacityThreshold      = Window[type].Defaults.opacityThreshold

    -- text
    window.font                  = Window[type].Defaults.font
    window.fontSize              = Window[type].Defaults.fontSize
    window.durationFormat        = Window[type].Defaults.durationFormat
    window.textAlignment         = Window[type].Defaults.textAlignment
    window.timerAlignment        = Window[type].Defaults.timerAlignment
    window.showTimer             = Window[type].Defaults.showTimer

    window.thresholdFont         = Window[type].Defaults.thresholdFont
    window.thresholdFontSize     = Window[type].Defaults.thresholdFontSize

    window.timerType             = Window[type].Defaults.allowedTimers[1]
    window.timerList             = {}

    -- create trigger tables
    for index, triggerType in pairs( Trigger.Types ) do

        window[ triggerType ]      = {}

    end

    local index = #Data.window + 1
    Data.window[index] = window

    return index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- copy window struct and return index
---------------------------------------------------------------------------------------------------
function Window.Copy(index)

    local window = {}

    window.id                    = DataFunction.GetNextWindowID()
    window.sortIndex             = DataFunction.GetNextSortIndex()
    window.nextTimerSortIndex    = Data.window[index].nextTimerSortIndex

    window.enabled               = Data.window[index].enabled
    window.folder                = Data.window[index].folder
    window.name                  = Data.window[index].name
    window.type                  = Data.window[index].type

    -- general
    window.saveGlobaly           = Data.window[index].saveGlobaly
    window.description           = Data.window[index].description
    window.resetOnTargetChanged  = Data.window[index].resetOnTargetChanged
    window.useTargetEntity       = Data.window[index].useTargetEntity

    -- position / size
    window.left                  = Data.window[index].left
    window.top                   = Data.window[index].top
    window.width                 = Data.window[index].width
    window.height                = Data.window[index].height
    window.frame                 = Data.window[index].frame
    window.spacing               = Data.window[index].spacing
    window.direction             = Data.window[index].direction
    window.sort_direction        = Data.window[index].sort_direction
    window.orientation           = Data.window[index].orientation
    window.overlay               = Data.window[index].overlay

    -- color / opacity
    window.color1                  = {}
    window.color2                  = {}
    window.color3                  = {}
    window.color4                  = {}
    window.color5                  = {}
    window.color6                  = {}
    window.color7                  = {}
    window.color8                  = {}
    window.color9                  = {}
    
    window.color1.R                = Data.window[index].color1.R
    window.color2.R                = Data.window[index].color2.R
    window.color3.R                = Data.window[index].color3.R
    window.color4.R                = Data.window[index].color4.R
    window.color5.R                = Data.window[index].color5.R
    window.color6.R                = Data.window[index].color6.R
    window.color7.R                = Data.window[index].color7.R
    window.color8.R                = Data.window[index].color8.R
    window.color9.R                = Data.window[index].color9.R

    window.color1.G                = Data.window[index].color1.G
    window.color2.G                = Data.window[index].color2.G
    window.color3.G                = Data.window[index].color3.G
    window.color4.G                = Data.window[index].color4.G
    window.color5.G                = Data.window[index].color5.G
    window.color6.G                = Data.window[index].color6.G
    window.color7.G                = Data.window[index].color7.G
    window.color8.G                = Data.window[index].color8.G
    window.color9.G                = Data.window[index].color9.G

    window.color1.B                = Data.window[index].color1.B
    window.color2.B                = Data.window[index].color2.B
    window.color3.B                = Data.window[index].color3.B
    window.color4.B                = Data.window[index].color4.B
    window.color5.B                = Data.window[index].color5.B
    window.color6.B                = Data.window[index].color6.B
    window.color7.B                = Data.window[index].color7.B
    window.color8.B                = Data.window[index].color8.B
    window.color9.B                = Data.window[index].color9.B


    window.opacityActiv          = Data.window[index].opacityActiv
    window.opacityPassiv         = Data.window[index].opacityPassiv

    window.opacityThreshold      = Data.window[index].opacityThreshold

    -- text
    window.font                  = Data.window[index].font
    window.fontSize              = Data.window[index].fontSize
    window.durationFormat        = Data.window[index].durationFormat
    window.textAlignment         = Data.window[index].textAlignment
    window.timerAlignment        = Data.window[index].timerAlignment
    window.showTimer             = Data.window[index].showTimer

    window.thresholdFont                  = Data.window[index].thresholdFont
    window.thresholdFontSize              = Data.window[index].thresholdFontSize

    window.timerType             = Data.window[index].timerType
    window.timerList             = {}

    for i, timerData in ipairs( Data.window[index].timerList ) do
        window.timerList[ i ] = Timer.Copy( timerData )
    end


    -- create trigger tables
    for name, triggerType in pairs( Trigger.Types ) do

        window[ triggerType ]      = {}

        for i, triggerData in ipairs( Data.window[index][ triggerType ] ) do
            window[ triggerType ][ i ] = Trigger.Copy( triggerData )
        end

    end

    local newIndex = #Data.window + 1
    Data.window[newIndex] = window

    return newIndex

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete window
---------------------------------------------------------------------------------------------------
function Window.Delete(index)

    local window_count = #Data.window

    Data.window[ index ]        = Data.window[ window_count ]
    Data.window[ window_count ] = nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete window
---------------------------------------------------------------------------------------------------
function Window.AddTimer( windowIndex, timerData )

    local timerIndex = #Data.window[ windowIndex ].timerList+1

    timerData.sortIndex = Data.window[ windowIndex ].nextTimerSortIndex
    Data.window[ windowIndex ].nextTimerSortIndex = Data.window[ windowIndex ].nextTimerSortIndex + 1

    Data.window[ windowIndex ].timerList[ timerIndex ] = timerData

end
---------------------------------------------------------------------------------------------------
