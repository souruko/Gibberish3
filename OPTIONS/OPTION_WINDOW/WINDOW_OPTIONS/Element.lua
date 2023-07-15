--===================================================================================
--             Name:    Window Options
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.WindowOptions = class(Turbine.UI.Control)





-------------------------------------------------------------------------------------
--      Description:    Window Options constructor
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:Constructor( parent )
	Turbine.UI.Control.Constructor( self )
	
	-------------------------------------------------------------------------------------
	-- dimensions
	self.width = 740

    local left  = 325
    local top   = 35

	local frame_thickness = 2
	local size_button = 30

	local left_background = 5
	local left_frame = 5
	local left_save = 34
	local left_import = self.width - 84
	local left_reload = self.width - 52
	local left_filler = 66

	local top_background  = 5
	local top_frame = 5
	local top_content = 34

	local width_background = self.width - 10
	local width_frame = width_background - 10
	local width_filler = width_frame - 132
	local width_content = width_frame - 4

	-------------------------------------------------------------------------------------
	-- children

	-------------------------------------------------------------------------------------
	-- background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetPosition( left_background, top_background )
    self.background:SetBackColor( Defaults.Colors.BackgroundColor2 )
    self.background:SetMouseVisible( false )
    self.background:SetWidth( width_background )

	-------------------------------------------------------------------------------------
	--  frame  
	self.frame                        = Turbine.UI.Control()
	self.frame:SetParent(               self.background )
	self.frame:SetPosition(             left_frame, top_frame )
	self.frame:SetBackColor(            Defaults.Colors.FrameColor )
	self.frame:SetMouseVisible(         false )
	self.frame:SetWidth(                width_frame )

	-------------------------------------------------------------------------------------
	-- new file
	self.button_Reset                        = Turbine.UI.Button()
	self.button_Reset:SetParent(               self.frame )
	self.button_Reset:SetPosition(             frame_thickness, frame_thickness )
	self.button_Reset:SetBackColor(            Defaults.Colors.BackgroundColor2 )
	self.button_Reset:SetSize(                size_button, size_button )
    Options.Constructor.Tooltip.AddTooltip(self.button_Reset, L[Language.Local].Tooltip.Reset, true)

	-------------------------------------------------------------------------------------
	self.icon_Reset                    = Turbine.UI.Control()
	self.icon_Reset:SetParent(           self.button_Reset )
	self.icon_Reset:SetSize( size_button, size_button)
	self.icon_Reset:SetLeft(-1)
	self.icon_Reset:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Reset:SetBackground("Gibberish3/Resources/back.tga")
	self.icon_Reset:SetMouseVisible(false)

	-------------------------------------------------------------------------------------
	-- save
	self.button_Save                        = Turbine.UI.Button()
	self.button_Save:SetParent(               self.frame )
	self.button_Save:SetPosition(             left_save, frame_thickness )
	self.button_Save:SetBackColor(            Defaults.Colors.BackgroundColor2 )
	self.button_Save:SetSize(                size_button, size_button )
    Options.Constructor.Tooltip.AddTooltip(self.button_Save, L[Language.Local].Tooltip.Save, true)

	-------------------------------------------------------------------------------------
	self.icon_Save                    = Turbine.UI.Control()
	self.icon_Save:SetParent(           self.button_Save )
	self.icon_Save:SetSize( size_button, size_button)
	self.icon_Save:SetLeft(-1)
	self.icon_Save:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Save:SetBackground("Gibberish3/Resources/save.tga")
	self.icon_Save:SetMouseVisible(false)

	-------------------------------------------------------------------------------------
	-- new file
    self.button_Import                        = Turbine.UI.Button()
    self.button_Import:SetParent(               self.frame )
    self.button_Import:SetPosition(             left_import, frame_thickness )
    self.button_Import:SetBackColor(            Defaults.Colors.BackgroundColor2 )
    self.button_Import:SetSize(                size_button, size_button )
    Options.Constructor.Tooltip.AddTooltip(self.button_Import, L[Language.Local].Tooltip.Import, true)

	-------------------------------------------------------------------------------------
	self.icon_Import                    = Turbine.UI.Control()
    self.icon_Import:SetParent(           self.button_Import )
    self.icon_Import:SetSize( size_button, size_button)
	self.icon_Import:SetLeft(-1)
    self.icon_Import:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.icon_Import:SetBackground("Gibberish3/Resources/import.tga")
	self.icon_Import:SetMouseVisible(false)

	-------------------------------------------------------------------------------------
	-- new file
	self.button_Reload                        = Turbine.UI.Button()
	self.button_Reload:SetParent(               self.frame )
	self.button_Reload:SetPosition(             left_reload, frame_thickness )
	self.button_Reload:SetBackColor(            Defaults.Colors.BackgroundColor2 )
	self.button_Reload:SetSize(                size_button, size_button )
    Options.Constructor.Tooltip.AddTooltip(self.button_Reload, L[Language.Local].Tooltip.Reload, true)

	-------------------------------------------------------------------------------------
	self.icon_Reload                    = Turbine.UI.Control()
	self.icon_Reload:SetParent(           self.button_Reload )
	self.icon_Reload:SetSize( size_button, size_button)
	self.icon_Reload:SetLeft(-1)
	self.icon_Reload:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Reload:SetBackground("Gibberish3/Resources/reload.tga")
	self.icon_Reload:SetMouseVisible(false)

	-------------------------------------------------------------------------------------
	-- background
	self.toolbar_filler = Turbine.UI.Control()
	self.toolbar_filler:SetParent( self.frame )
	self.toolbar_filler:SetPosition( left_filler, frame_thickness )
	self.toolbar_filler:SetBackColor( Defaults.Colors.BackgroundColor2 )
	self.toolbar_filler:SetMouseVisible( false )
	self.toolbar_filler:SetSize( width_filler, size_button )

	-------------------------------------------------------------------------------------
	-- background
    self.content_Background = Turbine.UI.Control()
    self.content_Background:SetParent( self.frame )
    self.content_Background:SetPosition( frame_thickness, top_content )
    self.content_Background:SetBackColor( Defaults.Colors.BackgroundColor2 )
    self.content_Background:SetMouseVisible( false )
    self.content_Background:SetWidth( width_content )

	self.content = nil

	-------------------------------------------------------------------------------------
	-- self
	self:SetWidth(self.width)
	self:SetParent(parent)
    self:SetPosition( left, top )
    self:SetBackColor( Defaults.Colors.BackgroundColor )


end

-------------------------------------------------------------------------------------
--      Description:    size changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:SizeChanged()

	local height = self:GetHeight()

	local height_background = height - 10
	local height_frame = height_background - 10
	local height_content = height_frame - 36

	self.background:SetHeight( height_background )
	self.frame:SetHeight( height_frame )
	self.content_Background:SetHeight( height_content )

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:SelectionChanged()

	if self.content ~= nil then
		self.content:Finish()
		self.content = nil
	end

	local groupSelectionCount = #Data.selectedGroupIndex
	local folderSelectionCount = #Data.selectedFolderIndex

	if groupSelectionCount == 1 and folderSelectionCount == 0 then		-- single group
		self:DisplayGroupOptions()

	elseif groupSelectionCount == 0 and folderSelectionCount == 1 then	-- single folder
		self:DisplayFolderOptions()

	elseif (groupSelectionCount + folderSelectionCount) > 1 then		-- multi
		self:DisplayMultiOptions()

	end

end

-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:DisplayGroupOptions()

    local groupIndex = Data.selectedGroupIndex[1]
    local groupData = Data.group[ Data.selectedGroupIndex[1] ]
	local width, height = self.content_Background:GetSize()

    self:SetBackColor( Defaults.Colors.BackgroundColor )
	self.content = Group.Options[Group.Types.LISTBOX]( DisplayTypes.Group, groupData, width, height, self.content_Background )

end

-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:DisplayFolderOptions()

    self:SetBackColor( Defaults.Colors.FolderSelected )

end

-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:DisplayMultiOptions()

    self:SetBackColor( Defaults.Colors.Multiselect )

end

-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:Finish()

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:ResetContent()


end