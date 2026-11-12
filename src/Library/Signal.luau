local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

export type Connection = {
    _connected: boolean,
    _next: Connection | boolean,
    _signal: any,
    _func: (...any) -> (),
    Disconnect: (self: Connection) -> (),
}

export type Signal = {
    _nextConnection: Connection | boolean,
    _waitingThreads: { thread },
    Connect: (self: Signal, func: (...any) -> ()) -> Connection,
    Once: (self: Signal, func: (...any) -> ()) -> Connection,
    Wait: (self: Signal) -> ...any,
    Fire: (self: Signal, ...any) -> (),
    DisconnectAll: (self: Signal) -> (),
}

function Signal.new(): Signal
    return (setmetatable({
        _nextConnection = false,
        _waitingThreads = {},
    }, Signal) :: any) :: Signal
end

function Connection.new(sig: any, func: (...any) -> ()): Connection
    return (setmetatable({
        _connected = true,
        _next = false,
        _signal = sig,
        _func = func,
    }, Connection) :: any) :: Connection
end

function Connection:Disconnect()
    if not self._connected then
        return
    end
    self._connected = false

    if self._signal._nextConnection == self then
        self._signal._nextConnection = self._next
    else
        local prev = self._signal._nextConnection
        while prev and prev._next ~= self do
            prev = prev._next
        end

        if prev then
            prev._next = self._next
        end
    end
end

function Signal:Connect(func: (...any) -> ()): Connection
    local newConnection = Connection.new(self, func)
    if self._nextConnection then
        newConnection._next = self._nextConnection
        self._nextConnection = newConnection
    else
        self._nextConnection = newConnection
    end
    return newConnection
end

function Signal:Once(func: (...any) -> ()): Connection
    local connection: Connection
    connection = self:Connect(function(...)
        if connection._connected == true then
            connection:Disconnect()
        end
        func(...)
    end)
    return connection
end

function Signal:Wait(): ...any
    local waitingThread = coroutine.running()
    assert(waitingThread, "Cannot call :Wait() outside of coroutine")
    local connection: Connection
    connection = self:Connect(function(...)
        if connection._connected == true then
            connection:Disconnect()
        end
    end)
    table.insert(self._waitingThreads, waitingThread)
    return coroutine.yield()
end

function Signal:Fire(...: any)
    local nextConnection = self._nextConnection
    while nextConnection do
        if nextConnection._connected then
            local thread = coroutine.create(nextConnection._func)
            local success, err = coroutine.resume(thread, ...)

            if not success then
                print(`error in signal listener: {err}`)
            end
        end
        nextConnection = nextConnection._next
    end

    local threadSnapshot = self._waitingThreads
    self._waitingThreads = {}

    for _, thread in threadSnapshot do
        if coroutine.status(thread) == "suspended" then
            local success, err = coroutine.resume(thread, ...)
            if not success then
                print(`error resuming wait thread: {err}`)
            end
        end
    end
end

function Signal:DisconnectAll()
    local nextConnection = self._nextConnection
    while nextConnection do
        local current = nextConnection
        nextConnection = nextConnection._next
        current:Disconnect()
    end

    self._waitingThreads = {}
    self._nextConnection = false
end

return Signal
