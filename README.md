# The Colosseum - Work In Progress!

This hobby project is meant as a competitive multiplayer arena game. This game is a 'mod', or 'map', for Warcraft 3, a popular strategy game published by Blizzard Entertainment in 2002.

TODO: add link to hiveworkshop map url

Most of this project's code is written in Lua. Warcraft 3 extended it's API in version 1.31 to support lua. This game will only work on version 1.31 and later.

## How to run the game

This game was built using Warcraft 3's map editor tool. This tool is provided to you by Blizzard upon installation of Warcraft 3.

You can not run any of the code in this project by itself. You need to install Warcraft 3. On top of that, the only file in this project that actually matters is "The Colosseum \[version\].w3x". You can open and run the w3x file in the editor. You can also host The Colosseum through Warcraft 3's multiplayer support. All other files in this repository are only placed here to take advantage of version control. These w3x files are also known as "custom games" or "maps".

## Way of working

Overall, creating Warcraft 3 map is quite a tedious process. There is limited support for editing, testing and debugging code in the map editor. Which is why some external tools may be useful. There are a bunch of tools out there to improve the development process of a Warcraft 3 map, but I have opted to only use the map editor tool, and VS Code with some code snippets.

TODO: add links and code snippets.

To add the lua snippets in vscode go to: File -> Preferences -> Configure Snippets and search for lua. Then, copy the contents of tools/lua-snippets.json into the opened lua snippets file and save it.

### Coding
Code written for the project is stored in files to take advantage of VS Code features and git version control, but eventualy have to be copied from the files to the trigger editor in the Warcraft map editor. The folder structure in the map editor is similar to the folder structure in the repository.

Note that some of the logic of the game was created using the traditional GUI editor in Warcraft 3's map editor. This achieves the same goal, but the GUI triggers have many limitations, and or more tedious to work with compared to text-based coding laguages like lua. Although, there learning curve for lua is quite a bit steeper compared to the GUI triggers if you dont have much coding experience. When this project started, a bit of both was used, but eventualy I opted to prefer to write game logic in lua if possible.

### Triggers
Code written for the project will be executed by Warcraft 3 through triggers. Triggers are objects which during the game listen to events. If a corresponding event occurs, the trigger's conditions will be checked. If the conditions are met, the trigger's actions (functions) will be executed.

### InitLua & RegInit
There is an InitLua() function. This function must be called from a GUI trigger, or else any triggers made through lua code will not persist during the game.

To create a trigger through lua code, you need to call RegInit(...) like so:

``` lua
TriggerName = nil

RegInit(function()
    TriggerName = CreateTrigger()
    -- Add trigger conditions and actions here
end)
```

The RegInit function will register the function reference to be called by the InitLua() function.

### Hard-coded object references
Object's created in the map editor are appointed unique id's. In order for the triggers to work, they needs to reference these unique id's.

If you were to copy the code from one map to another, it will not work correctly, and there will be many side effects. You will have to change the id's in the code to reference new corresponding objects in the other map.