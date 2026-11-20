local Types = require("Globals.Types")

local Components = require("Classes.UI.Base.Components")
local Element = require("Classes.UI.Base.Element")

local ScrollingFrame = {}
ScrollingFrame.__index = ScrollingFrame

function ScrollingFrame.new(Props: Types.ScrollingFrameCreationType): Types.UIElement
    local props = Props or ({} :: Types.ScrollingFrameCreationType)

    local elementProps: Types.UIElementCreationType = {
        ZIndex = props.ZIndex,
        Visible = props.Visible,
        Clips = if props.Clips ~= nil then props.Clips else true,
        CustomDraw = props.CustomDraw,
        Children = props.Children,
        Layout = Components.ResolveLayout(props),
        Background = Components.ResolveBackground(props),
        Scroll = Components.ResolveScroll(props),
    }

    for i, child in ipairs(props :: any) do
        (elementProps :: any)[i] = child
    end

    local self = Element.new(elementProps)

    return (setmetatable(self, ScrollingFrame) :: any) :: Types.UIElement
end

return (setmetatable(ScrollingFrame, {
    __index = Element,
    __call = function(_, Props: Types.ScrollingFrameCreationType): Types.UIElement
        return ScrollingFrame.new(Props)
    end,
}) :: any) :: (Props: Types.ScrollingFrameCreationType) -> Types.UIElement
