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

Blocks.ShowAllBlocks() -- Displays all created blocks