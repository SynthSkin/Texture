local Signal = require("Library.Signal")

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

export type Color = {
    R: number,
    G: number,
    B: number,
    A: number,
}

export type Layout = {
    Position: UDim2,
    Size: UDim2,
    AnchorPoint: UDim1,
    AbsPos: UDim1,
    AbsSize: UDim1
}

export type Background = {
    Color: Color,
    Radius: number?
}

export type Text = {
    Value: string,
    Size: number,
    Color: Color
}

export type Clickable = {
    Pressed: Signal.Signal,
    Released: Signal.Signal,
    MouseEnter: Signal.Signal,
    MouseLeave: Signal.Signal
}

export type UIElement = {
    Parent: UIElement?,
    Children: { UIElement },

    ZIndex: number,
    Visible: boolean,
    Clips: boolean,

    Layout: Layout?,
    Background: Background?,
    Text: Text?,
    Clickable: Clickable?,
    
    CustomDraw: ((self: UIElement, pass: any) -> ())?,
    AddChild: (self: UIElement, child: UIElement) -> UIElement,
}

export type UIElementCreationType = {
    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: Layout?,
    Background: Background?,
    Text: Text?,
    Clickable: Clickable?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}

export type FrameCreationType = {
    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: Layout?,
    Background: Background?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}

return true