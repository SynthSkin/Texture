local Service = {}

Service.Callbacks = {}

for name: any, str: string in pairs(Enum.Callback) do
    Service.Callbacks[str] = {
        _LovrCallback = str,
        Functions = {},
        _Signal = Signal.new(),
        _Connection = nil
    }
end

function Service.PushFunction(callback: string, id: string, func: () -> nil)
    if not Service.Callbacks[callback] then error("callback not found: " .. callback) end

    local CallbackObject = Service.Callbacks[callback]

    CallbackObject.Functions[id] = func

    if not CallbackObject._Connection then
        lovr[callback] = function(...)
            CallbackObject._Signal:Fire(...)
        end

        CallbackObject._Connection = CallbackObject._Signal:Connect(function(...) -- these meds got me fucked up
            for i, func in CallbackObject.Functions do
                func(...)
            end
        end)
    end
end

function Service.RemoveFunction(callback, id)
    if not Service.Callbacks[callback] then error("callback not found: " .. callback) end

    local CallbackObject = Service.Callbacks[callback]

    CallbackObject.Functions[id] = nil
end

return Service