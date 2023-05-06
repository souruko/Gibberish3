--===================================================================================
--             Name:    TEMPLATE Defaults
-------------------------------------------------------------------------------------
--      Description:    set all TEMPLATE defaults
--===================================================================================

Timer.Defaults[Timer.Types.TEMPLATE]                     = {}


Timer.Defaults[Timer.Types.TEMPLATE].description         = ""
Timer.Defaults[Timer.Types.TEMPLATE].permanent           = false


Timer.Defaults[Timer.Types.TEMPLATE].unique              = false
Timer.Defaults[Timer.Types.TEMPLATE].removable           = true
Timer.Defaults[Timer.Types.TEMPLATE].reset               = false
Timer.Defaults[Timer.Types.TEMPLATE].loop                = false

Timer.Defaults[Timer.Types.TEMPLATE].timerValue          = 10
Timer.Defaults[Timer.Types.TEMPLATE].useCustomTimer      = false
Timer.Defaults[Timer.Types.TEMPLATE].direction           = Direction.Descending

Timer.Defaults[Timer.Types.TEMPLATE].icon                = 1091637312
Timer.Defaults[Timer.Types.TEMPLATE].textValue           = ""
Timer.Defaults[Timer.Types.TEMPLATE].textOption          = 1

Timer.Defaults[Timer.Types.TEMPLATE].thresholdValue      = 3
Timer.Defaults[Timer.Types.TEMPLATE].useThreshold        = false
Timer.Defaults[Timer.Types.TEMPLATE].useAnimation        = false
Timer.Defaults[Timer.Types.TEMPLATE].animationSpeed      = 2
Timer.Defaults[Timer.Types.TEMPLATE].animationType       = AnimationType.Flashing
Timer.Defaults[Timer.Types.TEMPLATE].useShadow           = false

Timer.Defaults[Timer.Types.COUNTER_BAR].counterValue         = nil
