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

-- colours, taken from the Nocturne palette the options panel is drawn in, so a
-- brand new window already looks like the rest of the plugin. The count fills
-- the bar with the accent over a dark track, the same way round as a timer bar
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color1                  = Options.Defaults.Nocturne("line")        -- frame
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color2                  = Options.Defaults.Nocturne("bg_sunken")   -- background
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color3                  = Options.Defaults.Nocturne("accent")      -- bar fill
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color4                  = Options.Defaults.Nocturne("text")        -- count number
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color5                  = Options.Defaults.Nocturne("text_muted")  -- label text
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color6                  = Options.Defaults.Nocturne("bg_sunken")   -- text outline
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color7                  = Options.Defaults.Nocturne("warn")        -- threshold background
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color8                  = Options.Defaults.Nocturne("text")        -- threshold number
Window[ Window.Types.COUNTER_WINDOW ].Defaults.color9                  = Options.Defaults.Nocturne("text")        -- threshold text

-- the panel is a solid dark surface; the HUD keeps a little of the world showing
-- through while running, drops back when idle, and goes solid on the threshold
Window[ Window.Types.COUNTER_WINDOW ].Defaults.opacityActiv            = 0.9
Window[ Window.Types.COUNTER_WINDOW ].Defaults.opacityPassiv           = 0.35
Window[ Window.Types.COUNTER_WINDOW ].Defaults.opacityThreshold        = 1

Window[ Window.Types.COUNTER_WINDOW ].Defaults.font                    = Font.Type.Verdana
Window[ Window.Types.COUNTER_WINDOW ].Defaults.fontSize                = 14
Window[ Window.Types.COUNTER_WINDOW ].Defaults.durationFormat          = NumberFormat.Minutes
Window[ Window.Types.COUNTER_WINDOW ].Defaults.textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Window[ Window.Types.COUNTER_WINDOW ].Defaults.timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Window[ Window.Types.COUNTER_WINDOW ].Defaults.showTimer               = true
Window[ Window.Types.COUNTER_WINDOW ].Defaults.showIcon                = false

Window[ Window.Types.COUNTER_WINDOW ].Defaults.timerType               = Timer.Types.COUNTER_BAR

-- a step up from the normal size, so entering the threshold is visible even
-- without the animation switched on
Window[ Window.Types.COUNTER_WINDOW ].Defaults.thresholdFont                    = Font.Type.Verdana
Window[ Window.Types.COUNTER_WINDOW ].Defaults.thresholdFontSize                = 16

-- allowed timer
Window[ Window.Types.COUNTER_WINDOW ].Defaults.allowedTimers           = {}
Window[ Window.Types.COUNTER_WINDOW ].Defaults.allowedTimers[1]        = Timer.Types.COUNTER_BAR
---------------------------------------------------------------------------------------------------