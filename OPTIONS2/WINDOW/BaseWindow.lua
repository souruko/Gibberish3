Options2.Window = {}

Options2.Window.Constructor = class(Turbine.UI.Lotro.Window)
function Options2.Window.Constructor:Constructor()
    Turbine.UI.Lotro.Window.Constructor(self)

    -- Navigation tree panel
    self.nav = Options2.Window.Nav.Constructor()
    self.nav:SetParent(self)

    -- Editor panel
    self.editor_panel = Options2.Window.Editor.Constructor()
    self.editor_panel:SetParent(self)

    -- Library panel
    self.library = Options2.Library.Window()
    self.library:SetParent(self)

    self:SetText("Gibberish")
    self:SetMinimumSize(Options.Defaults.window.min_width, Options.Defaults.window.min_height)
    self:SetMaximumWidth(Options.Defaults.window.max_width)
    self:SetResizable(true)
    self:SetSize(Options.Defaults.window.min_width, Options.Defaults.window.min_height)

    local l2 = Data.options.window.left2 or Data.options.window.left
    local t2 = Data.options.window.top2  or Data.options.window.top
    self:SetPosition(UTILS.ScreenRatioToPixel(l2, t2))

    self:SetWantsKeyEvents(true)
    self.KeyDown = function(sender, args)
        if args.Action == Turbine.UI.Lotro.Action.Escape then
            self:SetVisible(false)
            Data.options.window.open2 = false
        end
    end

    self.Closed = function()
        Data.options.window.open2 = false
    end

    self:SetVisible(true)

    -- populate nav tree after first layout (SetSize fires SizeChanged first)
    self.nav:Rebuild()

    -- Options2.Window.Object isn't assigned until after this constructor returns,
    -- so Rebuild's restore loop can't call SetNode. Do it explicitly here.
    if self.nav.selectedItem ~= nil then
        self.editor_panel:SetNode(self.nav.selectedItem.nodeData)
    end
end

function Options2.Window.Constructor:LanguageChanged()
    if self.nav ~= nil then self.nav:LanguageChanged() end
    if self.editor_panel ~= nil and self.editor_panel.LanguageChanged ~= nil then
        self.editor_panel:LanguageChanged()
    end
    if self.library ~= nil and self.library.LanguageChanged ~= nil then
        self.library:LanguageChanged()
    end
end

function Options2.Window.Constructor:PositionChanged()
    local left, top = UTILS.PixelToScreenRatio(self:GetPosition())
    Data.options.window.left2 = left
    Data.options.window.top2  = top
end

function Options2.Window.Constructor:SizeChanged()
    if self.nav == nil then return end
    local width, height = self:GetSize()
    local sp     = Options.Defaults.window.spacing
    local outer  = Options.Defaults.window.outer_spacing
    local top_sp = Options.Defaults.window.top_spacing

    local nav_width      = 290
    local lib_width      = 200
    local editor_width   = width - nav_width - lib_width - 2 * sp - 2 * outer
    local content_height = height - top_sp - outer

    self.nav:SetPosition(outer, top_sp)
    self.nav:SetSize(nav_width, content_height)

    local editor_left = outer + nav_width + sp
    self.editor_panel:SetPosition(editor_left, top_sp)
    self.editor_panel:SetSize(editor_width, content_height)

    local lib_left = editor_left + editor_width + sp
    self.library:SetPosition(lib_left, top_sp)
    self.library:SetSize(lib_width, content_height)
end
