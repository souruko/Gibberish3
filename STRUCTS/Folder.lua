
--===================================================================================
--             Name:    STRUCTS - Folder
-------------------------------------------------------------------------------------
--      Description:    Folder structure and functions
--===================================================================================




-------------------------------------------------------------------------------------
--      Description:   return the base structure for creating a new folder 
-------------------------------------------------------------------------------------
--        Parameter:       
-------------------------------------------------------------------------------------
--           Return:   folder struct 
-------------------------------------------------------------------------------------
function Folder.GetStruct()

    local folder = {}

    folder.id = Folder.GetlastID()
    folder.sortIndex             = Data.GetNextSortIndex()
    folder.name = ""
    folder.enabled = false
    folder.collapsed = false
    folder.folder = nil

    folder[Trigger.Types.EffectSelf]     = {}
    folder[Trigger.Types.EffectGroup]    = {}
    folder[Trigger.Types.EffectTarget]   = {}
    folder[Trigger.Types.Skill]          = {}
    folder[Trigger.Types.Chat]           = {}
    folder[Trigger.Types.TimerEnd]       = {}
    folder[Trigger.Types.TimerStart]     = {}
    folder[Trigger.Types.TimerThreshold] = {}

    return folder

end


-------------------------------------------------------------------------------------
--      Description:    create nur folderdata and returns id
-------------------------------------------------------------------------------------
--        Parameter:    name    - folder name
-------------------------------------------------------------------------------------
--           Return:    index   - index of the new folder
-------------------------------------------------------------------------------------
function Folder.New(name)

    local index = #Data.folder + 1

    Data.folder[index] = Folder.GetStruct()
    Data.folder[index].name = name

    return index

end


-------------------------------------------------------------------------------------
--      Description:    create nur folderdata and returns id
-------------------------------------------------------------------------------------
--        Parameter:    name    - folder name
-------------------------------------------------------------------------------------
--           Return:    index   - index of the new folder
-------------------------------------------------------------------------------------
function Folder.GetFolderLevel(folderData)

    local level = 0

    if folderData == nil then
        return level
    end

    while folderData.folder ~= nil do

        level = level + 1
        folderData = Data.folder[folderData.folder]
       
    end

    return level

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Folder.Delete(index)

    for i = index, (#Data.folder - 1) do

        Data.folder[i] = Data.folder[i + 1]

    end

    Data.folder[#Data.folder] = nil

end


-------------------------------------------------------------------------------------
--      Description:    return next folder id and add up 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    next folder id
-------------------------------------------------------------------------------------
function Folder.GetlastID()

    Data.folder.lastID = Data.folder.lastID + 1

    return Data.folder.lastID

end


-------------------------------------------------------------------------------------
--      Description:    return next folder id and add up 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    next folder id
-------------------------------------------------------------------------------------
function Folder.CollapsAll()

    for index, folder in ipairs(Data.folder) do

        folder.collapsed = true
        
    end

end

-------------------------------------------------------------------------------------
--      Description:    get folder path
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    string
-------------------------------------------------------------------------------------
function Folder.GetFolderPath( index )

    local base = "> "

    if index == nil then
        return base
    end

    local folderData = Data.folder[index]
    local string = Data.folder[index].name

    while folderData.parent ~= nil do

        folderData = Data.folder[folderData.parent]

        string = folderData.name .. " > " .. string
        
    end

    return base .. string

end


--===================================================================================
--             Name:    
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


FolderGeneralTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function FolderGeneralTab:Constructor( width, name, tabwindow )
	Options.Constructor.Tab.Constructor( self )

    self:SetWidth( width )
    self:SetName( name )
    self:SetTabWindow( tabwindow )

end

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function FolderGeneralTab:FillContent( folderData, folderIndex )

end




--===================================================================================
--             Name:    LISTBOX OPTIONS Group EnableTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


FolderEnableTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function FolderEnableTab:Constructor( width, name, tabwindow )
	Options.Constructor.Tab.Constructor( self )

    self:SetWidth( width )
    self:SetName( name )
    self:SetTabWindow( tabwindow )

end

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function FolderEnableTab:FillContent( folderData, folderIndex )

end








--===================================================================================
--             Name:    FOLDEROPTIONS
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


-------------------------------------------------------------------------------------
--      Description:    COUNTER OPTIONS Control
-------------------------------------------------------------------------------------
Folder.Options = Turbine.UI.Control()

local width = 706

Folder.Options:SetWidth(width)
Folder.Options:SetBackColor( Defaults.Colors.BackgroundColor2 )


-------------------------------------------------------------------------------------
--      Description:    COUNTER OPTIONS GROUP OPTIONS
-------------------------------------------------------------------------------------
Folder.Options.folderTabWindow = Options.Constructor.TabWindow( Folder.Options, width, 353  )

Folder.Options.groupTabs = {}
Folder.Options.groupTabs.general = FolderGeneralTab( width, L[Language.Local].Tab.General, Folder.Options.folderTabWindow )
Folder.Options.groupTabs.enable = FolderEnableTab( width, L[Language.Local].Tab.Enable, Folder.Options.folderTabWindow )

Folder.Options.folderTabWindow:AddTab( Folder.Options.groupTabs.general )
Folder.Options.folderTabWindow:AddTab( Folder.Options.groupTabs.enable )

Folder.Options.folderTabWindow:ResetSelection()


-------------------------------------------------------------------------------------
--      Description:    SizeChanged
-------------------------------------------------------------------------------------
Folder.Options.SizeChanged = function ()

    Folder.Options.folderTabWindow:SetHeight(  Folder.Options:GetHeight() )
    
end


-------------------------------------------------------------------------------------
--      Description:    FillContent
-------------------------------------------------------------------------------------
Folder.Options.FillContent = function ( folderData, folderIndex )

    Folder.Options.groupTabs.general:FillContent( folderData, folderIndex )
    Folder.Options.groupTabs.enable:FillContent( folderData, folderIndex )

end


-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
Folder.Options.CheckContent = function ()
    
end


-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
Folder.Options.SaveContent = function ()
    
end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Folder.IsSelected(index)

    for i, v in ipairs(Data.selectedFolderIndex) do

        if v == index then
            return true
        end
        
    end

    return false

end