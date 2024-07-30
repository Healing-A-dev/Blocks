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
        io.write("\n\n\nEnter the or language code: ")
        local language = io.read()
        if locales[language] == nil then
            os.execute('clear')
            print("Invalid Option")
            os.execute('sleep 3 && clear')
            goto restart
        end
        return locales[language]
    end
endBlock

startBlock EncodeLocale:

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

toEncode()