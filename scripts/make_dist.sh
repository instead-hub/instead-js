#!/bin/bash
DIST="dist"
TMPDIR="instead-js"
SRCDIR="build"
DESTDIR="$DIST/$TMPDIR"

rm -rf $DIST
mkdir $DIST
mkdir $DESTDIR
cp $SRCDIR/*.html $DESTDIR
cp $SRCDIR/*.js $DESTDIR
cp $SRCDIR/*.json $DESTDIR
cp $SRCDIR/*.css $DESTDIR
cp $SRCDIR/*.png $DESTDIR
cp -r $SRCDIR/themes $DESTDIR

mkdir $DESTDIR/games
cp -r instead/git/instead/games/tutorial3 $DESTDIR/games
(cd $DESTDIR && node list_games.js)
(cd $DIST && zip -qr instead-js.zip instead-js)
rm -rf $DESTDIR
