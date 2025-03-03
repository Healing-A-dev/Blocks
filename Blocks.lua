Blocks = {}
local function partialBuild(name,file)
    Blocks[name] = {}
    Blocks[name].runFile = arg[1] or file
    Blocks[name].run = function()
        local runFileLines = {}
        local blockLines = {}
        os.execute("touch "..Blocks[name].runFile)
        local File = io.open(Blocks[name].runFile,"r")
        local lines = File:lines()
        for line in lines do
            runFileLines[#runFileLines+1] = line
        end
        File:close()
        for _,i in ipairs(Blocks[name]) do
            blockLines[#blockLines+1] = i
        end
        local File = io.open(Blocks[name].runFile,"w+")
        for _,i in ipairs(blockLines) do
            File:write(i.."\n")
        end
        File:close()
        dofile(Blocks[name].runFile)
        local File = io.open(Blocks[name].runFile,"w+")
        for _,i in ipairs(runFileLines) do
            File:write(i.."\n")
        end
        File:close()
        if Blocks[name].runFile:find("%.bfcache") then
            os.remove(Blocks[name].runFile)
        end
    end

    Blocks[name].build = function(ext,path)
        local path = path or ""
        local ext = ext or ".lua"
        if not ext:find("%.") and ext:find(".+") then
            path = ext
            ext = ".lua"
        elseif ext == "" then
            ext = ".lua"
        end
        if path ~= "" and not io.open(path) then
            path = path.."/"
            local toMake = ""
            for pathName in path:gmatch("%w+") do
                os.execute("mkdir "..toMake..pathName)
                toMake = toMake..pathName.."/"
            end
        end
        local toRun = {}
        for _,i in ipairs(Blocks[name]) do
            toRun[#toRun+1] = i
        end
        local BlockFile = io.open(path..name..ext,"w+")
        BlockFile:write("local "..name.." = {}\n\n"..table.concat(toRun,"\n").."\n\nreturn "..name)
        BlockFile:close()
        return path..name
    end

    Blocks[name].contents = function()
        print("Block: "..name.."\n")
        for _,i in ipairs(Blocks[name]) do
            print("    "..i)
        end
        print("____________________\nExtensions:")
        for _,i in pairs(Blocks[name]) do
            if type(i) == "table" then
                print("    ".._..":\t\t"..tostring(i))
            end
        end
        print("____________________\nFunctions:")
        for _,i in pairs(Blocks[name]) do
            if type(i) == "function" then
                print("    ".._.."\t\t"..tostring(i))
            end
        end
    end
    
    Blocks[name].clear = function()
        for _,i in ipairs(Blocks[name]) do
            table.remove(Blocks[name],_)
        end
    end
    
end

local function Build(file)
    local FileName = file
    local File = io.open(FileName,"r")
    local lines = File:lines()
    local filelines = {}
    local fileStore = {}
    local isBlock = false
    for line in lines do
        fileStore[#fileStore+1] = line
        if line:gsub("%s+",""):match("startBlock%s?.+") then
            isBlock = true
            blockName = line:gsub("startBlock",""):gsub("[%s+%:]","")
            Blocks[blockName] = {}
            line = ""
        elseif isBlock and line:gsub("%s+",""):match("endBlock") then
            isBlock = false
            line = ""
        end
        if isBlock then
            local line = line
            if #line:gsub("%s+","") > 0 then
                Blocks[blockName][#Blocks[blockName]+1] = line
                filelines[#filelines+1] = "--"..line..""
            end
        else
            if #line:gsub("%s+","") > 0 then
                local line = line
                local splitStr = {}
                for s = 1, #line do
                    splitStr[#splitStr+1] = line:sub(s,s)
                end
                if splitStr[line:len()] ~= "," and splitStr[line:len()] ~= "{" then
                    line = line..";"
                end
                filelines[#filelines+1] = line
            end
        end
    end
    File:close()

    -- ADDING UTILITY FUNCTIONS TO ALL BLOCKS IN THE BLOCK TABLE --
    for name,i in pairs(Blocks) do
        if type(i) == "table" then
            local Name = {}
            Name["Name*"] = name
            if name:match("%/%S+$") then
                Name["Name"] = name:match("%/%S+$"):gsub("%/","")
            else
                Name["Name"] = name
            end
            Name["Date"] = tostring(os.date("%B %d, %Y | %I:%M %p"))
            if Name["Name"] == nil then Name["Name"] = Name["Name*"] else Name["Name"] = Name["Name"]:gsub("%/","") end
            Blocks[name].run = function(run_commands)
                if holdBlocks ~= nil then Blocks = holdBlocks end
                local toRun = {}
                for _,i in ipairs(Blocks[name]) do
                    local splitStr = {}
                    for s = 1, #i do
                        splitStr[#splitStr+1] = i:sub(s,s)
                    end
                    if splitStr[i:len()] ~= "," and splitStr[i:len()] ~= "{" then
                        toRun[#toRun+1] = i..";"
                    else
                        toRun[#toRun+1] = i
                    end
                end
                local File = io.open(FileName,"w+")
                File:write(table.concat(toRun))
                File:close()
                if run_commands == nil then
                    dofile(FileName)
                else
                    os.execute(run_commands.." "..FileName)
                end
                local File = io.open(FileName,"w+")
                File:write(table.concat(fileStore,"\n"))
                File:close()
            end

            Blocks[name].build = function(ext,path)
                local path = path or ""
                local ext = ext or ".lua"
                if not ext:find("%.") and ext:find(".+") then
                    path = ext
                    ext = ".lua"
                elseif ext == "" then
                    ext = ".lua"
                end
                if path ~= "" and not io.open(path) then
                    path = path.."/"
                    local toMake = ""
                    for pathName in path:gmatch("[^%/]+") do
                        os.execute("mkdir '"..toMake..pathName.."'")
                        toMake = toMake..pathName.."/"
                    end
                end
                local toRun = {}
                if Blocks[name] ~= nil then
                    for _,i in ipairs(Blocks[name]) do
                        toRun[#toRun+1] = i
                    end
                else
                    for _,i in ipairs(holdBlocks[name]) do -- Edit this if you renameed the Blocks table
                        toRun[#toRun+1] = i
                    end
                end
                if name:find(".+/.+") and holdBlocks[name].__PATH__ == nil then
                    local name = name:gsub("%/[^%/]+$","")
                    os.execute("mkdir -p '"..path.."/"..name.."'")
                elseif holdBlocks[name].__PATH__ ~= nil then
                    name = holdBlocks[name].__NAME__
                end
                local BlockFile = io.open(path..name..ext,"w+")
                local Header,Footer = "local "..name.." = {}","return "..name
                if __HEADER ~= nil then
                    __HEADER = __HEADER:gsub("['\"]","")
                    if __HEADER:find(":.+$") then
                        local toReplace = __HEADER:match("%$%S+"):gsub("[%:%s+%$]","")
                        Header = __HEADER:gsub(":%s+%$%w+",Name[toReplace]):gsub("%*$",""):gsub("^%s+","")
                    else
                        Header = __HEADER
                    end
                end
                if __FOOTER ~= nil then
                    __FOOTER = __FOOTER:gsub("['\"]","")
                    if __FOOTER:find(":.+$") then 
                        local toReplace = __FOOTER:match("%$%S+"):gsub("[%:%s+%$]","")
                        Footer = __FOOTER:gsub(":%s+%$%w+",Name[toReplace]):gsub("%*$",""):gsub("^%s+","")
                    else
                        Footer = __FOOTER
                    end
                end
                Header = load('return "'..Header..'"')()
                Footer = load('return "'..Footer..'"')()
                BlockFile:write(Header.."\n\n"..table.concat(toRun,"\n").."\n\n"..Footer)
                BlockFile:close()
                return path..name
            end

            Blocks[name].contents = function(argument)
                local Blocks = holdBlocks
                local argument = argument or "*a"
                local blockLines = {}
                if argument == "*a" then
                    print("Block: "..name.."\n")
                    for _,i in ipairs(Blocks[name]) do
                        print("    "..i)
                        blockLines[#blockLines+1] = i
                    end
                    print("____________________\nExtensions:")
                    for _,i in pairs(Blocks[name]) do
                        if type(i) == "table" then
                            print("    ".._..":\t\t"..tostring(i))
                        end
                    end
                    print("____________________\nFunctions:")
                    for _,i in pairs(Blocks[name]) do
                        if type(i) == "function" then
                            print("    ".._.."\t\t"..tostring(i))
                        end
                    end
                    return blockLines
                elseif argument == "*l" then
                    for _,i in ipairs(Blocks[name]) do
                        blockLines[#blockLines+1] = i
                    end
                    return blockLines
                elseif argument == "*e" then
                    for _,i in pairs(Blocks[name]) do
                        if type(i) == "table" then
                            print("    ".._..":\t\t"..tostring(i))
                        end
                    end
                elseif argument == "*f" then
                    for _,i in pairs(Blocks[name]) do
                        if type(i) == "function" then
                            print("    ".._.."\t\t"..tostring(i))
                        end
                    end
                else
                    print("Block: "..name.."\n")
                    for _,i in ipairs(Blocks[name]) do
                        print("    "..i)
                        blockLines[#blockLines+1] = i
                    end
                    print("____________________\nExtensions:")
                    for _,i in pairs(Blocks[name]) do
                        if type(i) == "table" then
                            print("    ".._..":\t\t"..tostring(i))
                        end
                    end
                    print("____________________\nFunctions:")
                    for _,i in pairs(Blocks[name]) do
                        if type(i) == "function" then
                            print("    ".._.."\t\t"..tostring(i))
                        end
                    end
                    return blockLines
                end
            end

            Blocks[name].clear = function()
                for _,i in ipairs(Blocks[name]) do
                    table.remove(Blocks[name],_)
                end
            end

        end
    end
    return {
        Lines = filelines, 
        Run = function()
            local File = io.open(FileName,"w+")
            File:write(table.concat(filelines,"\n"))
            File:close()
            if FileName:find("%.lua$") then
                dofile(FileName)
            end
            local File = io.open(FileName,"w+")
            File:write(table.concat(fileStore,"\n"))
            File:close()
        end
    }
end

-- Block Utility Functions
function Blocks.NewBlock(BlockName,extension,runFile,skip_nil_blocks)
    partialBuild(BlockName,runFile)
    -- ADDING BLOCK EXTENSIONS --
    for ext in extension.extensions:gmatch("%S+") do
        if ext == ".VOID" and extension.extensions:gsub("%s+","") == ".VOID" then
            return
        elseif Blocks[ext] == nil and not skip_nil_blocks then
            error("Blocks <Error>"..arg[0]..": Block '"..ext.."' does not exsit")
        else
            Blocks[BlockName][ext] = Blocks[ext]
        end
    end
end

function Blocks.WriteToBlock(BlockName, Data_To_Write)
    local function removeEnd(str)
        local split = {}
        local str = str:gsub("^\n","")
        for s=1, #str do
            split[#split+1] = str:sub(s,s)
        end
        return table.concat(split)
    end
    for line in Data_To_Write:gmatch(".+") do
        Blocks[BlockName][#Blocks[BlockName]+1] = removeEnd(line)
    end
end

function Blocks.ShowAllBlocks(command)
    local madeBlocks = {}
    if command ~= "-s" then
        for _,i in pairs(Blocks) do
            if type(i) == "table" then
                print("Block: ".._)
            end
        end
    else
        for _,i in pairs(Blocks) do
            if type(i) == "table" and madeBlocks[_] == nil then
                madeBlocks[_] = i
            end
        end
        return madeBlocks
    end
end

function Blocks.BuildFromFile(file,ext,isCommandLine)
    local ext = ext or ".lua"
    local toBuild = ""
    if arg[1] == nil and file == nil then
        print("Blocks <Error>: "..arg[0]..": No file specified")
        os.exit()
    end
    if file ~= nil and file:find("%..+") then ext = "" end
    if arg[1] == nil or arg[1] == "-e" or isCommandLine then toBuild = file..ext else toBuild = arg[1] end
    local Blocks = Build(toBuild)
    Blocks.Run()
    return {Lines = Blocks.Lines}
end

return Blocks
