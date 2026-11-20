local Types = require("Globals.Types")

local Components = require("Classes.UI.Base.Components")
local Element = require("Classes.UI.Base.Element")

local Frame = {}
Frame.__index = Frame

function Frame.new(Props: Types.FrameCreationType): Types.UIElement
    local props = Props or ({} :: Types.FrameCreationType)

    local elementProps: Types.UIElementCreationType = {
        ZIndex = props.ZIndex,
        Visible = props.Visible,
        Clips = props.Clips,
        CustomDraw = props.CustomDraw,
        Children = props.Children,
        Layout = Components.ResolveLayout(props),
        Background = Components.ResolveBackground(props),
    }

    for i, child in ipairs(props :: any) do
        (elementProps :: any)[i] = child
    end

    local self = Element.new(elementProps)

    return (setmetatable(self, Frame) :: any) :: Types.UIElement
end

return (setmetatable(Frame, {
    __index = Element,
    __call = function(_, Props: Types.FrameCreationType): Types.UIElement
        return Frame.new(Props)
    end,
}) :: any) :: (Props: Types.FrameCreationType) -> Types.UIElement
