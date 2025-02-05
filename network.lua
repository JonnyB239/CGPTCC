-- network.lua - Network Detection API for ComputerCraft OS
-- Automatically detects advanced monitors connected directly or via modem

local network = {}

function findMonitor()
    -- Check for directly attached monitors
    for _, side in ipairs(peripheral.getNames()) do
        print("checking " .. side .. " for connected monitor")
        if peripheral.getType(side) == "monitor" then
            print("found monitor on "..side)
            return peripheral.wrap(side)
        end
    end
    
    -- Check for networked monitors via modem
    if peripheral.find("modem") then
        rednet.open(peripheral.getName(peripheral.find("modem")))
        local id, message = rednet.receive("monitor")
        if id and message == "request_monitor" then
            rednet.send(id, "monitor_response")
            local monitor = peripheral.wrap(peripheral.getNames()[id])
            if monitor then
                return monitor
            end
        end
    end
    print("failed to find monitor")
    return false
end

return network
