-- window_manager.lua - Window Manager API for ComputerCraft OS
-- Manages multi-window applications with a layered interface

local window_manager = {}
local windows = {}
local activeWindow = nil

function init()
    windows = {}
    activeWindow = nil
end

function createWindow(name, x, y, width, height, drawFunc, closeFunc)
    local win = {
        name = name,
        x = x,
        y = y,
        width = width,
        height = height,
        drawFunc = drawFunc,
        closeFunc = closeFunc or function() end,
        active = false
    }
    table.insert(windows, win)
    setActiveWindow(win)
end

function setActiveWindow(win)
    if activeWindow then
        activeWindow.active = false
    end
    activeWindow = win
    activeWindow.active = true
    render()
end

function closeWindow(name)
    for i, win in ipairs(windows) do
        if win.name == name then
            win.closeFunc()
            table.remove(windows, i)
            break
        end
    end
    if #windows > 0 then
        setActiveWindow(windows[#windows])
    else
        activeWindow = nil
    end
    render()
end

function render()
    gui.clear()
    for _, win in ipairs(windows) do
        if win.drawFunc then
            win.drawFunc(win)
        end
    end
end

function handleTouch(_, x, y)
    for _, win in ipairs(windows) do
        if x >= win.x and x <= (win.x + win.width) and y >= win.y and y <= (win.y + win.height) then
            setActiveWindow(win)
            return
        end
    end
end

return window_manager
