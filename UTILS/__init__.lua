--===================================================================================
--             Name:    UTILS
-------------------------------------------------------------------------------------
--      Description:    init
--===================================================================================






import "Gibberish3.UTILS.Class"
import "Gibberish3.UTILS.Type"


if Language.Local == Language.German then

    import "Gibberish3.UTILS.CombatChatParseDE"

elseif Language.Local == Language.French then

    import "Gibberish3.UTILS.CombatChatParseFR"

else

    import "Gibberish3.UTILS.CombatChatParseEN"

end


import "Gibberish3.UTILS.LOCALISATION"
import "Gibberish3.UTILS.Utils"
