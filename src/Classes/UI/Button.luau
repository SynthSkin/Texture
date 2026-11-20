local Types = require("Globals.Types")

local Components = require("Classes.UI.Base.Components")
local Element = require("Classes.UI.Base.Element")

local Button = {}
Button.__index = Button

function Button.new(Props: Types.ButtonCreationType): Types.UIElement
    local props = Props or ({} :: Types.ButtonCreationType)

    local elementProps: Types.UIElementCreationType = {
        ZIndex = props.ZIndex,
        Visible = props.Visible,
        Clips = props.Clips,
        CustomDraw = props.CustomDraw,
        Children = props.Children,
        Layout = Components.ResolveLayout(props),
        Background = Components.ResolveBackground(props),
        Text = Components.ResolveText(props),
        Clickable = props.Clickable or Components.Clickable(),
    }

    for i, child in ipairs(props :: any) do
        (elementProps :: any)[i] = child
    end

    local self = Element.new(elementProps)

    return (setmetatable(self, Button) :: any) :: Types.UIElement
end

return (setmetatable(Button, {
    __index = Element,
    __call = function(_, Props: Types.ButtonCreationType): Types.UIElement
        return Button.new(Props)
    end,
}) :: any) :: (Props: Types.ButtonCreationType) -> Types.UIElement
