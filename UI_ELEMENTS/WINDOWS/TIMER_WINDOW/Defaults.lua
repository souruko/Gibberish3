--=================================================================================================
--= ListBox Defaults
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
Window[ Window.Types.TIMER_WINDOW ].Defaults                         = {}

-- default settings
Window[ Window.Types.TIMER_WINDOW ].Defaults.description             = ""
Window[ Window.Types.TIMER_WINDOW ].Defaults.resetOnTargetChange     = false
Window[ Window.Types.TIMER_WINDOW ].Defaults.useTargetEntity         = false

Window[ Window.Types.TIMER_WINDOW ].Defaults.width                   = 150
Window[ Window.Types.TIMER_WINDOW ].Defaults.height                  = 20
Window[ Window.Types.TIMER_WINDOW ].Defaults.left                    = 0.1
Window[ Window.Types.TIMER_WINDOW ].Defaults.top                     = 0.1
Window[ Window.Types.TIMER_WINDOW ].Defaults.frame                   = 1
Window[ Window.Types.TIMER_WINDOW ].Defaults.spacing                 = 4
Window[ Window.Types.TIMER_WINDOW ].Defaults.direction               = Direction.Descending
Window[ Window.Types.TIMER_WINDOW ].Defaults.orientation             = Orientation.Vertical
Window[ Window.Types.TIMER_WINDOW ].Defaults.overlay                 = false

Window[ Window.Types.TIMER_WINDOW ].Defaults.color1                  = {R=0, G=0, B=0}
Window[ Window.Types.TIMER_WINDOW ].Defaults.color2                  = {R=0.11, G=0.56, B=1}
Window[ Window.Types.TIMER_WINDOW ].Defaults.color3                  = {R=0, G=0, B=0}
Window[ Window.Types.TIMER_WINDOW ].Defaults.color4                  = {R=1, G=1, B=1}
Window[ Window.Types.TIMER_WINDOW ].Defaults.color5                  = {R=1, G=1, B=1}

Window[ Window.Types.TIMER_WINDOW ].Defaults.opacityActiv            = 0.5
Window[ Window.Types.TIMER_WINDOW ].Defaults.opacityPassiv           = 0.5

Window[ Window.Types.TIMER_WINDOW ].Defaults.font                    = 4
Window[ Window.Types.TIMER_WINDOW ].Defaults.fontSize                = 20
Window[ Window.Types.TIMER_WINDOW ].Defaults.durationFormat          = NumberFormat.Minutes
Window[ Window.Types.TIMER_WINDOW ].Defaults.textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Window[ Window.Types.TIMER_WINDOW ].Defaults.timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Window[ Window.Types.TIMER_WINDOW ].Defaults.showTimer               = true
Window[ Window.Types.TIMER_WINDOW ].Defaults.showIcon                = false

-- allowed timer
Window[ Window.Types.TIMER_WINDOW ].Defaults.allowedTimers           = {}
Window[ Window.Types.TIMER_WINDOW ].Defaults.allowedTimers[1]        = Timer.Types.BAR
Window[ Window.Types.TIMER_WINDOW ].Defaults.allowedTimers[2]        = Timer.Types.ICON
Window[ Window.Types.TIMER_WINDOW ].Defaults.allowedTimers[3]        = Timer.Types.TEXT
Window[ Window.Types.TIMER_WINDOW ].Defaults.allowedTimers[4]        = Timer.Types.CIRCEL
---------------------------------------------------------------------------------------------------