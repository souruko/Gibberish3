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
Options.Defaults.move.seleced       = Turbine.UI.Color.LimeGreen
Options.Defaults.move.notSeleced    = Turbine.UI.Color.White
Options.Defaults.move.sbackground   = Turbine.UI.Color( 0.3, 0.3, 0.3 )
Options.Defaults.move.nbackground   = Turbine.UI.Color( 0.1, 0.1, 0.1 )

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
Options.Defaults.move.width          = 150
Options.Defaults.move.height         = 272
Options.Defaults.move.headerfont     = Turbine.UI.Lotro.Font.Verdana14
Options.Defaults.move.headerstyle    = Turbine.UI.FontStyle.Outline
Options.Defaults.move.labelalignment = Turbine.UI.ContentAlignment.MiddleRight
Options.Defaults.move.backcolor      = Turbine.UI.Color( 0.1, 0.1, 0.1 )
Options.Defaults.move.headercolor    = Turbine.UI.Color( 0.3, 0.3, 0.3 )

-- optiosn window
Options.Defaults.window              = {}
Options.Defaults.window.min_width    = 1168
Options.Defaults.window.min_height   = 640
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

-- options panel palette (rework) --------------------------------------------
Options.Defaults.window.bg           = Turbine.UI.Color(0.086, 0.094, 0.149) -- panel ground
Options.Defaults.window.bg_sunken    = Turbine.UI.Color(0.071, 0.078, 0.122) -- columns, fields
Options.Defaults.window.row_odd      = Turbine.UI.Color(0.114, 0.125, 0.196)
Options.Defaults.window.row_even     = Turbine.UI.Color(0.102, 0.114, 0.173)
Options.Defaults.window.select       = Turbine.UI.Color(0.137, 0.153, 0.255)
Options.Defaults.window.line         = Turbine.UI.Color(0.180, 0.196, 0.314)
Options.Defaults.window.text         = Turbine.UI.Color(0.914, 0.914, 0.929)
Options.Defaults.window.text_muted   = Turbine.UI.Color(0.545, 0.561, 0.659)
Options.Defaults.window.text_faint   = Turbine.UI.Color(0.361, 0.376, 0.463)
Options.Defaults.window.accent       = Turbine.UI.Color(0.569, 0.518, 0.851)
Options.Defaults.window.paste_border = Turbine.UI.Color(0.310, 0.647, 0.392)
Options.Defaults.window.on           = Turbine.UI.Color(0.200, 0.749, 0.302)
Options.Defaults.window.off_border   = Turbine.UI.Color(0.290, 0.306, 0.400)
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
