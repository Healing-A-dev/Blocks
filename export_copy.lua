dofile('./.blocks/Blocks.lua')
--[[
CONST_NAME = .blocks
INSTALL_PATH = /usr/local/bin
MVDIR = /home/$(USER)/$(CONST_NAME)
]]
local Blocks = Blocks
local exported = {}
local cmdL,silent,advanced_mode = false,false,false
local filext = ""
local files
holdBlocks = {} -- Will hold the Blocks instead of the Blocks table

--[[Configuration file handling functions]]--
local function getConfig()
    local file = io.open(".blocks/config.yaml","r")
    if file == nil then
        error("Missing .blocks/config.yaml")
    end
    local lines = file:lines()
    local currentLine = 1
    for line in lines do
        if currentLine > 1 and #line:gsub("%s+","") > 0 and not line:match("^%#") then
            line = line:gsub("^%s+",""):gsub("%s+$","")
            local var = line:match("__%w+:"):gsub("%:","")
            local value = line:match(":.+"):gsub("^%s+",""):gsub("^:","")
            _G[var] = value
        end
        currentLine = currentLine + 1
    end
end

local function updateConfig()
    print("=> Copying configuration file")
    local file = io.open(".blocks/config.yaml","r")
    if file == nil then
        error("Missing .blocks/config.yaml")
    end
    local lines = file:lines()
    local toAppend = {}
    for line in lines do
        if not line:find("^__NAME") and not line:find("^__VERSION") and not line:find("^#") then
            toAppend[#toAppend+1] = line
            os.execute('sleep 0.01')
        end
    end
    file:close()
    print("\027[93mCompleted\027[0m")
    return toAppend
end


--[[Cache handling functions]]--
local function updateCache()
    
end

--Cache Reader
local function readCache()
    local cachefile = ".blocks/cache/cachefiles.bfcache"

    --ds
    local function ds(sv)
        local ns = {}
        local dv = 0
        local __NAME = __NAME:gsub("[%s+'\"]","")
        for s = 1, #__NAME do
            ns[#ns+1] = __NAME:sub(s,s):byte()
        end
        for ipit,vaipit in pairs(ns) do
            dv = (dv + vaipit) * (ns[ipit]-(ns[ipit]-1))
        end
        dv =  dv/202
        ns = {}
        for s = 1, #sv do
            ns[#ns+1] = string.char((sv:sub(s,s):byte()+dv))
        end
        return table.concat(ns)
    end

    --Reading Cache
    local cachedfiles = {}
    if io.open(cachefile,"r") == nil then
        os.execute("cd .blocks && mkdir cache && touch cache/cachefiles.bfcache && cd")
    end
    local file = io.open(cachefile,"r")
    local lines = file:lines()
    for line in lines do
        local name = line:match("-%s?[^%.]+")
        if name ~= nil then
            name = name:gsub("^%s+%-%s",""):gsub("%:$","")
            cachedfiles[ds(name):gsub("^0%#","")] = true
        end
    end
    file:close()
    return cachedfiles
end

--Cache Updater
local function cache(blockName)
    local cachefile = ".blocks/cache/cachefiles.bfcache"

    --es
    local function es(sv)
        local ns = {}
        local ev = 0
        local __NAME = __NAME:gsub("[%s+'\"]","")
        for s = 1, #__NAME do
            ns[#ns+1] = __NAME:sub(s,s):byte()
        end
        for ipit,vaipit in pairs(ns) do
            ev = (ev + vaipit) * (ns[ipit] - (ns[ipit]-1))
        end
        ev = ev/202
        ns = {}
        for s = 1, #sv do
            ns[#ns+1] = string.char((sv:sub(s,s):byte()-ev))
        end
        return table.concat(ns)
    end

    --Loading/Creating Cache
    local cache = readCache()
    function cache.search(self,block)
        return self[block] or false
    end

    local file = io.open(cachefile,"a")
    if not cache:search(blockName) then
        local lineStore = holdBlocks[blockName].contents("*l")
        file:write("\n- "..es(blockName)..":\n")
        for _,i in pairs(lineStore) do
            file:write("    "..es(i).."\n")
        end
        file:write(es("endBlock").."\n")
    end
    file:close()
end

--Cache Loader
local function loadCache(block_file_name)
    local cachefile = ".blocks/cache/cachefiles.bfcache"
    local file_store = {ds = {}, es = {}}

    --ds
    local function ds(sv)
        local ns = {}
        local dv = 0
        local __NAME = __NAME:gsub("[%s+'\"]","")
        for s = 1, #__NAME do
            ns[#ns+1] = __NAME:sub(s,s):byte()
        end
        for ipit,vaipit in pairs(ns) do
            dv = (dv + vaipit) * (ns[ipit]-(ns[ipit]-1))
        end
        dv =  dv/202
        ns = {}
        for s = 1, #sv do
            ns[#ns+1] = string.char((sv:sub(s,s):byte()+dv))
        end
        return table.concat(ns)
    end
    
    if block_file_name == nil then
        print("Blocks: No block specified to run\n\027[91mTerminating Process\027[0m")
        os.exit()
    end
    local Cache = readCache()
    if Cache[block_file_name] then
        local file = io.open(cachefile, 'r')
        if file == nil then
            print("Blocks: No cache file '.blocks/cache/cachefiles.bfcache' was found\n\027[91mTerminating Process\027[0m")
            os.exit()
        end
        local lines = file:lines()
        for line in lines do
            file_store.es[#file_store.es+1] = line
            file_store.ds[#file_store.ds+1] = ds(line:gsub("^%s+",""))
        end
        file:close()

        --Editing File
        local file = io.open(cachefile, 'w+')
        for _,i in pairs(file_store.ds) do
            if i:find("0%#[^%:]+%=") then
                local name = i:match("0%#.+%="):gsub("^0%#",""):gsub("%=$","")
                i = "startBlock "..name..":"
            end
            file:write(i.."\n")
        end
        file:close()
        
        --Building Blocks
        Blocks.BuildFromFile(cachefile,"",true)

        --Resetting File
        file = io.open(cachefile, "w+")
        file:close()
        for _,i in pairs(Blocks) do
            print(tostring(i))
            if type(i) == "table" then
                cache(i)
            end
        end
    else
        print("Blocks: block '"..block_file_name.."' was not found in the cache\n\027[91mTerminating Process\027[0m")
        os.exit()
    end
end

--[[Block Export Function]]--
local function export()
    getConfig()
    if arg[1] == nil then
        io.write('Insert File(s) To Export Blocks From: \n> ')
        files = io.read()
    end
    for file in files:gmatch('[^,]+') do
        file = file:gsub('^%s+',''):gsub('%s+$','')
        if not io.open(file) then
            if not silent then
                print('\027[91m=> Skipping file \''..file..'\'. File does not exsist.\027[0m')
            end
        else
            if not silent then
                print('\n\027[92m=> Generating Blocks from file \''..file..'\':\027[0m')
            end
            Blocks.BuildFromFile(file,"",cmdL)
            local toExport = Blocks.ShowAllBlocks('-s')
            exported[#exported+1] = file
            exported[file] = {}
            for _,i in pairs(Blocks) do
                if type(i) == 'table' then
                    holdBlocks[_] = i
                    Blocks[_] = nil
                end
            end
            for _,i in pairs(toExport) do
                --os.execute('sleep 0.02')
                if not silent then
                    print('\t\027[1m\027[93mGenerated block \''.._..'\'.\027[0m')
                end
                exported[file][#exported[file]+1] = _
            end
        end
    end
    if #exported > 0 then
        if not silent then print('\n\nSuccessfully generated all blocks from \''..table.concat(exported,'\' and \'')..'\'') end
        os.execute('sleep 2')
        for _,i in pairs(exported) do
            if type(i) == 'table' then
                if type(_) == "string" and not _:find("%..+$") and __EXT == nil then
                    io.write('\n\027[91m[No File Extension(s) Found]\027[0m Insert a file extension to assign to blocks:\n'.._..'>')
                    filext = io.read()
                else
                    filext = ""
                end
                if __EXT ~= nil then 
                    __EXT = __EXT:gsub("['\"]",""):gsub("^%s+","")
                    if _:find("%..+$") then
                        _ = _:gsub("%..+$",__EXT)
                    else
                        _ = _..__EXT
                    end
                else
                    _ = _..filext
                end
                if not advanced_mode then
                    io.write('\nInsert path to export to (default path = /'.._:gsub('%..+$','')..'):\n> ')
                    local path = io.read()
                    if path == '' then path = _:gsub('%..+$','') end
                    for s,t in pairs(i) do
                        --os.execute('sleep 0.02')
                        holdBlocks[t].build(_:match('%..+$'),path..'/')
                        if not _:match('%..+') and not silent then
                            print('\027[93m\tSuccessfully exported block \''..t..'\' to '..path..'/'..t.._..'\027[0m')
                        elseif not silent then
                            print('\027[93m\tSuccessfully exported block \''..t..'\' to '..path..'/'..t.._:match('%..+')..'\027[0m')
                        end
                        if __CACHE then
                            cache(t)
                        end
                    end
                else
                    ::restart_process::
                    io.write("\nEnter the name(s) or group(s) of blocks to export:\n> ")
                    local blocks = io.read()
                    if blocks:gsub("%s+","") == "Blocks.ShowAllBlocks" then
                        for _,i in pairs(holdBlocks) do
                            print("Block: ".._)
                        end
                        goto restart_process
                    end
                    for block in blocks:gmatch("[^%,]+") do
                        local block = block:gsub("%s+","")
                        local ext = ""
                        if block:match("%/$") then
                            for s,t in pairs(holdBlocks) do
                                if s:match("^"..block) then
                                     io.write("\nInsert file extension to assign to block '"..s.."' (default file extension = '".._:match("%..+$").."'): ")
                                     local newEXT = io.read()
                                     if newEXT ~= "" then
                                         ext = s:match("[^%/]+$") or s
                                         ext = ext:gsub("%/","")..newEXT
                                     else
                                         ext = _:match("[^/]+$")
                                     end
                                     io.write("\nInsert path to export to (default path = /"..s:gsub("%..+$","").."): ")
                                     local path = io.read()
                                     if path == "" then 
                                        path = s:gsub("%..+$","")
                                     else
                                        holdBlocks[s].__PATH__ = path
                                        holdBlocks[s].__NAME__ = s:match("%/[^%/]+$"):gsub("%/","")
                                     end
                                     holdBlocks[s].__NAME__ = holdBlocks[s].__NAME__ or s
                                     holdBlocks[s].build(ext:match("%..+$"),path.."/")
                                    if __CACHE then
                                        cache(block)
                                    end
                                    print("\027[93m\tSuccessfully exported block '"..s.."' to '"..path.."/"..holdBlocks[s].__NAME__..ext:match("%..+$").."'\027[0m") 
                                end
                            end
                        end    
                        if holdBlocks[block] ~= nil then
                            io.write("\nInsert file extension to assign to block '"..block.."' (default file extension = '".._:match("%..+$").."'): ")
                            local newEXT = io.read()
                            if newEXT ~= "" then
                               ext = block:match("[^%/]+$") or block 
                               ext = ext:gsub("%/","")..newEXT
                            else
                                ext = _:match("[^/]+$")
                            end
                            io.write("\nInsert path to export to (default path = /"..block:gsub("%..+$","").."): ")
                            local path = io.read()
                            if path == "" then path = block:gsub("%..+$","") end
                            if block:match("%/") then holdBlocks[block].__NAME__ = block:match("%/[^%/]+$"):gsub("%/","") end
                            holdBlocks[block].build(ext:match("%..+$"),path.."/")
                            if __CACHE then
                                cache(block)
                            end
                            print("\027[93m\tSuccessfully exported block '"..block.."' to '"..path.."/"..block..ext:match("%..+$").."'\027[0m") 
                        end
                    end
                end
            end
        end
    else
        if not silent then
            print('Process Ended. Nothing to export.')
        end
    end 
end
    
if #arg > 0 then
    if arg[1] == "-h" or arg[1] == "--help" then
        print([[
usage: blocks <operation> [...]
available operations:
    -h --help:                                              Displays this message.
    -e --export <File>:                                     Runs the 'Blocks Export Tool'.
    -se --silent_export <File>:                             Runs the 'Blocks Export Tool' and prevents the process lines from being printed
    -a --advanced_export <File>:                            Advacent mode. Lets you choose where every block is placed and the file extension for each individual block (Work in Progess).
    -u --update:                                            Updates Blocks to the latest version.
    -v --version:                                           Displays the current version.
    -r --run_block <Block_Name> <Commands_To_Run>:          Builds the specified block from cache (if available) and runs the block in the specified commands to run (ie. 'lua <Block_Name>, 'python3 <File_Name>, etc).
    -R --uninstall:                                         Uninstall Blocks and remove all saved blocks.]])
        os.exit()
    elseif arg[1] == "--update" or arg[1] == "-u" then
        local update_path = "https://github.com/Healing-A-Dev/Blocks"
        local config = updateConfig()
        print("=> Cloning git repository")
        os.execute('git clone --quiet '..update_path.." .blocks/.update && cd .blocks/.update && make -s Blocks_update")
        print("\027[93mCompleted\027[0m")
        print("\027[0m=> Updating new configuration file:")
        local file = io.open(".blocks/config.yaml","a")
        if #config > 0 then
            for _,i in pairs(config) do
                print("\027[90mCopied: '"..i:match("__%w+").."' configuration\027[0m")
                file:write(i.."\n")
                os.execute('sleep 0.2')
            end
            print("\027[93mCompleted\027[0m")
        else
            print("!Skipping. No configurations found!")
        end
        file:close()
        print("\027[1m**Update Completed**\027[0m")
        os.exit()
    elseif arg[1] == "-R" or arg[1] == "--uninstall" then
        io.write("Are you sure you want to uninstall Blocks? [Y/n]: ")
        local answer = io.read()
        if answer:lower() == "y" then
            local processes = {
                "cd /usr/local/bin",
                "rm -f blocks",
                "cd",
                "rm -rf .blocks",
                "rm -f blocks",
                "exit"
            }
            print("\027[1m**Uninstalling Blocks**\027[0m")
            for _,process in ipairs(processes) do
                if _ == 2 then
                    print("\027[96m=> Removing blocks from usr/local/bin\027[0m")
                elseif _ == 4 then
                    print("\027[96m=> Removing .blocks from /home/"..os.getenv("USER").."\027[0m")
                elseif _ == 5 then
                    print("\027[96m=> Removing blocks from /home/"..os.getenv("USER").."\027[0m")
                end
                os.execute(process.." && sleep 0.2")
            end
            print("\027[1m**Successfully Uninstalled Blocks**\027[0m")
            os.exit()
        else
            print("\027[1m**Uninstall Process Terminated**\027[0m")
            os.exit()
        end
    elseif arg[1] == "-e" or arg[1] == "--export" then
        table.remove(arg,1)
        files = table.concat(arg,",")
        cmdL = true
        export()
    elseif arg[1] == "-se" or arg[1] == "--silent_export" then
        table.remove(arg,1)
        files = table.concat(arg,",")
        silent = true
        cmdL = true
        export()
    elseif arg[1] == "-a" or arg[1] == "--advanced_export" then
        table.remove(arg,1)
        files = table.concat(arg,",")
        cmdL = true
        advanced_mode = true
        export()
    elseif arg[1] == "-v" or arg[1] == "--version" then
        getConfig()
        print("Version: \027[95m"..__VERSION.."\027[0m")
    elseif arg[1] == "-r" or arg[1] == "--run_block" then
        getConfig()
        loadCache(arg[2])
        for _,i in pairs(Blocks) do
            if type(i) == 'table' then
                holdBlocks[_] = i
                Blocks[_] = nil
            end
        end
        holdBlocks[arg[2]].run(arg[3])
    else
        print("blocks: command '"..arg[1].."' was not found")
    end
elseif #arg == 0 then
    getConfig()
    print([[Blocks:
    Version:]].."\027[95m"..__VERSION.."\027[0m"..[[

    Use 'blocks -h' or 'blocks --help' for help.
    
    "Why not make a file within a file?" - Healing]])
end
