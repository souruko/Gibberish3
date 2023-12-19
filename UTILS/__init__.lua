--=================================================================================================
--= Utils        
--= ===============================================================================================
--= collection of utilitys
--=================================================================================================

---------------------------------------------------------------------------------------------------
-- required for class-struct definitions 
import "Gibberish3.UTILS.Class"
import "Gibberish3.UTILS.Type"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- localisation and combatChatParse (stolen from combat analyses)
if Language.Local == Language.German then
    import "Gibberish3.UTILS.COMBATCHATPARSE.de"

elseif Language.Local == Language.French then
    import "Gibberish3.UTILS.COMBATCHATPARSE.fr"

else -- english
    import "Gibberish3.UTILS.COMBATCHATPARSE.en"

end
import "Gibberish3.UTILS.LOCALISATION.en"
import "Gibberish3.UTILS.LOCALISATION.de"
import "Gibberish3.UTILS.LOCALISATION.fr"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- utils function library
import "Gibberish3.UTILS.Functions"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- icon id collection
import "Gibberish3.UTILS.IconIDs"
---------------------------------------------------------------------------------------------------

