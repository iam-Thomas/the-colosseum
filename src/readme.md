## Source code

This directory contains the source code for the map. I store the code here in lua files, but ultemately, the code needs to be copied to the code blocks, in the trigger editor, in the world editor.

Note that this is not all of the game's logic. Some triggers were created using the traditional GUI trigger editor.

## Hard coded object references

Note that there are many hard coded object Id reference in the code. These references are map-specific. An object id can be retrieved by navigating to the desired object in the object editor, and pressing Ctrl-D to change the view. The changed view now shows ids where it used to show object names.

## ORDER MATTERS!

In the file system, or vscode explorer, files and directories are sorted alphabetically. Which is nice, but this does not reflect how the code should be placed in the trigger editor. The order in which the triggers are registered matters. If an event occurs which would trigger 2 triggers, the triggers are executed in the same order in which they were initially registered. One's result might affect the other.