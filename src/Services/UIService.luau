local Types = require("Globals.Types")
local Element = require("Classes.UI.Base.Element")
local Components = require("Classes.UI.Base.Components")

local Service = {}

Service.Root = Element.new({
    Layout = Components.Layout({
        Size = { ScaleX = 1, OffsetX = 0,
                 ScaleY = 1, OffsetY = 0}
    }),
    Background = Components.Background({R = 0,G = 0,B = 0,A = 0}),
})

local function _ComputeLayout(element: Types.UIElement, parentX: number, parentY: number, parentW: number, parentH: number)
    local layout: Types.Layout? = element.Layout

    local absX: number, absY: number, absW: number, absH: number = parentX, parentY, parentW, parentH

    if layout then
        absW = layout.Size.ScaleX * parentW + layout.Size.OffsetX
        absH = layout.Size.ScaleY * parentH + layout.Size.OffsetY
        absX = parentX + layout.Position.ScaleX * parentW + layout.Position.OffsetX - layout.AnchorPoint.X * absW
        absY = parentY + layout.Position.ScaleY * parentH + layout.Position.OffsetY - layout.AnchorPoint.Y * absH

        layout.AbsPos.X, layout.AbsPos.Y = absX, absY
        layout.AbsSize.X, layout.AbsSize.Y = absW, absH
    end

    for _, child: Types.UIElement in element.Children do
        _ComputeLayout(child, absX, absY, absW, absH)
    end
end

local function _DrawElement(pass: Pass, element: Types.UIElement)
    if not element.Visible then return end

    local layout = element.Layout
    local background = element.Background

    if layout and background and background.Color.A > 0 then
        local cx = layout.AbsPos.X + layout.AbsSize.X / 2
        local cy = layout.AbsPos.Y + layout.AbsSize.Y / 2

        pass:setColor(background.Color.R, background.Color.G, background.Color.B, background.Color.A)

        if background.Radius and background.Radius > 0 then
            pass:roundrect(cx, cy, 0, layout.AbsSize.X, layout.AbsSize.Y, 0, 0, 0, 1, 0, background.Radius)
        else
            pass:plane(cx, cy, 0, layout.AbsSize.X, layout.AbsSize.Y)
        end
    end

    if element.CustomDraw then
        element.CustomDraw(element, pass)
    end

    if #element.Children > 0 then
        local sorted = table.clone(element.Children)

        table.sort(sorted, function(a, b)
            return a.ZIndex < b.ZIndex
        end)

        if element.Clips and layout then
            pass:setScissor(layout.AbsPos.X, layout.AbsPos.Y, layout.AbsSize.X, layout.AbsSize.Y)
        end

        for _, child in sorted do
            _DrawElement(pass, child)
        end

        if element.Clips then
            pass:setScissor()
        end
    end
end

CallbackService.PushFunction(Enum.Callback.Draw, "UIDraw", function(pass: Pass)
    local w, h = pass:getDimensions()

    pass:push()
    pass:setProjection(1, lovr.math.mat4():orthographic(0, w, 0, h, -1, 1))
    pass:setDepthTest()

    _ComputeLayout(Service.Root, 0, 0, w, h)
    _DrawElement(pass, Service.Root)

    pass:pop()
end)

return Service