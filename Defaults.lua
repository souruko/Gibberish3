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
Options.Defaults.window.min_width    = 1304
Options.Defaults.window.max_width    = 1304
Options.Defaults.window.min_height   = 700
Options.Defaults.window.ws_width     = 250
Options.Defaults.window.c_width      = 200
Options.Defaults.window.g_height     = 50
Options.Defaults.window.spacing      = 5
Options.Defaults.window.frame        = 2
Options.Defaults.window.top_spacing  = 35
Options.Defaults.window.outer_spacing= 10
Options.Defaults.window.font         = Turbine.UI.Lotro.Font.Verdana12
Options.Defaults.window.basecolor    = Turbine.UI.Color( 0.18, 0.18, 0.18 )
Options.Defaults.window.backcolor1   = Turbine.UI.Color( 0.1, 0.1, 0.1 )
Options.Defaults.window.backcolor2   = Turbine.UI.Color( 0.1, 0.1, 0.1 )--Turbine.UI.Color( 0.18, 0.18, 0.18 )
Options.Defaults.window.framecolor   = Turbine.UI.Color( 0.6, 0.6, 0.6 )
Options.Defaults.window.collecting   = Turbine.UI.Color.DarkGreen
Options.Defaults.window.textcolor    = Turbine.UI.Color.White--Turbine.UI.Color( 0.6, 0.6, 0.6 )
Options.Defaults.window.segmenthover = Turbine.UI.Color( 0.15, 0.15, 0.15 )
Options.Defaults.window.toolbar_height = 25
Options.Defaults.window.tab_height   = 25
Options.Defaults.window.tab_width    = 132
Options.Defaults.window.tab_c_left   = 5
Options.Defaults.window.tab_c_top    = 10
Options.Defaults.window.textdark     =  Turbine.UI.Color( 0.6, 0.6, 0.6 )

Options.Defaults.window.g_content_top  = - 2

Options.Defaults.window.t_item_height   = 34
Options.Defaults.window.w_item_height   = 32
Options.Defaults.window.w_font          = Turbine.UI.Lotro.Font.Verdana16
Options.Defaults.window.w_window_base   = Turbine.UI.Color( 0.1, 0.1, 0.1 )
Options.Defaults.window.w_window_hover  = Turbine.UI.Color(0.3,0.3,0.3)
Options.Defaults.window.w_window_select = Turbine.UI.Color(0.18,0.18,0.18)

Options.Defaults.window.w_folder_base   = Turbine.UI.Color(0.15,0.15,0.35)
Options.Defaults.window.w_folder_hover  = Turbine.UI.Color(0.4,0.4,0.6)
Options.Defaults.window.w_folder_select = Turbine.UI.Color(0.25,0.25,0.45)
Options.Defaults.window.w_folder_frame  = 1
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
Options.Defaults.rc_menu.back_color         = Turbine.UI.Color.Black--Turbine.UI.Color( 0.15, 0.15, 0.15 )
Options.Defaults.rc_menu.hover_color        = Turbine.UI.Color( 0.23, 0.23, 0.23)

-- tooltip
Options.Defaults.tooltip                    = {}
Options.Defaults.tooltip.backcolor1         = Turbine.UI.Color( 0.6, 0.6, 0.6 )
Options.Defaults.tooltip.backcolor2         = Turbine.UI.Color.Black
Options.Defaults.tooltip.frame              = 2
Options.Defaults.tooltip.width              = 200
Options.Defaults.tooltip.left_shift         = 70
Options.Defaults.tooltip.top_shift          = 40
Options.Defaults.tooltip.font               = Turbine.UI.Lotro.Font.Verdana14
Options.Defaults.tooltip.activation_delay   = 1

-- drop down
Options.Defaults.dropdown                    = {}
Options.Defaults.dropdown.base_height        = 20
Options.Defaults.dropdown.item_height        = 20
Options.Defaults.dropdown.spacing            = 2
Options.Defaults.dropdown.base_color         = Turbine.UI.Color(0.4,0.4,0.4)
Options.Defaults.dropdown.show_color         = Turbine.UI.Color( 0.6, 0.6, 0.6 )
Options.Defaults.dropdown.back_color         = Turbine.UI.Color(0.1,0.1,0.1)
Options.Defaults.dropdown.hover_color        = Turbine.UI.Color(0.18,0.18,0.18)
Options.Defaults.dropdown.selected_color     = Turbine.UI.Color(0.5,0.5,0.5)
Options.Defaults.dropdown.nselected_color    = Turbine.UI.Color.White
---------------------------------------------------------------------------------------------------
