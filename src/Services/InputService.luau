local Service = {}

Service.Inputs = {}
Service.Contexts = {}

local InputC = {}
InputC.__index = InputC

function InputC.new(key: string, contexts: {})
    local self = {}

    self.key = key
    self.contexts = contexts
    self.pressed = Signal.new()
    self.release = Signal.new()

    return setmetatable(self, InputC)
end

function InputC:Pressed()
    self.pressed:Fire()
end

return Service