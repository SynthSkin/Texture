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

        if not layout.AbsPos then
            layout.AbsPos = { X = absX, Y = absY }
        else
            layout.AbsPos.X, layout.AbsPos.Y = absX, absY
        end

        if not layout.AbsSize then
            layout.AbsSize = { X = absW, Y = absH }
        else
            layout.AbsSize.X, layout.AbsSize.Y = absW, absH
        end
    end

    local childParentX, childParentY, childParentW, childParentH = absX, absY, absW, absH
    local scroll = element.Scroll
    if scroll and layout then
        local canvasW = scroll.CanvasSize.ScaleX * absW + scroll.CanvasSize.OffsetX
        local canvasH = scroll.CanvasSize.ScaleY * absH + scroll.CanvasSize.OffsetY

        if scroll.AutoCanvasSize then
            childParentW = absW
            childParentH = absH
        else
            childParentW = canvasW
            childParentH = canvasH
        end

        local maxScrollX = math.max(0, childParentW - absW)
        local maxScrollY = math.max(0, childParentH - absH)
        if not scroll.AutoCanvasSize then
            scroll.CanvasPosition.X = math.clamp(scroll.CanvasPosition.X, 0, maxScrollX)
            scroll.CanvasPosition.Y = math.clamp(scroll.CanvasPosition.Y, 0, maxScrollY)
            scroll.AbsCanvasSize.X, scroll.AbsCanvasSize.Y = childParentW, childParentH
        end

        childParentX = absX - scroll.CanvasPosition.X
        childParentY = absY - scroll.CanvasPosition.Y
    end

    for _, child: Types.UIElement in element.Children do
        _ComputeLayout(child, childParentX, childParentY, childParentW, childParentH)
    end

    if scroll and layout and scroll.AutoCanvasSize then
        local maxRight, maxBottom = absW, absH
        local originX = absX - scroll.CanvasPosition.X
        local originY = absY - scroll.CanvasPosition.Y
        for _, child: Types.UIElement in element.Children do
            if child.Visible and child.Layout and child.Layout.AbsPos and child.Layout.AbsSize then
                maxRight = math.max(maxRight, (child.Layout.AbsPos.X + child.Layout.AbsSize.X) - originX)
                maxBottom = math.max(maxBottom, (child.Layout.AbsPos.Y + child.Layout.AbsSize.Y) - originY)
            end
        end

        scroll.AbsCanvasSize.X, scroll.AbsCanvasSize.Y = maxRight, maxBottom
        local clampedX = math.clamp(scroll.CanvasPosition.X, 0, math.max(0, maxRight - absW))
        local clampedY = math.clamp(scroll.CanvasPosition.Y, 0, math.max(0, maxBottom - absH))
        if clampedX ~= scroll.CanvasPosition.X or clampedY ~= scroll.CanvasPosition.Y then
            local dx = clampedX - scroll.CanvasPosition.X
            local dy = clampedY - scroll.CanvasPosition.Y
            scroll.CanvasPosition.X, scroll.CanvasPosition.Y = clampedX, clampedY
            for _, child: Types.UIElement in element.Children do
                _ComputeLayout(child, absX - clampedX, absY - clampedY, absW, absH)
            end
            local _ = dx + dy
        end
    end
end

local function _DrawRect(pass: Pass, cx: number, cy: number, w: number, h: number, radius: number?)
    if w <= 0 or h <= 0 then return end
    if radius and radius > 0 then
        pass:roundrect(cx, cy, 0, w, h, 0, 0, 0, 1, 0, radius)
    else
        pass:plane(cx, cy, 0, w, h)
    end
end

local scissorStack: { { x: number, y: number, w: number, h: number } } = {}

local function _PushScissor(pass: Pass, x: number, y: number, w: number, h: number)
    local nx, ny, nw, nh = x, y, math.max(0, w), math.max(0, h)
    local top = scissorStack[#scissorStack]
    if top then
        local x2 = math.min(nx + nw, top.x + top.w)
        local y2 = math.min(ny + nh, top.y + top.h)
        nx = math.max(nx, top.x)
        ny = math.max(ny, top.y)
        nw = math.max(0, x2 - nx)
        nh = math.max(0, y2 - ny)
    end
    table.insert(scissorStack, { x = nx, y = ny, w = nw, h = nh })
    pass:setScissor(nx, ny, nw, nh)
end

local function _PopScissor(pass: Pass)
    table.remove(scissorStack)
    local top = scissorStack[#scissorStack]
    if top then
        pass:setScissor(top.x, top.y, top.w, top.h)
    else
        pass:setScissor()
    end
end

local function _DrawElement(pass: Pass, element: Types.UIElement)
    if not element.Visible then return end

    local layout = element.Layout
    local background = element.Background
    local text = element.Text

    if layout and layout.AbsPos and layout.AbsSize and background then
        local x, y = layout.AbsPos.X, layout.AbsPos.Y
        local w, h = layout.AbsSize.X, layout.AbsSize.Y
        local cx, cy = x + w / 2, y + h / 2
        local radius = background.Radius or 0
        local bw = background.BorderWidth or 0
        local bc = background.BorderColor
        local hasBorder = bc ~= nil and bw > 0 and bc.A > 0
        local hasFill = background.Color.A > 0

        if hasBorder and bc then
            pass:setColor(bc.R, bc.G, bc.B, bc.A)
            if hasFill then
                _DrawRect(pass, cx, cy, w, h, radius)
                pass:setColor(background.Color.R, background.Color.G, background.Color.B, background.Color.A)
                _DrawRect(pass, cx, cy, w - bw * 2, h - bw * 2, math.max(0, radius - bw))
            else
                pass:plane(cx, y + bw / 2, 0, w, bw)
                pass:plane(cx, y + h - bw / 2, 0, w, bw)
                pass:plane(x + bw / 2, cy, 0, bw, math.max(0, h - bw * 2))
                pass:plane(x + w - bw / 2, cy, 0, bw, math.max(0, h - bw * 2))
            end
        elseif hasFill then
            pass:setColor(background.Color.R, background.Color.G, background.Color.B, background.Color.A)
            _DrawRect(pass, cx, cy, w, h, radius)
        end
    end

    if layout and text then
        local halign = text.Alignment.Horizontal
        local valign = text.Alignment.Vertical
        
        local tx = if halign == "left"
            then layout.AbsPos.X
            elseif halign == "right" then layout.AbsPos.X + layout.AbsSize.X
            else layout.AbsPos.X + layout.AbsSize.X / 2

        local ty = if valign == "top"
            then layout.AbsPos.Y
            elseif valign == "bottom" then layout.AbsPos.Y + layout.AbsSize.Y
            else layout.AbsPos.Y + layout.AbsSize.Y / 2

        pass:setColor(text.Color.R, text.Color.G, text.Color.B, text.Color.A)
        pass:text(text.Value, tx, ty, 0, text.Size, 0, 0, 0, 1, layout.AbsSize.X / text.Size, halign, valign)
    end

    if element.CustomDraw then
        element.CustomDraw(element, pass)
    end

    if #element.Children > 0 then
        local sorted = table.clone(element.Children)

        table.sort(sorted, function(a, b)
            return a.ZIndex < b.ZIndex
        end)

        if element.Clips and layout and layout.AbsPos and layout.AbsSize then
            _PushScissor(pass, layout.AbsPos.X, layout.AbsPos.Y, layout.AbsSize.X, layout.AbsSize.Y)
        end

        for _, child in sorted do
            _DrawElement(pass, child)
        end

        if element.Clips and layout and layout.AbsPos and layout.AbsSize then
            _PopScissor(pass)
        end
    end

    local scroll = element.Scroll
    if scroll and layout and layout.AbsPos and layout.AbsSize then
        local viewH = layout.AbsSize.Y
        local canvasH = scroll.AbsCanvasSize.Y
        if canvasH > viewH and viewH > 0 then
            local barW = 6
            local thumbH = math.max(16, viewH * (viewH / canvasH))
            local maxScrollY = canvasH - viewH
            local thumbY = layout.AbsPos.Y + (scroll.CanvasPosition.Y / maxScrollY) * (viewH - thumbH)
            local thumbX = layout.AbsPos.X + layout.AbsSize.X - barW - 2
            pass:setColor(0.5, 0.5, 0.5, 0.6)
            _DrawRect(pass, thumbX + barW / 2, thumbY + thumbH / 2, barW, thumbH, barW / 2)
        end
    end
end

local hoveredElement: Types.UIElement? = nil
local pressedElement: Types.UIElement? = nil

local function _PointInLayout(layout: Types.Layout, x: number, y: number): boolean
    if not layout.AbsPos or not layout.AbsSize then
        return false
    end
    return x >= layout.AbsPos.X
        and x <= layout.AbsPos.X + layout.AbsSize.X
        and y >= layout.AbsPos.Y
        and y <= layout.AbsPos.Y + layout.AbsSize.Y
end

local function _HitTest(element: Types.UIElement, x: number, y: number, requireScroll: boolean?): Types.UIElement?
    if not element.Visible then return nil end

    local layout = element.Layout
    if element.Clips and layout and not _PointInLayout(layout, x, y) then
        return nil
    end

    if #element.Children > 0 then
        local sorted = table.clone(element.Children)
        table.sort(sorted, function(a, b)
            return a.ZIndex < b.ZIndex
        end)

        for i = #sorted, 1, -1 do
            local hit = _HitTest(sorted[i], x, y, requireScroll)
            if hit then return hit end
        end
    end

    local matches = if requireScroll then element.Scroll ~= nil else element.Clickable ~= nil
    if matches and layout and _PointInLayout(layout, x, y) then
        return element
    end

    return nil
end

CallbackService.PushFunction(Enum.Callback.MouseMoved, "UIMouseMoved", function(x: number, y: number)
    local hit = _HitTest(Service.Root, x, y)
    if hit ~= hoveredElement then
        if hoveredElement and hoveredElement.Clickable then
            hoveredElement.Clickable.MouseLeave:Fire(x, y)
        end
        hoveredElement = hit
        if hoveredElement and hoveredElement.Clickable then
            hoveredElement.Clickable.MouseEnter:Fire(x, y)
        end
    end
end)

CallbackService.PushFunction(Enum.Callback.MousePressed, "UIMousePressed", function(x: number, y: number, button: number)
    local hit = _HitTest(Service.Root, x, y)
    if hit and hit.Clickable then
        pressedElement = hit
        hit.Clickable.Pressed:Fire(x, y, button)
    end
end)

CallbackService.PushFunction(Enum.Callback.MouseReleased, "UIMouseReleased", function(x: number, y: number, button: number)
    if pressedElement and pressedElement.Clickable then
        pressedElement.Clickable.Released:Fire(x, y, button)
    end
    pressedElement = nil
end)

CallbackService.PushFunction(Enum.Callback.WheelMoved, "UIWheelMoved", function(dx: number, dy: number)
    local mx, my = lovr.system.getMousePosition()
    local target = _HitTest(Service.Root, mx, my, true)
    if target and target.Scroll and target.Layout and target.Layout.AbsSize then
        local scroll = target.Scroll
        local maxScrollX = math.max(0, scroll.AbsCanvasSize.X - target.Layout.AbsSize.X)
        local maxScrollY = math.max(0, scroll.AbsCanvasSize.Y - target.Layout.AbsSize.Y)
        scroll.CanvasPosition.X = math.clamp(scroll.CanvasPosition.X - dx * scroll.ScrollSpeed, 0, maxScrollX)
        scroll.CanvasPosition.Y = math.clamp(scroll.CanvasPosition.Y - dy * scroll.ScrollSpeed, 0, maxScrollY)
    end
end)

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