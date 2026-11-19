local Types = require("Globals.Types")

local Components = require("Classes.UI.Base.Components")
local Element = require("Classes.UI.Base.Element")

local Frame = {}
Frame.__index = Frame
setmetatable(Frame, Element)

function Frame.new(Props: Types.FrameCreationType?)
    local props = Props or {}

    props.Layout = props.Layout or Components.Layout()
    props.Background = props.Background or Components.Background()

    local self = Element.new(props :: Types.UIElementCreationType)

    return setmetatable(self, Frame)
end

return Frame