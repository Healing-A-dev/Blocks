Blocks = {}
local function Build(file,ext)
    local ext = ext or ".lua"
    if file ~= nil and file:find("%..+") then ext = "" end
    FileName = file..ext
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
                if splitStr[line:len()] ~= "," and splitStr[line:len()] ~= "{"then
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

            Blocks[name].run = function()
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
                dofile(FileName)
                local File = io.open(FileName,"w+")
                File:write(table.concat(fileStore,"\n"))
                File:close()
            end

            Blocks[name].build = function(path)
                local path = path or ""
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
                local BlockFile = io.open(path..name..".lua","w+")
                BlockFile:write("local "..name.." = {}\n\n"..table.concat(toRun,"\n").."\n\nreturn "..name)
                BlockFile:close()
                return path..name
            end

            Blocks[name].contents = function()
                for _,i in ipairs(Blocks[name]) do
                    print(i)
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
            dofile(FileName)
            local File = io.open(FileName,"w+")
            File:write(table.concat(fileStore,"\n"))
            File:close()
        end
    }
end

-- Smaller/General Utility Functions
function Blocks.ShowAllBlocks()
    for _,i in pairs(Blocks) do
        if type(i) == "table" then
            print("Block: ".._)
        end
    end
end

function Blocks.BuildFromFile(file,ext)
    local ext = ext or ".lua"
    if arg[1] == nil and file == nil then
        print("Blocks <Error>: "..arg[0]..": No file specified")
        os.exit()
    end
    if file ~= nil and file:find("%..+") then ext = "" end
    if arg[1] == nil then arg[1] = file..ext end
    local Blocks = Build(arg[1])
    Blocks.Run()
    return {Lines = Blocks.Lines}
end