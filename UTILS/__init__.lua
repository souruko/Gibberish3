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
    import "Gibberish3.UTILS.LOCALISATION.de"

elseif Language.Local == Language.French then
    import "Gibberish3.UTILS.COMBATCHATPARSE.fr"
    import "Gibberish3.UTILS.LOCALISATION.fr"

else -- english
    import "Gibberish3.UTILS.COMBATCHATPARSE.en"
    import "Gibberish3.UTILS.LOCALISATION.en"

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- utils function library
import "Gibberish3.UTILS.Functions"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- icon id collection
import "Gibberish3.UTILS.IconIDs"
---------------------------------------------------------------------------------------------------