Quest_Name = "Fleeting Dreams"
Player_Name = "Player"
Player_Age = 3947

startBlock Locales:
    local locales = {
        en = "English",
        fr = "French",
        es = "Spanish",
        gr = "German",
        jp = "Japanese",
        ru = "Russian"
    }
    function getLocale()
        os.execute('clear')
        ::restart::
        local s = 0
        for _,i in pairs(locales) do
            s = s + 1
            print(tostring(s)..". ".._.." ("..i..")")
        end
        io.write("\n\n\nEnter the language shorthand: ")
        local language = io.read()
        if locales[language] == nil then
            os.execute('clear')
            print("Invalid Option")
            os.execute('sleep 1 && clear')
            goto restart
        end
        os.execute('clear')
        return locales[language]
    end
endBlock

startBlock EncodeString:

    function toEncode(words)
        local splitStr = {}
        local outstring = {}
        for s = 1, #words do
            splitStr[#splitStr+1] = words:sub(s,s):byte()
        end
        for _,i in pairs(splitStr) do
            outstring[#outstring+1] = string.char(i+32)
        end
        return table.concat(outstring)
    end

endBlock

startBlock __GAME:
    Game = {}
    Game.Start = function()
        os.execute('clear')
        print("WORKING ON ITTTTT")
    end
    Game.Welcome = function()
        print("Welcome "..Player_Name..", we have been waiting for you...\n\n\nConsole: Press 'Enter' To Continue")
        io.read()
        os.execute('sleep 2 && clear')
        print("<-----------|"..Quest_Name.."|----------->\n\n\nConsole: Enemy Levels Are Equal To Player Age In This Region. | Age: "..Player_Age.." |")
        os.execute('sleep 2')
        print("\n\n\nConsole: Press 'Enter' To Start")
        io.read()
        Game.Start()
    end
endBlock