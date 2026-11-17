local Components = {}

export type UDim2 = {
    ScaleX: number,
    OffsetX: number,
    ScaleY: number,
    OffsetY: number,
}

export type UDim1 = {
    X: number,
    Y: number
}

export type Layout = {
    Position: UDim2,
    Size: UDim2,
    AnchorPoint: UDim1,
    AbsPos: UDim1,
    AbsSize: UDim1
}

export type Background = {
    Color: { number },
    Radius: number?
}

export type Text = {
    Value: string,
    Size: number,
    Color: { number }
}

export type Clickable = {
    Pressed: any,
    Release: any,
    MouseEnter: any,
    MouseLeave: any
}

function Components.Layout(props: {[string]: any}?): Layout
    local properties = props or {}
    return {
        Position = properties.Position or {ScaleX = 0, OffsetX = 0, ScaleY = 0, OffsetY = 0},
        Size = properties.Size or {ScaleX = 0, OffsetX = 50, ScaleY = 0, OffsetY = 50},
        AnchorPoint = properties.AnchorPoint or {X = 0, Y = 0},
        AbsPos = {X = 0, Y = 0},
        AbsSize = {X = 0, y = 0}
    }
end

function Components.Background(color: {number}?, radius: number?): Background
    return {
        Color = color or {0.2, 0.2, 0.2, 1},
        Radius = radius
    }
end

function Components.Clickable(): Clickable
    return {
        Pressed = Signal.new(),
        Released = Signal.new(),
        MouseEnter = Signal.new(),
        MouseLeave = Signal.new()
    }
end

return Components