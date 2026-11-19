Enum = require("Globals.Enum")
Signal = require("Library.Signal")

CallbackService = require("Services.CallbackService")
InputService = require("Services.InputService")
UIService = require("Services.UIService")

local Frame = require("Classes.UI.Frame")
local Types = require("Globals.Types")

UIService.Root:AddChild(Frame.new({
    Background = {Color = {R=1,G=1,B=1,A=1}}
}))

CallbackService.PushFunction(Enum.Callback.Load, "MainLoad", function() end)