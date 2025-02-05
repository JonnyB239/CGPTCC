-- update.lua (Now forces overwriting of existing files)

local repoOwner = "JonnyB239"
local repoName = "CGPTCC"
local branch = "main"
local apiURL = "https://api.github.com/repos/" .. repoOwner .. "/" .. repoName .. "/contents/"
local rawBaseURL = "https://raw.githubusercontent.com/" .. repoOwner .. "/" .. repoName .. "/" .. branch .. "/"

-- Function to fetch file list from GitHub API
local function getFileList()
    print("Fetching file list from GitHub...")
    local response = http.get(apiURL)
    
    if not response then
        print("Failed to fetch file list!")
        return {}
    end

    local data = response.readAll()
    response.close()

    -- Parse JSON response
    local success, fileData = pcall(textutils.unserializeJSON, data)
    if not success or type(fileData) ~= "table" then
        print("Error parsing file list!")
        return {}
    end

    -- Extract file names
    local fileList = {}
    for _, file in ipairs(fileData) do
        if file.type == "file" then
            table.insert(fileList, file.name)
        end
    end

    return fileList
end

-- Function to download a file (forces overwrite)
local function downloadFile(file)
    local url = rawBaseURL .. file
    print("Downloading: " .. url)
    shell.run("delete",file)
    shell.run("wget", url, file)
end

-- Function to update all files
local function update()
    print("Fetching update list...")
    local fileList = getFileList()

    if #fileList == 0 then
        print("No files to update. Exiting.")
        return
    end

    print("Updating files...")
    for _, file in ipairs(fileList) do
        downloadFile(file)
    end

    print("Update complete! Rebooting...")
    os.reboot()
end

update()
