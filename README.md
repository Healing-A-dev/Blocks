# BLOCKS

## Intro

Blocks is a program written in lua that will allow you to create "files" within a file. No more having to search through tons of folders and files to find which file you were trying to import 30 minutes ago. With Blocks, there is no longer a need to hunt for files. Just make one file and have Blocks do the rest!

## How To Use Blocks:
To use Blocks, first import Blocks into your main file.

```lua
require("Blocks")
-- This is ONLY if you plan on using Blocks in another lua file/project. However, there are future plans to make this compatable with other languages (Or if you know what you're doing, you can get it to work).

```
After you've imported Blocks, run the Blocks.BuildFromFile(<INSERT_FILE_NAME>) to build the blocks for usage:
```lua
require("Blocks")

-- In thses examples, we'll be using the file "Test.lua" as our file.

Blocks.BuildFromFile("Test.lua")
-- NOTE: you can also call this in two different ways.

Blocks.BuildFromFile("Test",".lua")

-- Or from the command line using (you will need to have Lua installed):

lua <FILE_NAME_WITH_EXTENSION> <FILE_TO_BUILD>

-- The BuildFromFile function also returns the modified contents of the file as a table or array, which can be called by adding the .Lines argument to the BuildFromFile function.

File_Lines = Blocks.BuildFromFile("Test.lua").Lines -- Array of lines
```
Now, if you were just copying and pasting, you'll notice that it doesn't work. And that is because you havent made any blocks. To create a block, use the startBlock keyword followed by the name of your block. Inside the block, you can do whatever as long as its written in Lua (for now). When you've finished your block, use the endBlock keyword to close it. 

### Below is and example of what a block should look like:
```lua
-- This is what a block should look like.

startBlock TestBlock:
    print("This is a test block")
endBlock
```

Now that you've created a block, it's time to use that block! Now, to run the block, you would simply run the following function.

```lua
Blocks.<BLOCK_NAME>.run()

-- NOTE: You can call this function in ANY (Lua) file after the initial Blocks.BuildFromFile() function has been run.
```

As mentioned above, blocks can be used from any (Lua) file after they've been built. You can call is several ways:

### Normal File (aka Any (Lua) File):
```lua
require("Blocks") -- Import Blocks

Blocks.BuildFromFile("Test.lua")

Blocks.TestBlock.run() -- Run the block we created in the Test.lua File, which will print "This is a test block".
```
### Test.lua File:
```lua
-- This is what a block should look like.

startBlock TestBlock:
    print("This is a test block")
endBlock

Blocks.TestBlock.run() -- This will run the block as well, even though it's in the same file as the block.
```
### You can even run blocks fomr inside other blocks:
```lua
startBlock Block1:
    print("Running Block 1")
endBlock

startBlock Block2:
    print("Running Block 2")
    Blocks.Block1.run() -- Prints "Running Block 1"
endBlock
```
---
And that's the basic use of using Blocks...HOWEVER, there is more (but simple) utility. Not only to Blocks as a whole, but to each indivdual blocks as well.

```lua
Blocks.<BLOCK_NAME>.contents() -- Shows the contents of the block.

Blocks.ShowAllBlocks() -- Displays all created blocks

Blocks.<BLOCK_NAME>.build(<OPTIONAL_EXTENSION>,<OPTIONAL_EXPORT_PATH>) -- Will create a file named after the block's name, export said block into that file, and return the name of that file
```

### Usuage cases of the .build function:
This following is for those of you who for some reason still want to create a block file even though the point of Blocks is to eliminate extra files... 

```lua
Blocks.TestBlock.build() -- Creates a TestBlock.lua file (default) and exports

Blocks.TestBlock.build(".txt") -- Creates a TestBlock.txt file and exports

Blocks.TestBlock.build("Files/Blocks") -- Creates a Files folder -> Creates a Blocks folder -> Creates a TestBlock.lua file and exports

Blocks.TestBlock.build(".txt","Files/Blocks") -- Creates a Files folder -> Creates a Blocks folder -> Creates a TestBlock.txt file and exports

File_Name = Blocks.TestBlock.build(<OPTIONAL_EXTENSION>,<OPTIONAL_EXPORT_PATH>) -- Stores the full name of the created file including the path (if specified).
```
You can even import expoted block files:
```lua
File_Name = Blocks.TestBlock.build(<OPTIONAL_EXTENSION>,<OPTIONAL_EXPORT_PATH>) -- Stores file name
require(File_Name) -- Imports the file
```
or
```lua
require(Blocks.TestBlock.build(<OPTIONAL_EXTENSION>,<OPTIONAL_EXPORT_PATH>))
```
### PLEASE DO NOT TRY AND IMPORT OR EXECUTE A FILE CONTAINING BLOCKS! IT IS NOT GOING TO WORK!
```lua
require("Test")
dofile("Test.lua")
lua Test.lua -- Command Line Prompt

-- DO NOT RUN OR IMPORT ANY FILE CONTANING BLOCKS IN ANY OF THE WAYS LISTED ABOVE!!! (aka. AT ALL!!!)

-- IT WILL NOT WORK BECAUSE OF THE SYNTAXING FOR BLOCKS. AND PLUS, THE FILE IS RAN AUTOMATICALLY WHEN YOU BUILD THE BLOCKS FROM THAT FILE ANYWAY. SO THERE IS NO NEED OR REASON TO IMPORT IT OR RUN IT INDEPENDENTLY.
```

## EXTRA INFOMATION:
Every block is esentially its own file. Meaning that any local variables or functions declared in a block will stay in that block. You can still use outside variables in your block, modify global variables, and create global variables as well. Just like a normal file.

While yes, for a block to run it does modify the file in which the blocks are in. HOWEVER, the file is restored to its original state after the block is ran. (Unless something went wrong, in which you will have to manually restor the file to its original state.)

Welp, that's it. Have fun using Blocks!
## Credits:
ME, MYSELF, and I.