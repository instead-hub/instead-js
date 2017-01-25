# Installation

Prerequisites: nodejs 6.3+, npm 3.10+

    git clone https://github.com/instead-hub/instead-js.git
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
