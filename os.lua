-- ComputerCraft Custom OS - Main Program
-- This program runs a Windows-like OS on an advanced monitor with touch buttons and a file manager
-- It automatically detects connected monitors (direct or via modem)
-- Modular API structure for easy updates

-- Load APIs
os.loadAPI("gui")
os.loadAPI("filesystem")
os.loadAPI("network")

-- Detect and configure monitor
print("attempting to set globalMonitor")
globalMonitor = network.lua.findMonitor()  -- Automatically detects an attached or networked monitor
if not globalMonitor then
    print("No advanced monitor detected!")
    return
end

-- Initialize GUI
gui.init(globalMonitor)

-- Main OS loop
local function main()
    gui.clear()
    gui.drawDesktop()
    
    while true do
        local event, param1, param2, param3 = os.pullEvent()
        
        if event == "monitor_touch" then
            gui.handleTouch(param1, param2, param3)
        elseif event == "terminate" then
            print("Shutting down OS...")
            break
        end
    end
end

-- Run OS
main()
