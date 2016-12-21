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
