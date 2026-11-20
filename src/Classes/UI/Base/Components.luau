local Types = require("Globals.Types")

local Components = {}

local DEFAULT_POSITION: Types.UDim2 = { ScaleX = 0, OffsetX = 0, ScaleY = 0, OffsetY = 0 }
local DEFAULT_SIZE: Types.UDim2 = { ScaleX = 0, OffsetX = 50, ScaleY = 0, OffsetY = 50 }
local DEFAULT_ANCHOR: Types.UDim1 = { X = 0, Y = 0 }
local DEFAULT_BG_COLOR: Types.Color = { R = 0.2, G = 0.2, B = 0.2, A = 1 }
local DEFAULT_TEXT_COLOR: Types.Color = { R = 0, G = 0, B = 0, A = 1 }
local DEFAULT_ALIGNMENT: Types.TextAlignment = { Vertical = "middle", Horizontal = "center" }
local DEFAULT_CANVAS_POS: Types.UDim1 = { X = 0, Y = 0 }
local DEFAULT_CANVAS_SIZE: Types.UDim2 = { ScaleX = 1, OffsetX = 0, ScaleY = 1, OffsetY = 0 }

local function cloneColor(c: Types.Color): Types.Color
    return { R = c.R, G = c.G, B = c.B, A = c.A }
end

function Components.NormalizeColor(input: Types.ColorInput?, fallback: Types.Color): Types.Color
    if input == nil then
        return cloneColor(fallback)
    end

    if type(input) == "string" then
        local hex = input:match("^#?(%x+)$")
        if hex and (#hex == 6 or #hex == 8) then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            local a = if #hex == 8 then tonumber(hex:sub(7, 8), 16) else 255
            if r and g and b and a then
                return { R = r / 255, G = g / 255, B = b / 255, A = a / 255 }
            end
        end
        return cloneColor(fallback)
    end

    if type(input) == "table" then
        local t = input :: any
        if t.R ~= nil or t.G ~= nil or t.B ~= nil or t.A ~= nil then
            return {
                R = t.R or 0,
                G = t.G or 0,
                B = t.B or 0,
                A = if t.A ~= nil then t.A else 1,
            }
        end
        return {
            R = t[1] or 0,
            G = t[2] or 0,
            B = t[3] or 0,
            A = if t[4] ~= nil then t[4] else 1,
        }
    end

    return cloneColor(fallback)
end

function Components.NormalizeUDim2(input: Types.UDim2Input?, fallback: Types.UDim2): Types.UDim2
    if input == nil then
        return {
            ScaleX = fallback.ScaleX,
            OffsetX = fallback.OffsetX,
            ScaleY = fallback.ScaleY,
            OffsetY = fallback.OffsetY,
        }
    end

    local t = input :: any
    if t[1] ~= nil then
        if #t >= 4 then
            return {
                ScaleX = t[1] or 0,
                OffsetX = t[2] or 0,
                ScaleY = t[3] or 0,
                OffsetY = t[4] or 0,
            }
        end
        return {
            ScaleX = 0,
            OffsetX = t[1] or 0,
            ScaleY = 0,
            OffsetY = t[2] or 0,
        }
    end

    return {
        ScaleX = t.ScaleX or 0,
        OffsetX = t.OffsetX or 0,
        ScaleY = t.ScaleY or 0,
        OffsetY = t.OffsetY or 0,
    }
end

function Components.NormalizeUDim1(input: Types.UDim1Input?, fallback: Types.UDim1): Types.UDim1
    if input == nil then
        return { X = fallback.X, Y = fallback.Y }
    end

    local t = input :: any
    if t[1] ~= nil then
        return {
            X = t[1] or 0,
            Y = t[2] or 0,
        }
    end

    return {
        X = t.X or 0,
        Y = t.Y or 0,
    }
end

function Components.NormalizeAlignment(input: Types.AlignInput?, fallback: Types.TextAlignment): Types.TextAlignment
    if input == nil then
        return { Horizontal = fallback.Horizontal, Vertical = fallback.Vertical }
    end

    local t = input :: any
    if t[1] ~= nil then
        return {
            Horizontal = (t[1] or fallback.Horizontal) :: Types.HorizontalAlign,
            Vertical = (t[2] or fallback.Vertical) :: Types.VerticalAlign,
        }
    end

    return {
        Horizontal = (t.Horizontal or fallback.Horizontal) :: Types.HorizontalAlign,
        Vertical = (t.Vertical or fallback.Vertical) :: Types.VerticalAlign,
    }
end

function Components.Layout(props: Types.LayoutProps?): Types.Layout
    local properties = props or ({} :: Types.LayoutProps)
    return {
        Position = Components.NormalizeUDim2(properties.Position, DEFAULT_POSITION),
        Size = Components.NormalizeUDim2(properties.Size, DEFAULT_SIZE),
        AnchorPoint = Components.NormalizeUDim1(properties.AnchorPoint, DEFAULT_ANCHOR),
        AbsPos = if properties.AbsPos then { X = properties.AbsPos.X, Y = properties.AbsPos.Y } else { X = 0, Y = 0 },
        AbsSize = if properties.AbsSize then { X = properties.AbsSize.X, Y = properties.AbsSize.Y } else { X = 0, Y = 0 },
    }
end

function Components.Background(color: Types.ColorInput?, radius: number?, borderColor: Types.Color?, borderWidth: number?): Types.Background
    local hasBorder = borderColor ~= nil or (borderWidth ~= nil and borderWidth > 0)
    return {
        Color = Components.NormalizeColor(color, DEFAULT_BG_COLOR),
        Radius = radius,
        BorderColor = if hasBorder then Components.NormalizeColor(borderColor, { R = 0, G = 0, B = 0, A = 1 }) else nil,
        BorderWidth = if hasBorder then (borderWidth or 1) else nil,
    }
end

function Components.Text(value: string?, size: number?, color: Types.ColorInput?, alignment: Types.AlignInput?): Types.Text
    return {
        Value = value or "New Label",
        Size = size or 12,
        Color = Components.NormalizeColor(color, DEFAULT_TEXT_COLOR),
        Alignment = Components.NormalizeAlignment(alignment, DEFAULT_ALIGNMENT),
    }
end

function Components.ResolveLayout(props: any): Types.Layout
    local layout = Components.Layout(props.Layout)

    if props.Fill then
        layout.Size = { ScaleX = 1, OffsetX = 0, ScaleY = 1, OffsetY = 0 }
        layout.Position = { ScaleX = 0, OffsetX = 0, ScaleY = 0, OffsetY = 0 }
        layout.AnchorPoint = { X = 0, Y = 0 }
    end

    if props.CenterIn then
        layout.AnchorPoint = { X = 0.5, Y = 0.5 }
        layout.Position = { ScaleX = 0.5, OffsetX = 0, ScaleY = 0.5, OffsetY = 0 }
    end

    if props.Anchor ~= nil then
        layout.AnchorPoint = Components.NormalizeUDim1(props.Anchor, layout.AnchorPoint)
    end

    if props.Pos ~= nil or props.Position ~= nil then
        layout.Position = Components.NormalizeUDim2(props.Pos or props.Position, layout.Position)
    end

    if props.Size ~= nil then
        layout.Size = Components.NormalizeUDim2(props.Size, layout.Size)
    end

    if props.X ~= nil then
        layout.Position.OffsetX = props.X
    end
    if props.Y ~= nil then
        layout.Position.OffsetY = props.Y
    end
    if props.Width ~= nil then
        layout.Size.OffsetX = props.Width
    end
    if props.Height ~= nil then
        layout.Size.OffsetY = props.Height
    end

    return layout
end

function Components.ResolveBackground(props: any): Types.Background
    local bg = props.Background
    local color: Types.ColorInput? = if props.Color ~= nil then props.Color elseif bg then bg.Color else nil
    local radius: number? = if props.Radius ~= nil then props.Radius elseif bg then bg.Radius else nil
    local borderColor: Types.Color? = if props.BorderColor ~= nil then props.BorderColor elseif bg then bg.BorderColor else nil
    local borderWidth: number? = if props.BorderWidth ~= nil then props.BorderWidth elseif bg then bg.BorderWidth else nil
    return Components.Background(color, radius, borderColor, borderWidth)
end

function Components.ResolveText(props: any): Types.Text
    local textProp = props.Text
    local isTable = type(textProp) == "table"

    local value: string? = if type(textProp) == "string" then textProp elseif isTable then (textProp :: any).Value else nil
    local size: number? = if props.TextSize ~= nil then props.TextSize elseif isTable then (textProp :: any).Size else nil
    local color: Types.ColorInput? = if props.TextColor ~= nil then props.TextColor elseif isTable then (textProp :: any).Color else nil
    local alignment: Types.AlignInput? = if props.Align ~= nil then props.Align elseif isTable then (textProp :: any).Alignment else nil

    return Components.Text(value, size, color, alignment)
end

function Components.Clickable(): Types.Clickable
    return {
        Pressed = Signal.new(),
        Released = Signal.new(),
        MouseEnter = Signal.new(),
        MouseLeave = Signal.new()
    }
end

function Components.Scroll(props: Types.ScrollProps?): Types.Scroll
    local properties = props or ({} :: Types.ScrollProps)
    return {
        CanvasPosition = Components.NormalizeUDim1(properties.CanvasPosition, DEFAULT_CANVAS_POS),
        CanvasSize = Components.NormalizeUDim2(properties.CanvasSize, DEFAULT_CANVAS_SIZE),
        ScrollSpeed = properties.ScrollSpeed or 30,
        AutoCanvasSize = if properties.AutoCanvasSize ~= nil then properties.AutoCanvasSize else false,
        AbsCanvasSize = { X = 0, Y = 0 },
    }
end

function Components.ResolveScroll(props: any): Types.Scroll
    local scroll = Components.Scroll(props.Scroll)

    if props.CanvasPosition ~= nil then
        scroll.CanvasPosition = Components.NormalizeUDim1(props.CanvasPosition, scroll.CanvasPosition)
    end
    if props.CanvasSize ~= nil then
        scroll.CanvasSize = Components.NormalizeUDim2(props.CanvasSize, scroll.CanvasSize)
    end
    if props.ScrollSpeed ~= nil then
        scroll.ScrollSpeed = props.ScrollSpeed
    end
    if props.AutoCanvasSize ~= nil then
        scroll.AutoCanvasSize = props.AutoCanvasSize
    end

    return scroll
end

return Components
