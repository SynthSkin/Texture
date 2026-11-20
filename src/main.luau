Enum = require("Globals.Enum")
Signal = require("Library.Signal")

CallbackService = require("Services.CallbackService")
InputService = require("Services.InputService")
UIService = require("Services.UIService")

local _App = require("App")

CallbackService.PushFunction(Enum.Callback.Load, "MainLoad", function() end)