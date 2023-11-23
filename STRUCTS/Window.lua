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
    window.id                    = Data.GetNextWindowID()
    window.sortIndex             = Data.GetNextSortIndex()
    window.nextTimerSortIndex    = 1
    window.name                  = name
    window.folder                = nil
    window.type                  = type
    window.timerType             = Window[type].Defaults.timerType
    window.enabled               = true
    window.saveGlobaly           = true
    window.description           = Window[type].Defaults.description
    window.resetOnTargetChange   = Window[type].Defaults.resetOnTargetChange
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
    window.overlay               = Window[type].Defaults.overlay

    -- color / opacity
    window.color1                = Window[type].Defaults.color1
    window.color2                = Window[type].Defaults.color2
    window.color3                = Window[type].Defaults.color3
    window.color4                = Window[type].Defaults.color4
    window.color5                = Window[type].Defaults.color5

    window.opacityActiv          = Window[type].Defaults.opacityActiv
    window.opacityPassiv         = Window[type].Defaults.opacityPassiv

    -- text
    window.font                  = Window[type].Defaults.font
    window.fontSize              = Window[type].Defaults.fontSize
    window.durationFormat        = Window[type].Defaults.durationFormat
    window.textAlignment         = Window[type].Defaults.textAlignment
    window.timerAlignment        = Window[type].Defaults.timerAlignment
    window.showTimer             = Window[type].Defaults.showTimer

    window.counterDirection      = Window[type].Defaults.counterDirection

    -- create trigger tables
    for index, triggerType in pairs( Trigger.Types ) do

        window[triggerType]      = {}

    end

    local index = #Data.window + 1
    Data.window[index] = window

    return index

end
---------------------------------------------------------------------------------------------------


