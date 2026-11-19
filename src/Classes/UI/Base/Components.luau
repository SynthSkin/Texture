local Types = require("Globals.Types")

local Components = {}

function Components.Layout(props: { Position: Types.UDim2?, Size: Types.UDim2?, AnchorPoint: Types.UDim1? }?): Types.Layout
    local properties = props or {}
    return {
        Position = properties.Position or {ScaleX = 0, OffsetX = 0, ScaleY = 0, OffsetY = 0},
        Size = properties.Size or {ScaleX = 0, OffsetX = 50, ScaleY = 0, OffsetY = 50},
        AnchorPoint = properties.AnchorPoint or {X = 0, Y = 0},
        AbsPos = {X = 0, Y = 0},
        AbsSize = {X = 0, Y = 0}
    }
end

function Components.Background(color: Types.Color?, radius: number?): Types.Background
    return {
        Color = color or {R = 0.2, G = 0.2, B = 0.2, A = 1},
        Radius = radius
    }
end

function Components.Clickable(): Types.Clickable
    return {
        Pressed = Signal.new(),
        Released = Signal.new(),
        MouseEnter = Signal.new(),
        MouseLeave = Signal.new()
    }
end

return Components