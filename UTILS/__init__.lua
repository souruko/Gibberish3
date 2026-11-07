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
-- group setup export, for Prime Group Parse
-- the trait line data is read from the names the client shows, so only the matching language is
-- imported, the same way the combat chat parser above is. de and fr are empty for now.
--
-- the directory is GROUPLINES, not GROUPSETUP: the client matches paths without regard to case, so
-- a directory named after GroupSetup.lua is the same name as the file and the import below finds
-- the directory instead of the file. Keep the two names apart.
if Language.Local == Language.German then
    import "Gibberish3.UTILS.GROUPLINES.de"

elseif Language.Local == Language.French then
    import "Gibberish3.UTILS.GROUPLINES.fr"

else -- english
    import "Gibberish3.UTILS.GROUPLINES.en"

end

import "Gibberish3.UTILS.GroupSetup"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- compression library (pure Lua DEFLATE, used by export v2)
import "Gibberish3.UTILS.LibDeflate"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- export/import function library
import "Gibberish3.UTILS.Export"
import "Gibberish3.UTILS.Import"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- icon id collection
import "Gibberish3.UTILS.IconIDs"
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- debug shell command
import "Gibberish3.UTILS.Debug"
---------------------------------------------------------------------------------------------------

