local Types = require("Globals.Types")

local Element = {}
Element.__index = Element

function Element.new(Components: Types.UIElementCreationType?): Types.UIElement
    local props = Components or ({} :: Types.UIElementCreationType)
    local self = setmetatable({
        Parent = nil,
        Children = {},
        ZIndex = props.ZIndex or 1,
        Visible = if props.Visible ~= nil then props.Visible else true,
        Clips = props.Clips or false,
        Layout = props.Layout,
        Background = props.Background,
        Text = props.Text,
        Clickable = props.Clickable,
        Scroll = props.Scroll,
        CustomDraw = props.CustomDraw,
    }, Element)

    local element = (self :: any) :: Types.UIElement

    if props.Children then
        for _, child in props.Children do
            element:AddChild(child)
        end
    end

    for _, child in ipairs(props :: any) do
        element:AddChild(child)
    end

    return element
end

function Element:AddChild(child: Types.UIElement): Types.UIElement
    child.Parent = self
    table.insert(self.Children, child)
    return child
end

return setmetatable(Element, {
    __call = function(_, props: Types.UIElementCreationType?): Types.UIElement
        return Element.new(props)
    end,
})
