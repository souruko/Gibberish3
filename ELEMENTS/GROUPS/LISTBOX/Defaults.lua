--===================================================================================
--             Name:    LISTBOX Defaults
-------------------------------------------------------------------------------------
--      Description:    set all LISTBOX defaults
--===================================================================================





Group.Defaults[Group.Types.LISTBOX]                         = {}

Group.Defaults[Group.Types.LISTBOX].description             = ""
Group.Defaults[Group.Types.LISTBOX].resetOnTargetChange     = false
Group.Defaults[Group.Types.LISTBOX].useTargetEntity         = false


Group.Defaults[Group.Types.LISTBOX].width                   = 150
Group.Defaults[Group.Types.LISTBOX].height                  = 20
Group.Defaults[Group.Types.LISTBOX].left                    = 0.1
Group.Defaults[Group.Types.LISTBOX].top                     = 0.1
Group.Defaults[Group.Types.LISTBOX].frame                   = 1
Group.Defaults[Group.Types.LISTBOX].spacing                 = 4
Group.Defaults[Group.Types.LISTBOX].direction               = Direction.Descending
Group.Defaults[Group.Types.LISTBOX].orientation             = Orientation.Vertical
Group.Defaults[Group.Types.LISTBOX].overlay                 = false

Group.Defaults[Group.Types.LISTBOX].color1                  = {R=0, G=0, B=0}
Group.Defaults[Group.Types.LISTBOX].color2                  = {R=0.11, G=0.56, B=1}
Group.Defaults[Group.Types.LISTBOX].color3                  = {R=0, G=0, B=0}
Group.Defaults[Group.Types.LISTBOX].color4                  = {R=1, G=1, B=1}
Group.Defaults[Group.Types.LISTBOX].color5                  = {R=1, G=1, B=1}

Group.Defaults[Group.Types.LISTBOX].opacityActiv            = 0.5
Group.Defaults[Group.Types.LISTBOX].opacityPassiv           = 0.5


Group.Defaults[Group.Types.LISTBOX].font                    = 23
Group.Defaults[Group.Types.LISTBOX].durationFormat          = NumberFormat.Minutes
Group.Defaults[Group.Types.LISTBOX].textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Group.Defaults[Group.Types.LISTBOX].timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Group.Defaults[Group.Types.LISTBOX].showTimer               = true
