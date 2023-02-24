local NoName = ...
if --[[(...).name ~= "NoName" or]] NoName.Utils == nil then return end

local doprintfiles = (function()
    local printed = false
    return function()
        if printed then return end
        print('[BR] Copying Media files and reloading...')
        printed = true
    end
end)()

local function CopyMedia()
    local mediaPath = '/scripts/BadRotations/3rd Party Files/Media/'
    local wowMediaPath = 'Interface/Addons/Media/'
    if not DirectoryExists(mediaPath) then error(format('Cannot find Media Directory "%s"', mediaPath), 2) end
    local needreload = false

    if not DirectoryExists(wowMediaPath) then
        doprintfiles()
        needreload = true
        CreateDirectory(wowMediaPath)
        if not DirectoryExists(wowMediaPath) then error('Cannot Create "Interface\\Addons\\Media" Directory') end
    end
    local files = ListFiles(mediaPath .. '*')
    for _, v in pairs(files) do
        if FileExists(mediaPath .. v) and not FileExists(wowMediaPath .. v) then -- exclude '.' and '..' folders cause they error
            doprintfiles()
            needreload = true
            local data = ReadFile(mediaPath .. v)
            if data then
                WriteFile(wowMediaPath .. v, data)
            end
            if not FileExists(wowMediaPath .. v) then error(format('Cannot Create Media File "%s"',v)) end
        end
    end
    if needreload and not InGlue() then C_Timer.After(2,function() Unlock('ReloadUI') end) return false end
    return true
end

if not securecall(CopyMedia) then return end
if InGlue() then return end

local read   = NoName.Utils.Storage.read
local write  = NoName.Utils.Storage.write
local JSON   = NoName.Utils.JSON
local AceGUI = NoName.Utils.AceGUI
local toc = ReadFile('/scripts/BadRotations/BadRotations.toc')
local br = {}
br.files = {}

-- Add Lua Files from .toc
for line in toc:gmatch("([^\n]*)\n?") do
    local thisLine = line:trim()
    if thisLine:find('#') == nil and thisLine:len() > 0
        and thisLine:find('.lua') ~= nil
    then
        thisLine = thisLine:gsub("\\","/")
        thisLine = thisLine:gsub(" ","")
        thisLine = thisLine:gsub(".lua","")
        thisLine = 'BadRotations/'..thisLine
        br.files[#br.files+1] = {
            file = thisLine,
            load = true
        }
        -- Lua Files loaded via XML Files
        if thisLine == "BadRotations/Libs/DiesalStyle-1.0/DiesalStyle-1.0" then
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/DiesalGUI-1.0', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Window', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ScrollFrame', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ScrollingEditBox', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ScrollingMessageFrame', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/CheckBox', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Button', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Spinner', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Input', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Dropdown', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/DropdownItem', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ComboBox', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ComboBoxItem', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Accordian', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/AccordianSection', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Tree', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Branch', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Bar', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalMenu-1.0/DiesalMenu-1.0', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalMenu-1.0/Objects/MenuItem', load = true}
            br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalMenu-1.0/Objects/Menu', load = true}
        end
    end
end

-- Unlocker Lua Files
br.files[#br.files+1] = {file = 'BadRotations/Unlockers/tinkr', load = false}
br.files[#br.files+1] = {file = 'BadRotations/Unlockers/nn', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Unlockers/daemonic', load = false}

-- Load Files into WoW
for i = 1, #br.files do
    local file = br.files[i].file
    local load = br.files[i].load
	if load then
        -- print("Loading File: /scripts/"..file)
		NoName:Require('/scripts/'..file, br)
    -- else
    --     print("Did not load File: /scripts/"..file)
	end
end

-- Call BR Load Function
if UnitExists('player') then
    print "[Nn] Loading BR"
    br.load()
end
