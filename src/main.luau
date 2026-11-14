Enum = require("Globals.Enum")
Signal = require("Library.Signal")
CallbackService = require("Services.CallbackService")

CallbackService.PushFunction(Enum.Callback.Load, "MainLoad", function()
    print("loaded")
end)