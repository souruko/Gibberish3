--===================================================================================
--             Name:    COUNTER Defaults
-------------------------------------------------------------------------------------
--      Description:    set all COUNTER defaults
--===================================================================================

Group.Defaults[Group.Types.COUNTER]                         = {}

Group.Defaults[Group.Types.COUNTER].description             = ""
Group.Defaults[Group.Types.COUNTER].resetOnTargetChange     = false
Group.Defaults[Group.Types.COUNTER].useTargetEntity         = false


Group.Defaults[Group.Types.COUNTER].width                   = 150
Group.Defaults[Group.Types.COUNTER].height                  = 20
Group.Defaults[Group.Types.COUNTER].left                    = 0.1
Group.Defaults[Group.Types.COUNTER].top                     = 0.1
Group.Defaults[Group.Types.COUNTER].frame                   = 1
Group.Defaults[Group.Types.COUNTER].spacing                 = 10
Group.Defaults[Group.Types.COUNTER].direction               = Direction.Descending
Group.Defaults[Group.Types.COUNTER].orientation             = Orientation.Vertical
Group.Defaults[Group.Types.COUNTER].overlay                 = false

Group.Defaults[Group.Types.COUNTER].color1                  = {R=0, G=0, B=0}
Group.Defaults[Group.Types.COUNTER].color2                  = {R=0.11, G=0.56, B=1}
Group.Defaults[Group.Types.COUNTER].color3                  = {R=0, G=0, B=0}
Group.Defaults[Group.Types.COUNTER].color4                  = {R=1, G=1, B=1}
Group.Defaults[Group.Types.COUNTER].color5                  = {R=1, G=1, B=1}

Group.Defaults[Group.Types.COUNTER].opacityActiv            = 0.5
Group.Defaults[Group.Types.COUNTER].opacityPassiv           = 0.5


Group.Defaults[Group.Types.COUNTER].font                    = 23
Group.Defaults[Group.Types.COUNTER].durationFormat          = NumberFormat.Minutes
Group.Defaults[Group.Types.COUNTER].textAlignment           = Turbine.UI.ContentAlignment.MiddleLeft
Group.Defaults[Group.Types.COUNTER].timerAlignment          = Turbine.UI.ContentAlignment.MiddleRight
Group.Defaults[Group.Types.COUNTER].showTimer               = true


Group.Defaults[Group.Types.COUNTER].counterDirection        = Direction.Ascending