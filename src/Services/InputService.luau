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

function Service.TriggerInputEvents(k, InputType: string)
    for i, inputListener in Service.Inputs do
        if inputListener._key == k and BetterTable.doContentsExistIn(Service.Contexts, inputListener.Contexts.Required) then

            for i, context in inputListener.Contexts.Disallowed do if table.find(Service.Contexts, context) then return end end

            if InputType == Enum.InputType.Start then
                inputListener.PressedSignal:Fire()
            elseif InputType == Enum.InputType.End then
                inputListener.ReleasedSignal:Fire()
            else
                print(`unknown input type: {InputType}`)
            end
        end
    end
end

return Service