--===================================================================================
--             Name:    UTILS LOCALISATION
-------------------------------------------------------------------------------------
--      Description:    init
--===================================================================================





if Language.Local == Language.English then
    import "Gibberish3.UTILS.LOCALISATION.en"

elseif Language.Local == Language.German then
    import "Gibberish3.UTILS.LOCALISATION.de"

elseif Language.Local == Language.French then
    import "Gibberish3.UTILS.LOCALISATION.fr"

end