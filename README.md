# instead-js
INSTEAD (http://instead.syscall.ru/) is the Simple Text Adventure Interpreter. 
The main application is written in C, the game engine and games themselves are written in Lua.

This is an attempt to recreate functionality of INSTEAD in the web application.

## Installation

Prerequisites: nodejs 6.3+, npm 3.10+

    git clone https://github.com/technix/instead-js.git
    cd instead-js
    git submodule init
    git submodule update
    npm install

## Preparing to build

This GIT repository already includes prebuilt LuaJS (lua.vm.js) and INSTEAD Lua core files (stead_lua.json). If you need to update them,
please run the following command:

    npm run prepare
    
This should be made only once.

## Building app

To build INSTEAD-JS, run the following command:

    npm run build
    
The application will be created in `build` folder.

## Adding games

Create `games` folder inside of `build` folder. Put all required games to that folder, then run the following command from the `build` folder:

    node list_games.js

Congratulations, you did it! Now you can put contents of `build` folder to the web server.

## Features

- [x] Images
    - [x] Blank images
    - [x] Composite image
    - [x] Sprites
    - [x] Sprites - fonts (partial support)
    - [ ] Sprites - scale, rotate
- [x] Themes
    - [x] Standard and user-defined themes
    - [x] Changing theme on-the-fly (module 'theme')
    - [x] win.scroll.mode
    - [ ] src.gfx.mode = 'float'
    - [x] Theme fonts and font sizes
- [x] Music and sounds
    - [x] Play music and sound
    - [x] Loop music
    - [ ] Sounds on multiple channels
- [x] Save/load game
    - [x] use LocalStorage to save game
    - [x] multiple save slots
    - [x] autosave
    - [ ] clean save slots
- [x] Game manager
    - [x] Choose game to load
    - [x] Separate save slots for different games
    - [x] Preload images before running game
- [x] Keyboard input
- [x] Timer
- [x] Mouse input
- [x] Metaparser
    - [x] Dictionary loading
- [ ] URQ module (?)
    - [x] Quest file loading
    - [ ] Bug: encoding issues
    - [ ] Bug: command parsing issues
