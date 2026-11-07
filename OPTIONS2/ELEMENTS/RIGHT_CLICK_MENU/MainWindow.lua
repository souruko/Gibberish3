-- the window is not the menu - it is an oversized invisible canvas the menu and
-- its submenus are drawn on, because submenus are child controls and a window
-- cut to the size of the menu would clip them away
local CANVAS = 1000

-- which corner of the menu sits on the anchor point
local function corner(flip_left, flip_top)
    if flip_left then
        if flip_top then return Turbine.UI.ContentAlignment.BottomRight end
        return Turbine.UI.ContentAlignment.TopRight
    end
    if flip_top then return Turbine.UI.ContentAlignment.BottomLeft end
    return Turbine.UI.ContentAlignment.TopLeft
end

Options2.Elements.RightClickMenu = class(Turbine.UI.Window)
function Options2.Elements.RightClickMenu:Constructor(width)
    Turbine.UI.Window.Constructor(self)

    self.width         = width or 180
    self.height        = 2 * Options.Defaults.rc_menu.spacing
    self.orientation   = Turbine.UI.ContentAlignment.BottomRight
    self.flip_left     = false
    self.flip_top      = false
    self.canvas_width  = CANVAS
    self.canvas_height = CANVAS
    self.children      = {}

    self:SetMouseVisible(false)
    self:SetSize(CANVAS, CANVAS)

    self.border = Turbine.UI.Control()
    self.border:SetParent(self)
    self.border:SetWidth(self.width + 2)
    self.border:SetBackColor(Options.Defaults.rc_menu.border_color)
    self.border:SetMouseVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self.border)
    self.background:SetPosition(1, 1)
    self.background:SetWidth(self.width)
    self.background:SetBackColor(Options.Defaults.rc_menu.back_color)

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self.background)
    self.list:SetWidth(self.width)
    self.list:SetTop(Options.Defaults.rc_menu.spacing)
    self.list:SetMouseVisible(false)
end

-- left, top is the anchor point the menu hangs off; orientation names the corner
-- of the menu that lands on it, and nil picks whichever corners keep the whole
-- menu on screen ( the cursor, for a right click )
function Options2.Elements.RightClickMenu:Show(left, top, orientation)

    if left == nil then
        left, top = Turbine.UI.Display.GetMousePosition()
    end

    local menu_width  = self.width + 2
    local menu_height = self.height + 2

    if orientation == nil then
        -- open down and right unless the menu would run off the screen there
        self.flip_left = left + menu_width  > Options.ScreenWidth
        self.flip_top  = top  + menu_height > Options.ScreenHeight
    else
        self.flip_left = orientation == Turbine.UI.ContentAlignment.TopRight
                      or orientation == Turbine.UI.ContentAlignment.BottomRight
        self.flip_top  = orientation == Turbine.UI.ContentAlignment.BottomLeft
                      or orientation == Turbine.UI.ContentAlignment.BottomRight
    end
    self.orientation = corner(self.flip_left, self.flip_top)

    -- where the menu itself has to end up
    local menu_left = self.flip_left and (left - menu_width)  or left
    local menu_top  = self.flip_top  and (top  - menu_height) or top
    menu_left, menu_top = UTILS.ClampToScreen(menu_left, menu_top, menu_width, menu_height)

    -- the canvas is kept fully on screen as well and the menu is then offset
    -- inside it: a window hanging over an edge is pushed back on screen by the
    -- client, which used to drag the menu along with it and was why a menu
    -- raised in the lower half of the screen jumped away from the cursor
    self.canvas_width  = math.min(CANVAS, Options.ScreenWidth)
    self.canvas_height = math.min(CANVAS, Options.ScreenHeight)

    local canvas_left = math.max(0, math.min(menu_left, Options.ScreenWidth  - self.canvas_width))
    local canvas_top  = math.max(0, math.min(menu_top,  Options.ScreenHeight - self.canvas_height))

    self:SetSize(self.canvas_width, self.canvas_height)
    self:SetPosition(canvas_left, canvas_top)
    self.border:SetPosition(menu_left - canvas_left, menu_top - canvas_top)

    self:LanguageChanged()
    self:SetVisible(true)
    self:Activate()
    self:Focus()
end

function Options2.Elements.RightClickMenu:Hide()
    self:SetVisible(false)
    for _, child in pairs(self.children) do
        child:Hide()
    end
end

function Options2.Elements.RightClickMenu:FocusLost()
    self:Hide()
end

function Options2.Elements.RightClickMenu:Used()
    self:Hide()
end

function Options2.Elements.RightClickMenu:AddRow(row)
    row:SetWidth(self.width)
    row:SetSuper(self)
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
end

function Options2.Elements.RightClickMenu:AddCheckRow(row)
    row:SetWidth(self.width)
    row:SetSuper(self)
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
    return row
end

function Options2.Elements.RightClickMenu:AddSeperator()
    self.list:AddItem(Options2.Elements.Separator(self.width, Options.Defaults.rc_menu.seperator_height, self))
    self:ChangeHeight(Options.Defaults.rc_menu.seperator_height)
end

function Options2.Elements.RightClickMenu:AddSubRow(row, subMenu)
    row:SetWidth(self.width)
    row:SetSuper(self)
    subMenu:SetParent(self)
    self.children[#self.children + 1] = subMenu
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
end

function Options2.Elements.RightClickMenu:ChangeHeight(value)
    self.height = self.height + value
    self.list:SetHeight(self.height)
    self.background:SetHeight(self.height)
    self.border:SetHeight(self.height + 2)
end

function Options2.Elements.RightClickMenu:HoverChanged(selected)
    for i = 1, self.list:GetItemCount() do
        local child = self.list:GetItem(i)
        if child ~= selected then
            child:Hover(false)
        end
    end
end

function Options2.Elements.RightClickMenu:GetPos()
    return self.border:GetPosition()
end

-- the area a submenu has to stay inside to not be clipped
function Options2.Elements.RightClickMenu:GetCanvasSize()
    return self.canvas_width, self.canvas_height
end

function Options2.Elements.RightClickMenu:FlipsLeft()
    return self.flip_left == true
end

function Options2.Elements.RightClickMenu:LanguageChanged()
    for i = 1, self.list:GetItemCount() do
        self.list:GetItem(i):LanguageChanged()
    end
    for _, subMenu in pairs(self.children) do
        subMenu:LanguageChanged()
    end
end
