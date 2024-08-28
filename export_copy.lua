dofile('./.blocks/Blocks.lua')
local Blocks = Blocks
local exported = {}
local cmdL,silent = false,false
local filext = ""
local files
holdBlocks = {} -- Will hold the Blocks instead of the Blocks table

if #arg > 0 then
    if arg[1] == "-h" or arg[1] == "--help" then
        print([[
    -h --help: Displays this message.
           
    -s --silent: Prevents lines from being printed (NOTE: YOU WILL STILL BE ASKED FOR A FILE EXTENSION (IF MISSING) AND A PATH FOR THE OUTPUT FILES).
           
    -a --adv: Advacent mode. Lets you choose where every block is placed and the file extension for each individual block.

    -u --update: Updates Blocks to the latest version.]])
        os.exit()
    elseif arg[1] == "-s" or arg[1] == "--silent" then
        silent = true
        table.remove(arg,1)
    elseif arg[1] == "--update" or arg[1] == "-u"then
        local update_path = "https://github.com/Healing-A-Dev/Blocks"
        print("\027[1m**Starting Update**\027[0m")
        os.execute('git clone '..update_path.." && rm -r .blocks && cd Blocks && make install")
        print("\027[1m**Update Completed**\027[0m")
        os.exit()
    end
    files = table.concat(arg,",")
    cmdL = true
else
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
            print('\n\027[92mGenerating Blocks from file \''..file..'\':\027[0m')
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
    if not silent then
        print('\n\nSuccessfully generated all blocks from \''..table.concat(exported,'\' and \'')..'\'')
    end
    os.execute('sleep 2')
    for _,i in pairs(exported) do
        if type(i) == 'table' then
            if type(_) == "string" and not _:find("%..+$") then
                io.write('\n\027[93m[No File Extension(s) Found]\027[0m Insert a file extension to assign to blocks:\n'.._..'>')
                filext = io.read()
            else
                filext = ""
            end
            _ = _..filext
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
