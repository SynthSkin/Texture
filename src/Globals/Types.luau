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

export type HorizontalAlign = "left" | "center" | "right"
export type VerticalAlign = "top" | "middle" | "bottom"

export type TextAlignment = {
    Vertical: VerticalAlign,
    Horizontal: HorizontalAlign,
}

export type ColorInput = Color | { number } | string
export type UDim2Input = UDim2 | { number }
export type UDim1Input = UDim1 | { number }
export type AlignInput = {
    Vertical: VerticalAlign?,
    Horizontal: HorizontalAlign?,
} | { string }

export type Layout = {
    Position: UDim2,
    Size: UDim2,
    AnchorPoint: UDim1,
    AbsPos: UDim1?,
    AbsSize: UDim1?
}

export type LayoutProps = {
    Position: UDim2Input?,
    Size: UDim2Input?,
    AnchorPoint: UDim1Input?,
    AbsPos: UDim1?,
    AbsSize: UDim1?,
}

export type Background = {
    Color: Color,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,
}

export type BackgroundProps = {
    Color: ColorInput?,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,
}

export type Text = {
    Value: string,
    Size: number,
    Color: Color,
    Alignment: TextAlignment,
}

export type TextProps = {
    Value: string?,
    Size: number?,
    Color: ColorInput?,
    Alignment: AlignInput?,
}

export type Clickable = {
    Pressed: Signal.Signal,
    Released: Signal.Signal,
    MouseEnter: Signal.Signal,
    MouseLeave: Signal.Signal
}

export type Scroll = {
    CanvasPosition: UDim1,
    CanvasSize: UDim2,
    ScrollSpeed: number,
    AutoCanvasSize: boolean,
    AbsCanvasSize: UDim1,
}

export type ScrollProps = {
    CanvasPosition: UDim1Input?,
    CanvasSize: UDim2Input?,
    ScrollSpeed: number?,
    AutoCanvasSize: boolean?,
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
    Scroll: Scroll?,
    
    CustomDraw: ((self: UIElement, pass: any) -> ())?,
    AddChild: (self: UIElement, child: UIElement) -> UIElement,
}

export type UIElementCreationType = {
    [number]: UIElement,
    Children: { UIElement }?,

    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: Layout?,
    Background: Background?,
    Text: Text?,
    Clickable: Clickable?,
    Scroll: Scroll?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}

export type FrameCreationType = {
    [number]: UIElement,
    Children: { UIElement }?,

    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: LayoutProps?,
    Background: BackgroundProps?,

    CenterIn: boolean?,
    Fill: boolean?,
    Anchor: UDim1Input?,
    Pos: UDim2Input?,
    Position: UDim2Input?,
    Size: UDim2Input?,
    X: number?,
    Y: number?,
    Width: number?,
    Height: number?,

    Color: ColorInput?,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}

export type LabelCreationType = {
    [number]: UIElement,
    Children: { UIElement }?,

    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: LayoutProps?,
    Background: BackgroundProps?,
    Text: (string | TextProps)?,

    CenterIn: boolean?,
    Fill: boolean?,
    Anchor: UDim1Input?,
    Pos: UDim2Input?,
    Position: UDim2Input?,
    Size: UDim2Input?,
    X: number?,
    Y: number?,
    Width: number?,
    Height: number?,

    Color: ColorInput?,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,

    TextSize: number?,
    TextColor: ColorInput?,
    Align: AlignInput?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}


export type ButtonCreationType = {
    [number]: UIElement,
    Children: { UIElement }?,

    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: LayoutProps?,
    Background: BackgroundProps?,
    Text: (string | TextProps)?,
    Clickable: Clickable?,

    CenterIn: boolean?,
    Fill: boolean?,
    Anchor: UDim1Input?,
    Pos: UDim2Input?,
    Position: UDim2Input?,
    Size: UDim2Input?,
    X: number?,
    Y: number?,
    Width: number?,
    Height: number?,

    Color: ColorInput?,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,

    TextSize: number?,
    TextColor: ColorInput?,
    Align: AlignInput?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}


export type PanelCreationType = {
    [number]: UIElement,
    Children: { UIElement }?,

    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: LayoutProps?,
    Background: BackgroundProps?,

    CenterIn: boolean?,
    Fill: boolean?,
    Anchor: UDim1Input?,
    Pos: UDim2Input?,
    Position: UDim2Input?,
    Size: UDim2Input?,
    X: number?,
    Y: number?,
    Width: number?,
    Height: number?,

    Color: ColorInput?,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}

export type ScrollingFrameCreationType = {
    [number]: UIElement,
    Children: { UIElement }?,

    ZIndex: number?,
    Visible: boolean?,
    Clips: boolean?,

    Layout: LayoutProps?,
    Background: BackgroundProps?,
    Scroll: ScrollProps?,

    CenterIn: boolean?,
    Fill: boolean?,
    Anchor: UDim1Input?,
    Pos: UDim2Input?,
    Position: UDim2Input?,
    Size: UDim2Input?,
    X: number?,
    Y: number?,
    Width: number?,
    Height: number?,

    Color: ColorInput?,
    Radius: number?,
    BorderColor: Color?,
    BorderWidth: number?,

    CanvasSize: UDim2Input?,
    CanvasPosition: UDim1Input?,
    ScrollSpeed: number?,
    AutoCanvasSize: boolean?,

    CustomDraw: ((self: UIElement, pass: any) -> ())?
}

return true
