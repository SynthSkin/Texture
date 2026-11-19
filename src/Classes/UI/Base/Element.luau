local Types = require("Globals.Types")

local Element = {}
Element.__index = Element

function Element.new(Components: Types.UIElementCreationType): Types.UIElement
    local self = setmetatable({
        Parent = nil,
        Children = {},
        ZIndex = Components.ZIndex or 1,
        Visible = if Components.Visible ~= nil then Components.Visible else true,
        Clips = Components.Clips or false,
        Layout = Components.Layout,
        Background = Components.Background,
        Clickable = Components.Clickable,
        CustomDraw = Components.CustomDraw,
    }, Element)

    return(self :: any) :: Types.UIElement
end

function Element:AddChild(child: Types.UIElement): Types.UIElement
    child.Parent = self
    table.insert(self.Children, child)
    return child
end

return Element