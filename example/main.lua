require("Blocks") -- Import Blocks
Blocks.BuildFromFile("example/Test.lua") --Builds the blocks to be used

-- UNCOMMENT THE LINES THAT YOU WANT TO TRY OUT BY REMOVING "--" --

-- Blocks.Locales.run() -- Runs the Locales block
-- Blocks.Locales.build() -- Builds the Locales block
-- Blocks.Locales.contents() -- Shows the contents of the Locales block
-- Language = getLocale() -- Function will be created after the Locales block is run due to it being a global function
-- print(Language) -- Prints selected language from the getLocale function

-- Blocks.EncodeString.run() -- Runs the EncodeString block
-- Blocks.EncodeString.build() -- Builds the EncodeString block
-- Blocks.EncodeString.contents() -- Shows the contents of the EncodeString block
-- print(toEncode("Hello World")) -- Prints the encoded string using the function created by the EncodeString block

-- Blocks.__GAME.run() -- Runs the __GAME block
-- Blocks.__GAME.build() -- Builds the __GAME block
-- Blocks.__GAME.contents() -- Shows the contents of the __GAME block
-- Blocks.__GAME.Welcome() -- Runs the Welcome function from the __GAME block


-- Usage of the Blocks.NewBlock Function
Blocks.NewBlock("MegaBlock", {extensions = "__GAME Locales EncodeString WontWork"}, "example/Test", true)

--[[    THIS IS A BREAK DOWN OF THE "Blocks.NewBlock" FUNCTION:
    
    The first argument "MegaBlock" is going to be the name of the new EMPTY block that will be created

    The second argument "{extensions = "__GAME Locales EncodeString WontWork"} will attempt to add each block into the newly created block "MegaBlock" and will error if a block does not exist unless the 4th arugment* is set to true (IF YOU DO NOT WANT TO ADD EXTENSIONS, SET EXTENSIONS EQUAL TO ".VOID")

    The third arguemnt "example/Test.lua" is the file in which the block will run in whenever the run function (in this case "Blocks.MegaBlock.run()") is called. If there is no file extesion found in the file name, it will create a .bkf file (Which will be removed after execution) to run safely without ruining that file.

    The forth arguemnt will determine whether or not nil blocks will error when trying to add them as extensions
]]

Blocks.WriteToBlock("MegaBlock",[[ 
    print("Hello, World!") 
]]) -- Writes 'print("Hello, World!")' to the MegaBlock block. (Also yes, this function works. So calm down.)

-- Blocks.MegaBlock.run() -- Runs the MegaBlock block
-- Blocks.MegaBlock.build() -- Runs the MegaBlock block
-- Blocks.MegaBlock.contents() -- Shows the contents of the MegaBlock block

-- Blocks.MegaBlock.Locales.run() -- Runs the Locales extension block
-- Blocks.MegaBlock.__GAME.rund() -- Runs the __GAME extension block
-- Blocks.MegaBlock.EncodeString.run() -- Runs the EncodeString extension block

Blocks.ShowAllBlocks() -- Displays all created blocks