--===================================================================================
--             Name:    TEMPLATE Defaults
-------------------------------------------------------------------------------------
--      Description:    set all TEMPLATE defaults
--===================================================================================

Group.Defaults[Group.Types.TEMPLATE]                         = {}

Group.Defaults[Group.Types.TEMPLATE].description             = ""
Group.Defaults[Group.Types.TEMPLATE].resetOnTargetChange     = false
Group.Defaults[Group.Types.TEMPLATE].useTargetEntity         = false


Group.Defaults[Group.Types.TEMPLATE].width                   = 150
Group.Defaults[Group.Types.TEMPLATE].height                  = 20
Group.Defaults[Group.Types.TEMPLATE].left                    = 0.1
Group.Defaults[Group.Types.TEMPLATE].top                     = 0.1
Group.Defaults[Group.Types.TEMPLATE].frame                   = 1
Group.Defaults[Group.Types.TEMPLATE].spacing                 = 10
Group.Defaults[Group.Types.TEMPLATE].direction               = Direction.Descending
Group.Defaults[Group.Types.TEMPLATE].orientation             = Orientation.Vertical
Group.Defaults[Group.Types.TEMPLATE].overlay                 = false

Group.Defaults[Group.Types.TEMPLATE].color1                  = {R=0, G=0, B=0}
Group.Defaults[Group.Types.TEMPLATE].color2                  = {R=0.11, G=0.56, B=1}
Group.Defaults[Group.Types.TEMPLATE].color3                  = {R=0, G=0, B=0}
Group.Defaults[Group.Types.TEMPLATE].color4                  = {R=1, G=1, B=1}
Group.Defaults[Group.Types.TEMPLATE].color5                  = {R=1, G=1, B=1}

Group.Defaults[Group.Types.TEMPLATE].opacityActiv            = 0.5
Group.Defaults[Group.Types.TEMPLATE].opacityPassiv           = 0.5


Group.Defaults[Group.Types.TEMPLATE].font                    = 23
Group.Defaults[Group.Types.TEMPLATE].durationFormat          = NumberFormat.Minutes
Group.Defaults[Group.Types.TEMPLATE].textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Group.Defaults[Group.Types.TEMPLATE].timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Group.Defaults[Group.Types.TEMPLATE].showTimer               = true
