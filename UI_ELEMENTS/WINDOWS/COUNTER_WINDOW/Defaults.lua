--=================================================================================================
--= ListBox Defaults
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
Window[ Window.Types.COUNTER_WINDOW ].Defaults                         = {}

-- default settings
Window[ Window.Types.COUNTER_WINDOW ].Defaults.description             = ""
Window[ Window.Types.COUNTER_WINDOW ].Defaults.resetOnTargetChange     = false
Window[ Window.Types.COUNTER_WINDOW ].Defaults.useTargetEntity         = false

Window[ Window.Types.COUNTER_WINDOW ].Defaults.width                   = 150
Window[ Window.Types.COUNTER_WINDOW ].Defaults.height                  = 20
Window[ Window.Types.COUNTER_WINDOW ].Defaults.left                    = 0.1
Window[ Window.Types.COUNTER_WINDOW ].Defaults.top                     = 0.1
Window[ Window.Types.COUNTER_WINDOW ].Defaults.frame                   = 1
Window[ Window.Types.COUNTER_WINDOW ].Defaults.spacing                 = 4
Window[ Window.Types.COUNTER_WINDOW ].Defaults.direction               = Direction.Descending
Window[ Window.Types.COUNTER_WINDOW ].Defaults.sort_direction          = Direction.Descending
Window[ Window.Types.COUNTER_WINDOW ].Defaults.orientation             = Orientation.Vertical
Window[ Window.Types.COUNTER_WINDOW ].Defaults.overlay                 = false

Window[ Window.Types.COUNTER_WINDOW ].Defaults.color1                  = {R=0, G=0, B=0}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color2                  = {R=0.11, G=0.56, B=1}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color3                  = {R=0, G=0, B=0}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color4                  = {R=1, G=1, B=1}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color5                  = {R=1, G=1, B=1}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color6                  = {R=1, G=1, B=1}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color7                  = {R=1, G=0, B=0}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color8                  = {R=1, G=1, B=1}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color9                  = {R=1, G=1, B=1}

Window[ Window.Types.COUNTER_WINDOW ].Defaults.opacityActiv            = 0.5
Window[ Window.Types.COUNTER_WINDOW ].Defaults.opacityPassiv           = 0.5
Window[ Window.Types.COUNTER_WINDOW ].Defaults.opacityThreshold        = 0.5

Window[ Window.Types.COUNTER_WINDOW ].Defaults.font                    = 4
Window[ Window.Types.COUNTER_WINDOW ].Defaults.fontSize                = 20
Window[ Window.Types.COUNTER_WINDOW ].Defaults.durationFormat          = NumberFormat.Minutes
Window[ Window.Types.COUNTER_WINDOW ].Defaults.textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Window[ Window.Types.COUNTER_WINDOW ].Defaults.timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Window[ Window.Types.COUNTER_WINDOW ].Defaults.showTimer               = true
Window[ Window.Types.COUNTER_WINDOW ].Defaults.showIcon                = false

Window[ Window.Types.COUNTER_WINDOW ].Defaults.timerType               = Timer.Types.COUNTER_BAR

Window[ Window.Types.COUNTER_WINDOW ].Defaults.thresholdFont                    = 4
Window[ Window.Types.COUNTER_WINDOW ].Defaults.thresholdFontSize                = 20

-- allowed timer
Window[ Window.Types.COUNTER_WINDOW ].Defaults.allowedTimers           = {}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.allowedTimers[1]        = Timer.Types.COUNTER_BAR
---------------------------------------------------------------------------------------------------