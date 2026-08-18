-- One global font size for the options panel and the move window.
--
-- Every font and every text-bearing pixel metric in OPTIONS2 comes from here, so
-- a player who cannot read the smaller text can scale the whole panel in one go.
-- The in-game timer overlays are untouched; they have their own per-window font.
--
-- Lives on the root Options2 table: Turbine gives each package directory its own
-- environment, so a bare global here would be invisible to OPTIONS2/**.
--
-- Two things the rest of the code has to respect:
--   * fonts and metrics are read at *construct* time, never captured at file
--     load time, because changing the setting rebuilds every window;
--   * a module with pixel metrics of its own registers a refresh function that
--     recomputes them, rather than each call site scaling on the fly.

Options2.Fonts = {}
local F = Options2.Fonts

F.Scale = {}
F.Scale.NORMAL = 1
F.Scale.LARGE  = 2
F.Scale.XLARGE = 3

-- The API only registers even Verdana sizes (see the Font table in Constants.lua),
-- so the steps snap to sizes that exist instead of applying a free multiplier.
local STEPS = {}
STEPS[ F.Scale.NORMAL ] = { small = 10, body = 12, title = 14 }
STEPS[ F.Scale.LARGE  ] = { small = 12, body = 14, title = 16 }
STEPS[ F.Scale.XLARGE ] = { small = 14, body = 16, title = 18 }

-- current state; Apply overwrites all of it
F.scale = F.Scale.NORMAL
F.ratio = 1                                     -- body size / 12
F.small = 10
F.body  = 12
F.title = 14
F.SMALL = Font[ Font.Type.Verdana ][ 10 ]
F.BODY  = Font[ Font.Type.Verdana ][ 12 ]
F.TITLE = Font[ Font.Type.Verdana ][ 14 ]

-- scale a pixel metric that has to hold text; padding and art do not use this
function F.Px( base )
    return math.floor( base * F.ratio + 0.5 )
end

-- keep a window minimum inside the screen; 0.98 leaves the edges visible
local function fit( value, screen )
    if type( screen ) ~= "number" or screen < 400 then return value end
    return math.min( value, math.floor( screen * 0.98 ) )
end

local function fit_width( w )
    return fit( w, Options.ScreenWidth )
end

local function fit_height( h )
    return fit( h, Options.ScreenHeight )
end

local _refresh = {}

-- a module hands over a function that recomputes its own metrics
function F.Register( fn )
    _refresh[ #_refresh + 1 ] = fn
end

function F.IsValid( scale )
    return STEPS[ scale ] ~= nil
end

function F.Current()
    if Data ~= nil and Data.options ~= nil and Data.options.window ~= nil then
        local saved = Data.options.window.fontScale
        if F.IsValid( saved ) then return saved end
    end
    return Options.Defaults.window.font_scale
end

function F.Apply( scale )
    if not F.IsValid( scale ) then scale = Options.Defaults.window.font_scale end

    local step = STEPS[ scale ]

    F.scale = scale
    F.small = step.small
    F.body  = step.body
    F.title = step.title
    F.ratio = step.body / 12

    F.SMALL = Font[ Font.Type.Verdana ][ step.small ]
    F.BODY  = Font[ Font.Type.Verdana ][ step.body ]
    F.TITLE = Font[ Font.Type.Verdana ][ step.title ]

    -- the shared defaults, so their many consumers need no change of their own
    Options.Defaults.window.font               = F.BODY
    Options.Defaults.rc_menu.font              = F.BODY
    Options.Defaults.tooltip.font              = F.TITLE
    Options.Defaults.move.headerfont           = F.TITLE

    -- The panel opens at its minimum and the gripper cannot drag below it, so a
    -- minimum larger than the screen would trap the player in a window they
    -- cannot shrink. On a screen too small for the chosen size the columns clip
    -- instead, which they are laid out to survive.
    Options.Defaults.window.min_width          = fit_width(  F.Px( 1168 ) )
    Options.Defaults.window.min_height         = fit_height( F.Px( 640 ) )
    Options.Defaults.window.min_width_simple   = fit_width(  F.Px( 1020 ) )
    Options.Defaults.window.min_height_simple  = fit_height( F.Px( 560 ) )

    Options.Defaults.rc_menu.item_height       = F.Px( 24 )
    Options.Defaults.shortcut.menu_width       = F.Px( 125 )
    Options.Defaults.tooltip.width             = F.Px( 200 )

    Options.Defaults.dropdown.base_height      = F.Px( 20 )
    Options.Defaults.dropdown.item_height      = F.Px( 20 )
    Options.Defaults.dropdown.item_line_height = F.Px( 25 )

    Options.Defaults.move.width                = F.Px( 172 )
    Options.Defaults.move.height               = F.Px( 262 )

    for _, fn in ipairs( _refresh ) do
        fn()
    end
end
