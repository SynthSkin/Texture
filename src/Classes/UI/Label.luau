local Types = require("Globals.Types")

local Components = require("Classes.UI.Base.Components")
local Element = require("Classes.UI.Base.Element")

local Label = {}
Label.__index = Label

function Label.new(Props: Types.LabelCreationType): Types.UIElement
    local props = Props or ({} :: Types.LabelCreationType)

    local elementProps: Types.UIElementCreationType = {
        ZIndex = props.ZIndex,
        Visible = props.Visible,
        Clips = props.Clips,
        CustomDraw = props.CustomDraw,
        Children = props.Children,
        Layout = Components.ResolveLayout(props),
        Background = Components.ResolveBackground(props),
        Text = Components.ResolveText(props),
    }

    for i, child in ipairs(props :: any) do
        (elementProps :: any)[i] = child
    end

    local self = Element.new(elementProps)

    return (setmetatable(self, Label) :: any) :: Types.UIElement
end

return (setmetatable(Label, {
    __index = Element,
    __call = function(_, Props: Types.LabelCreationType): Types.UIElement
        return Label.new(Props)
    end,
}) :: any) :: (Props: Types.LabelCreationType) -> Types.UIElement
