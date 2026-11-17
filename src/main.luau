Enum = require("Globals.Enum")
Signal = require("Library.Signal")
CallbackService = require("Services.CallbackService")
InputService = require("Services.InputService")

CallbackService.PushFunction(Enum.Callback.Load, "MainLoad", function() end)