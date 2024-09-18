dofile('./.blocks/Blocks.lua')
--[[
CONST_NAME = .blocks
INSTALL_PATH = /usr/local/bin
MVDIR = /home/$(USER)/$(CONST_NAME)
]]
local Blocks = Blocks
local exported = {}
local cmdL,silent = false,false
local filext = ""
local files
holdBlocks = {} -- Will hold the Blocks instead of the Blocks table


local function getConfig()
    local file = io.open(".blocks/config.yaml","r")
    if file == nil then
        error("NO CONFIG FILE")
    end
    local lines = file:lines()
    local config = {}
    local currentLine = 1
    for line in lines do
        if currentLine > 1 and #line:gsub("%s+","") > 0 then
            line = line:gsub("^%s+",""):gsub("%s+$","")
            local var,value = line:match("(.+):%s?(.+)")
            _G[var] = value
        end
        currentLine = currentLine + 1
    end
end


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
                os.execute('sleep 0.02')
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
                if type(_) == "string" and not _:find("%..+$") then
                    io.write('\n\027[93m[No File Extension(s) Found]\027[0m Insert a file extension to assign to blocks:\n'.._..'>')
                    filext = io.read()
                else
                    filext = ""
                end
                _ = __DEFAULT_EXT or _..filext
                io.write('\nInsert path to export to (default path = /'.._:gsub('%..+$','')..'):\n> ')
                local path = io.read()
                if path == '' then path = _:gsub('%..+$','') end
                for s,t in pairs(i) do
                    os.execute('sleep 0.02')
                    holdBlocks[t].build(_:match('%..+$'),path..'/')
                    if not _:match('%..+') and not silent then
                        print('\027[93m\tSuccessfully exported block \''..t..'\' to '..path..'/'..t.._..'\027[0m')
                    elseif not silent then
                        print('\027[93m\tSuccessfully exported block \''..t..'\' to '..path..'/'..t.._:match('%..+')..'\027[0m')
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
    -h --help: Displays this message.
    
    -e --export: Runs the 'Blocks Export Tool'.
           
    -se --silent_silent_export: Prevents lines from being printed (NOTE: YOU WILL STILL BE ASKED FOR A FILE EXTENSION (IF MISSING) AND A PATH FOR THE OUTPUT FILES).
           
    -a --adv: Advacent mode. Lets you choose where every block is placed and the file extension for each individual block.

    -u --update: Updates Blocks to the latest version.
            
    -R --uninstall: Uninstall Blocks and remove all saved blocks.]])
        os.exit()
    elseif arg[1] == "--update" or arg[1] == "-u" then
        local update_path = "https://github.com/Healing-A-Dev/Blocks"
        print("\027[1m**Starting Update**\027[0m")
        os.execute('git clone '..update_path.." && rm -r .blocks && cd Blocks && make install")
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
    end
elseif #arg == 0 then
    getConfig()
    print([[Blocks:
    Version:]].."\027[95m "..__VERSION.."\027[0m"..[[

    Use 'blocks -h' or 'blocks --help' for help.
    
    "Why not make a file within a file?" - Healing]])
end
