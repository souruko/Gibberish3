--=================================================================================================
--= Options defaults        
--= ===============================================================================================
--= definitions for globaly used defaults
--=================================================================================================




---------------------------------------------------------------------------------------------------
-- moveLabel
Options.Defaults.move               = {}
Options.Defaults.move.TextAlignment = Turbine.UI.ContentAlignment.MiddleCenter
Options.Defaults.move.Font          = Turbine.UI.Lotro.Font.Verdana12
Options.Defaults.move.FontStyle     = Turbine.UI.FontStyle.Outline
Options.Defaults.move.FrameSize     = 2
-- the placeholder colours are assigned further down, once the panel palette
-- they are drawn from exists

-- timer
Options.Defaults.timer               = {}
Options.Defaults.timer.fontStyle     = Turbine.UI.FontStyle.Outline
Options.Defaults.timer.labelSpacing  = 4

-- shortcut
Options.Defaults.shortcut            = {}
Options.Defaults.shortcut.size       = 50
Options.Defaults.shortcut.min_size   = 30
Options.Defaults.shortcut.max_size   = 80
Options.Defaults.shortcut.size_step  = 5
Options.Defaults.shortcut.menu_width = 125

-- move window
Options.Defaults.move.width          = 172
Options.Defaults.move.height         = 262
Options.Defaults.move.headerfont     = Turbine.UI.Lotro.Font.Verdana14
Options.Defaults.move.headerstyle    = Turbine.UI.FontStyle.Outline
Options.Defaults.move.labelalignment = Turbine.UI.ContentAlignment.MiddleRight

-- optiosn window
Options.Defaults.window              = {}
Options.Defaults.window.min_width    = 1168
Options.Defaults.window.min_height   = 640
-- simple mode drops the contents and library columns, so it needs less room
Options.Defaults.window.min_width_simple  = 1020
Options.Defaults.window.min_height_simple = 560
Options.Defaults.window.ws_width     = 250
Options.Defaults.window.c_width      = 200
Options.Defaults.window.g_height     = 50
Options.Defaults.window.spacing      = 5
Options.Defaults.window.frame        = 2
Options.Defaults.window.font         = Turbine.UI.Lotro.Font.Verdana12
Options.Defaults.window.basecolor    = Turbine.UI.Color( 0.16, 0.13, 0.10 )
Options.Defaults.window.backcolor1   = Turbine.UI.Color( 0.09, 0.08, 0.07 )
Options.Defaults.window.backcolor2   = Turbine.UI.Color( 0.09, 0.08, 0.07 )
Options.Defaults.window.framecolor   = Turbine.UI.Color( 0.44, 0.37, 0.22 )
Options.Defaults.window.hovercolor   = Turbine.UI.Color( 0.21, 0.18, 0.14 )
Options.Defaults.window.collecting   = Turbine.UI.Color.DarkGreen
Options.Defaults.window.textcolor    = Turbine.UI.Color.White--Turbine.UI.Color( 0.6, 0.6, 0.6 )
Options.Defaults.window.segmenthover = Turbine.UI.Color( 0.15, 0.15, 0.15 )
Options.Defaults.window.toolbar_height = 25
Options.Defaults.window.tab_height   = 25
Options.Defaults.window.tab_width    = 132
Options.Defaults.window.tab_c_left   = 5
Options.Defaults.window.tab_c_top    = 10
Options.Defaults.window.textdark     =  Turbine.UI.Color( 0.62, 0.54, 0.40 )

Options.Defaults.window.g_content_top  = - 2

Options.Defaults.window.t_item_height   = 34
Options.Defaults.window.w_item_height   = 32
Options.Defaults.window.w_font          = Turbine.UI.Lotro.Font.Verdana16
Options.Defaults.window.w_window_base   = Turbine.UI.Color( 0.1, 0.1, 0.1 )
Options.Defaults.window.w_window_hover  = Turbine.UI.Color(0.3,0.3,0.3)
Options.Defaults.window.w_window_select = Turbine.UI.Color(0.18,0.18,0.18)

Options.Defaults.window.w_folder_base   = Turbine.UI.Color(0.18, 0.14, 0.04)
Options.Defaults.window.w_folder_hover  = Turbine.UI.Color(0.28, 0.22, 0.06)
Options.Defaults.window.w_folder_select = Turbine.UI.Color(0.22, 0.18, 0.05)
Options.Defaults.window.w_folder_frame  = 1

Options.Defaults.window.color_folder  = Turbine.UI.Color(0.72, 0.52, 0.08)
Options.Defaults.window.color_window  = Turbine.UI.Color(0.14, 0.48, 0.72)
Options.Defaults.window.color_timer   = Turbine.UI.Color(0.10, 0.62, 0.46)
Options.Defaults.window.color_trigger = Turbine.UI.Color(0.82, 0.40, 0.08)
Options.Defaults.window.color_cond    = Turbine.UI.Color(0.55, 0.18, 0.75)

-- Nocturne palette ------------------------------------------------------------
-- The one place the plugin's colours are written down. They are kept as plain
-- { R, G, B } tables rather than Turbine.UI.Color because the HUD defaults in
-- UI_ELEMENTS/WINDOWS/*/Defaults.lua are copied straight into saved window data,
-- and a Turbine.UI.Color cannot be serialised. The options panel's own colours
-- are built from these same numbers just below.
Options.Defaults.nocturne = {
    bg           = { R = 0.086, G = 0.094, B = 0.149 },  -- panel ground
    bg_sunken    = { R = 0.071, G = 0.078, B = 0.122 },  -- columns, fields
    row_odd      = { R = 0.114, G = 0.125, B = 0.196 },
    row_even     = { R = 0.102, G = 0.114, B = 0.173 },
    select       = { R = 0.137, G = 0.153, B = 0.255 },
    line         = { R = 0.180, G = 0.196, B = 0.314 },
    text         = { R = 0.914, G = 0.914, B = 0.929 },
    text_muted   = { R = 0.545, G = 0.561, B = 0.659 },
    text_faint   = { R = 0.361, G = 0.376, B = 0.463 },
    accent       = { R = 0.569, G = 0.518, B = 0.851 },
    paste_border = { R = 0.310, G = 0.647, B = 0.392 },
    on           = { R = 0.200, G = 0.749, B = 0.302 },
    off_border   = { R = 0.290, G = 0.306, B = 0.400 },
    -- the alert counterpart of "on", used by the HUD for threshold state; the
    -- panel has nothing that needs it
    warn         = { R = 0.749, G = 0.200, B = 0.282 },
}

---------------------------------------------------------------------------------------------------
-- a fresh { R, G, B } copy of a palette entry, so callers can hand it to window
-- data without every window ending up sharing the one palette table
---------------------------------------------------------------------------------------------------
function Options.Defaults.Nocturne( name )

    local color = Options.Defaults.nocturne[ name ]

    return { R = color.R, G = color.G, B = color.B }

end
---------------------------------------------------------------------------------------------------

-- options panel palette, drawn from the Nocturne colours above ------------------
local function panel_color( name )
    local color = Options.Defaults.nocturne[ name ]
    return Turbine.UI.Color( color.R, color.G, color.B )
end

Options.Defaults.window.bg           = panel_color("bg")
Options.Defaults.window.bg_sunken    = panel_color("bg_sunken")
Options.Defaults.window.row_odd      = panel_color("row_odd")
Options.Defaults.window.row_even     = panel_color("row_even")
Options.Defaults.window.select       = panel_color("select")
Options.Defaults.window.line         = panel_color("line")
Options.Defaults.window.text         = panel_color("text")
Options.Defaults.window.text_muted   = panel_color("text_muted")
Options.Defaults.window.text_faint   = panel_color("text_faint")
Options.Defaults.window.accent       = panel_color("accent")
Options.Defaults.window.paste_border = panel_color("paste_border")
Options.Defaults.window.on           = panel_color("on")
Options.Defaults.window.off_border   = panel_color("off_border")
------------------------------------------------------------------------------

-- move mode, drawn from the palette above ------------------------------------
-- The placeholder that covers each HUD window while move mode is on. Selected
-- takes the accent, the rest take the ordinary border colour, which is the same
-- selected/idle language the options panel uses everywhere else.
Options.Defaults.move.seleced       = Options.Defaults.window.accent
Options.Defaults.move.notSeleced    = Options.Defaults.window.line
Options.Defaults.move.sbackground   = Options.Defaults.window.select
Options.Defaults.move.nbackground   = Options.Defaults.window.bg_sunken
Options.Defaults.move.textcolor     = Options.Defaults.window.text

-- The crosshair keeps a dark core against a bright edge: it is drawn over the
-- game world, not over the panel, so it cannot rely on a known background.
Options.Defaults.move.guide         = Options.Defaults.window.accent
Options.Defaults.move.guide_core    = Options.Defaults.window.bg_sunken
------------------------------------------------------------------------------

Options.Defaults.window.menu_width      = 140
Options.Defaults.window.file_width      = 130
Options.Defaults.window.segment_height  = 25
Options.Defaults.window.segment_item_height  = 36

-- rightclick menu
Options.Defaults.rc_menu                    = {}
Options.Defaults.rc_menu.spacing            = 5
Options.Defaults.rc_menu.item_height        = 24
Options.Defaults.rc_menu.seperator_height   = 10
Options.Defaults.rc_menu.text_left          = 32
Options.Defaults.rc_menu.font               = Turbine.UI.Lotro.Font.Verdana12
Options.Defaults.rc_menu.back_color         = Options.Defaults.window.bg_sunken
Options.Defaults.rc_menu.hover_color        = Options.Defaults.window.select
Options.Defaults.rc_menu.border_color       = Options.Defaults.window.line
Options.Defaults.rc_menu.text_color         = Options.Defaults.window.text

-- tooltip
Options.Defaults.tooltip                    = {}
Options.Defaults.tooltip.backcolor1         = Options.Defaults.window.line
Options.Defaults.tooltip.backcolor2         = Options.Defaults.window.bg_sunken
Options.Defaults.tooltip.frame              = 1
Options.Defaults.tooltip.width              = 200
Options.Defaults.tooltip.left_shift         = 70
Options.Defaults.tooltip.top_shift          = 40
Options.Defaults.tooltip.font               = Turbine.UI.Lotro.Font.Verdana14
Options.Defaults.tooltip.activation_delay   = 1

-- drop down
Options.Defaults.dropdown                    = {}
Options.Defaults.dropdown.base_height        = 20
Options.Defaults.dropdown.item_height        = 20
Options.Defaults.dropdown.item_line_height   = 25
Options.Defaults.dropdown.spacing            = 2
-- drawn from the panel palette above so every dropdown matches the theme
Options.Defaults.dropdown.base_color         = Options.Defaults.window.bg_sunken
Options.Defaults.dropdown.show_color         = Options.Defaults.window.select
Options.Defaults.dropdown.back_color         = Options.Defaults.window.bg_sunken
Options.Defaults.dropdown.hover_color        = Options.Defaults.window.row_odd
Options.Defaults.dropdown.selected_color     = Options.Defaults.window.accent
Options.Defaults.dropdown.nselected_color    = Options.Defaults.window.text
Options.Defaults.dropdown.border_color       = Options.Defaults.window.line
---------------------------------------------------------------------------------------------------
