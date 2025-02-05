-- gui.lua - GUI Handling API for ComputerCraft OS
-- Manages drawing, buttons, and touch interactions on an advanced monitor

os.loadAPI("window_manager")

local gui = {}
local monitor
local buttons = {}

function init(mon)
    monitor = mon
    monitor.setTextScale(1)
    gui.clear()
end

function clear()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
end

function gui.drawDesktop()
    monitor.setCursorPos(2, 2)
    monitor.setBackgroundColor(colors.blue)
    monitor.setTextColor(colors.white)
    monitor.write("Welcome to Custom OS")
    
    gui.addButton("File Manager", 2, 4, 15, 6, colors.gray, colors.white, function()
        window_manager.open("File Manager", filesystem.openFileManager)
    end)
    gui.render()
end

function addButton(label, x1, y1, x2, y2, bgColor, textColor, callback)
    table.insert(buttons, {
        label = label,
        x1 = x1, y1 = y1, x2 = x2, y2 = y2,
        bgColor = bgColor, textColor = textColor,
        callback = callback
    })
end

function render()
    for _, button in ipairs(buttons) do
        monitor.setBackgroundColor(button.bgColor)
        monitor.setTextColor(button.textColor)
        for y = button.y1, button.y2 do
            monitor.setCursorPos(button.x1, y)
            monitor.write(string.rep(" ", button.x2 - button.x1))
        end
        local textX = button.x1 + math.floor((button.x2 - button.x1 - #button.label) / 2)
        local textY = math.floor((button.y1 + button.y2) / 2)
        monitor.setCursorPos(textX, textY)
        monitor.write(button.label)
    end
end

function handleTouch(_, x, y)
    for _, button in ipairs(buttons) do
        if x >= button.x1 and x <= button.x2 and y >= button.y1 and y <= button.y2 then
            button.callback()
            return
        end
    end
end

return gui
