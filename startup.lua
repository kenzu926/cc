local MATRIX_NAME = "inductionPort_0"
local REACTOR_NAME = "fissionReactorLogicAdapter_0"

local START_AT = 0.80
local STOP_AT = 0.98
local CHECK_INTERVAL = 1

local matrix = assert(
    peripheral.wrap(MATRIX_NAME),
    "Induction Matrix not found: " .. MATRIX_NAME
)

local reactor = assert(
    peripheral.wrap(REACTOR_NAME),
    "Fission Reactor not found: " .. REACTOR_NAME
)

while true do
    local stored = matrix.getEnergyFilledPercentage()
    local running = reactor.getStatus()

    if stored >= STOP_AT and running then
        reactor.scram()
        running = false
    elseif stored <= START_AT and not running then
        reactor.activate()
        running = true
    end

    term.clear()
    term.setCursorPos(1, 1)
    print(("Energy:  %.2f%%"):format(stored * 100))
    print("Reactor: " .. (running and "ON" or "OFF"))
    print("Start <= 80% | Stop >= 98%")

    sleep(CHECK_INTERVAL)
end
