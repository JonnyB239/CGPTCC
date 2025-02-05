-- filesystem.lua - File Management API for ComputerCraft OS
-- Provides a Windows-like file manager system

local filesystem = {}

function filesystem.listFiles(directory)
    directory = directory or "/"
    if not fs.exists(directory) or not fs.isDir(directory) then
        return nil, "Invalid directory"
    end
    return fs.list(directory)
end

function filesystem.createFile(filePath)
    if fs.exists(filePath) then
        return nil, "File already exists"
    end
    local file = fs.open(filePath, "w")
    file.close()
    return true
end

function filesystem.deleteFile(filePath)
    if not fs.exists(filePath) then
        return nil, "File does not exist"
    end
    fs.delete(filePath)
    return true
end

function filesystem.readFile(filePath)
    if not fs.exists(filePath) or fs.isDir(filePath) then
        return nil, "File not found or is a directory"
    end
    local file = fs.open(filePath, "r")
    local content = file.readAll()
    file.close()
    return content
end

function filesystem.writeFile(filePath, content)
    local file = fs.open(filePath, "w")
    file.write(content)
    file.close()
    return true
end

function filesystem.openFileManager()
    print("Opening File Manager...")
    local files = filesystem.listFiles("/")
    if files then
        for _, file in ipairs(files) do
            print(file)
        end
    else
        print("Error: Unable to open file manager.")
    end
end

return filesystem
