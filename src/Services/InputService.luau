local Service = {}
local BetterTable = require("Library.Table")
--[[
    Input Service
    InputService.NewInputListener() -> Listener

    - Provide a key string (k)
    - Optionally provide contexts: 
        Contexts = {
            Required = {            -- ALL required contexts must be active in order for the input signal to fire.
                "requiredContext1",
                "requiredContext2",
            },
            Disallowed = {          -- If any ONE of the provided disallowed contexts are enabled the input signal will not fire.
                "disallowedContext1"
                "disallowedContext2"
            }
        }

    Listener.PressedSignal: Signal  -- Only fires if all contexts rules pass.
    Listener.ReleasedSignal: Signal -- Fires only if the pressed signal has fired without a released signal regardless of active contexts.

    Listener.Contexts               -- the listeners contexts to be edited any time
]]
Service.Inputs = {}
Service.Contexts = {}

local Listener = {}
Listener.__index = Listener

function Listener.new(k: string, contexts: {Required: { string }, Disallowed: { string }})
    local self = {}

    self._key = k
    self._active = false
    self.Contexts = contexts
    self.PressedSignal = Signal.new()
    self.ReleasedSignal = Signal.new()

    return setmetatable(self, Listener)
end

function Service.NewInputListener(k: string, contexts: {Required: { string }, Disallowed: { string }})
    local NewListener = Listener.new(k, contexts)
    table.insert(Service.Inputs, NewListener)
    return NewListener
end

function Service.EnableContext(context: string)
    if not table.find(Service.Contexts, context) then
        table.insert(Service.Contexts, context)
    end
end

function Service.DisableContext(context: string)
    if table.find(Service.Contexts, context) then
        table.remove(Service.Contexts, table.find(Service.Contexts, context))
    end
end

local function checkInputContext(Context)
    if not Context then return true end
    if not Context.Disallowed or not Context.Required then
        print("malformed input listener context")
        return false
    end

    if not BetterTable.doContentsExistIn(Context.Required, Service.Contexts) then return false end
    for i, context in Context.Disallowed do
        if table.find(Service.Contexts, context) then
            return false
        end
    end
    return true
end

-- Private used to fire signals
function Service._TriggerKeyboardInputEvents(k, InputType: string)
    for i, inputListener in Service.Inputs do
        if inputListener._key == k and checkInputContext(inputListener.Contexts) then
            if InputType == Enum.InputType.Start then
                inputListener.PressedSignal:Fire()
                inputListener._active = true
            elseif InputType == Enum.InputType.End then
                inputListener.ReleasedSignal:Fire()
                inputListener._active = false
            else
                print(`unknown input type: {InputType}`)
            end
        elseif inputListener._key == k and inputListener._active then
            inputListener.ReleasedSignal:Fire()
            inputListener._active = false
        end
    end
end

CallbackService.PushFunction(Enum.Callback.KeyPressed, "InputBegan", function(k)
    Service._TriggerKeyboardInputEvents(k, Enum.InputType.Start)
end)

CallbackService.PushFunction(Enum.Callback.KeyReleased, "InputEnded", function(k)
    Service._TriggerKeyboardInputEvents(k, Enum.InputType.End)
end)

return Service