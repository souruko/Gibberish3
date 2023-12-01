--=================================================================================================
--= ListBox Defaults
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
Window[ Window.Types.LISTBOX ].Defaults                         = {}

-- default settings
Window[ Window.Types.LISTBOX ].Defaults.description             = ""
Window[ Window.Types.LISTBOX ].Defaults.resetOnTargetChange     = false
Window[ Window.Types.LISTBOX ].Defaults.useTargetEntity         = false

Window[ Window.Types.LISTBOX ].Defaults.width                   = 150
Window[ Window.Types.LISTBOX ].Defaults.height                  = 20
Window[ Window.Types.LISTBOX ].Defaults.left                    = 0.1
Window[ Window.Types.LISTBOX ].Defaults.top                     = 0.1
Window[ Window.Types.LISTBOX ].Defaults.frame                   = 1
Window[ Window.Types.LISTBOX ].Defaults.spacing                 = 4
Window[ Window.Types.LISTBOX ].Defaults.direction               = Direction.Descending
Window[ Window.Types.LISTBOX ].Defaults.orientation             = Orientation.Vertical
Window[ Window.Types.LISTBOX ].Defaults.overlay                 = false

Window[ Window.Types.LISTBOX ].Defaults.color1                  = {R=0, G=0, B=0}
Window[ Window.Types.LISTBOX ].Defaults.color2                  = {R=0.11, G=0.56, B=1}
Window[ Window.Types.LISTBOX ].Defaults.color3                  = {R=0, G=0, B=0}
Window[ Window.Types.LISTBOX ].Defaults.color4                  = {R=1, G=1, B=1}
Window[ Window.Types.LISTBOX ].Defaults.color5                  = {R=1, G=1, B=1}

Window[ Window.Types.LISTBOX ].Defaults.opacityActiv            = 0.5
Window[ Window.Types.LISTBOX ].Defaults.opacityPassiv           = 0.5

Window[ Window.Types.LISTBOX ].Defaults.font                    = 4
Window[ Window.Types.LISTBOX ].Defaults.fontSize                = 20
Window[ Window.Types.LISTBOX ].Defaults.durationFormat          = NumberFormat.Minutes
Window[ Window.Types.LISTBOX ].Defaults.textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Window[ Window.Types.LISTBOX ].Defaults.timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Window[ Window.Types.LISTBOX ].Defaults.showTimer               = true
Window[ Window.Types.LISTBOX ].Defaults.showIcon                = false

-- allowed timer
Window[ Window.Types.LISTBOX ].Defaults.allowedTimers           = {}
Window[ Window.Types.LISTBOX ].Defaults.allowedTimers[1]        = Timer.Types.BAR
---------------------------------------------------------------------------------------------------