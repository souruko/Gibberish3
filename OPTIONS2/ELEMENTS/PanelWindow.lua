-- Frameless window chrome, shared by every options window.
--
-- Turbine.UI.Window draws nothing on its own, so this supplies the parts the
-- Lotro window used to give us for free: a 1px border, a 30px title bar that
-- drags the window, a close button and an optional resize gripper.
--
-- Subclasses put their content in self.client and implement OnLayout(w, h),
-- which is called with the client size whenever the window resizes.
-- self:TitleBarRight() is the x a subclass may place its own title-bar
-- buttons up to (it sits left of the close button).

local BORDER   = 1
local TITLE_H  = 30
local PAD      = 8
local GAP      = 8
local BTN_SIZE = 22
local BTN_ICON = 16
local GRIP     = 14

Options2.Elements.PanelWindow = class(Turbine.UI.Window)

function Options2.Elements.PanelWindow:Constructor(config)
    Turbine.UI.Window.Constructor(self)

    config = config or {}
    self._resizable = (config.resizable == true)
    self._min_w     = config.min_width  or 200
    self._min_h     = config.min_height or 120
    self._dragging  = false
    self._sizing    = false

    -- the window's own fill is the 1px border; root covers everything inside it
    self:SetBackColor(Options.Defaults.window.line)

    self.root = Turbine.UI.Control()
    self.root:SetParent(self)
    self.root:SetPosition(BORDER, BORDER)
    self.root:SetBackColor(Options.Defaults.window.bg)

    -- ── title bar (also the drag handle) ────────────────────────────────────
    self.titlebar = Turbine.UI.Control()
    self.titlebar:SetParent(self.root)
    self.titlebar:SetPosition(0, 0)
    self.titlebar:SetHeight(TITLE_H)
    self.titlebar:SetBackColor(Options.Defaults.window.row_odd)
    self.titlebar:SetMouseVisible(true)

    self.titlebar.MouseDown = function(sender, args)
        if args.Button ~= Turbine.UI.MouseButton.Left then return end
        self:Activate()
        self._dragging = true
        self._drag_x   = args.X
        self._drag_y   = args.Y
    end

    self.titlebar.MouseMove = function(sender, args)
        if not self._dragging then return end
        local left, top = self:GetPosition()
        self:SetPosition(left + (args.X - self._drag_x), top + (args.Y - self._drag_y))
    end

    self.titlebar.MouseUp = function(sender, args)
        if not self._dragging then return end
        self._dragging = false
        if self.OnMoved ~= nil then self:OnMoved() end
    end

    self.title_label = Turbine.UI.Label()
    self.title_label:SetParent(self.titlebar)
    self.title_label:SetPosition(PAD, 0)
    self.title_label:SetHeight(TITLE_H)
    self.title_label:SetFont(Options.Defaults.window.font)
    self.title_label:SetForeColor(Options.Defaults.window.text)
    self.title_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.title_label:SetMouseVisible(false)

    self.btn_close = Turbine.UI.Control()
    self.btn_close:SetParent(self.titlebar)
    self.btn_close:SetSize(BTN_SIZE, BTN_SIZE)
    self.btn_close:SetBackColor(Options.Defaults.window.select)
    self.btn_close:SetMouseVisible(true)

    local close_icon = Turbine.UI.Control()
    close_icon:SetParent(self.btn_close)
    close_icon:SetSize(BTN_ICON, BTN_ICON)
    close_icon:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2),
                           math.floor((BTN_SIZE - BTN_ICON) / 2))
    close_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    close_icon:SetBackground("Gibberish3/RESOURCES/close.tga")
    close_icon:SetMouseVisible(false)

    self.btn_close.MouseEnter = function()
        self.btn_close:SetBackColor(Options.Defaults.window.line)
    end
    self.btn_close.MouseLeave = function()
        self.btn_close:SetBackColor(Options.Defaults.window.select)
    end
    self.btn_close.MouseClick = function() self:CloseWindow() end

    self.title_sep = Turbine.UI.Control()
    self.title_sep:SetParent(self.root)
    self.title_sep:SetHeight(BORDER)
    self.title_sep:SetBackColor(Options.Defaults.window.line)
    self.title_sep:SetMouseVisible(false)

    -- ── client area ─────────────────────────────────────────────────────────
    self.client = Turbine.UI.Control()
    self.client:SetParent(self.root)
    self.client:SetPosition(0, TITLE_H + BORDER)
    self.client:SetBackColor(Options.Defaults.window.bg)

    -- ── resize gripper ──────────────────────────────────────────────────────
    if self._resizable then
        self.gripper = Turbine.UI.Control()
        self.gripper:SetParent(self.root)
        self.gripper:SetSize(GRIP, GRIP)
        self.gripper:SetBackColor(Options.Defaults.window.line)
        self.gripper:SetMouseVisible(true)

        self.gripper.MouseDown = function(sender, args)
            if args.Button ~= Turbine.UI.MouseButton.Left then return end
            self._sizing  = true
            self._size_x  = args.X
            self._size_y  = args.Y
        end

        self.gripper.MouseMove = function(sender, args)
            if not self._sizing then return end
            local w, h = self:GetSize()
            self:SetSize(
                math.max(self._min_w, w + (args.X - self._size_x)),
                math.max(self._min_h, h + (args.Y - self._size_y)))
        end

        self.gripper.MouseUp = function(sender, args)
            if not self._sizing then return end
            self._sizing = false
            if self.OnResized ~= nil then self:OnResized() end
        end

        self.gripper.MouseEnter = function()
            self.gripper:SetBackColor(Options.Defaults.window.accent)
        end
        self.gripper.MouseLeave = function()
            self.gripper:SetBackColor(Options.Defaults.window.line)
        end
    end
end

function Options2.Elements.PanelWindow:SetTitleText(text)
    self.title_label:SetText(text)
end

-- x that a subclass's own title-bar buttons must stay left of
function Options2.Elements.PanelWindow:TitleBarRight()
    return self._title_right or 0
end

-- default close: hide. Subclasses override to also persist their open flag.
function Options2.Elements.PanelWindow:CloseWindow()
    self:SetVisible(false)
end

function Options2.Elements.PanelWindow:SizeChanged()
    if self.root == nil then return end

    local w, h = self:GetSize()
    local rw   = math.max(0, w - 2 * BORDER)
    local rh   = math.max(0, h - 2 * BORDER)

    self.root:SetSize(rw, rh)

    self.titlebar:SetWidth(rw)
    self.title_sep:SetPosition(0, TITLE_H)
    self.title_sep:SetWidth(rw)

    local close_left = rw - PAD - BTN_SIZE
    self.btn_close:SetPosition(close_left, math.floor((TITLE_H - BTN_SIZE) / 2))
    self._title_right = close_left - GAP

    local client_h = math.max(0, rh - TITLE_H - BORDER)
    self.client:SetSize(rw, client_h)

    if self.gripper ~= nil then
        self.gripper:SetPosition(rw - GRIP, rh - GRIP)
    end

    if self.OnLayout ~= nil then self:OnLayout(rw, client_h) end
end
