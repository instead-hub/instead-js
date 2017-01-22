#!/bin/bash
DIST="dist"
TMPDIR="instead-js"
SRCDIR="build"
DESTDIR="$DIST/$TMPDIR"

rm -rf $DIST
mkdir $DIST
mkdir $DESTDIR
cp "$SRCDIR/index.html" $DESTDIR
cp "$SRCDIR/instead.js" $DESTDIR
cp "$SRCDIR/instead.png" $DESTDIR
cp "$SRCDIR/list_games.js" $DESTDIR
cp "$SRCDIR/styles.css" $DESTDIR
cp -r "$SRCDIR/themes" $DESTDIR

mkdir "$DESTDIR/games"
cp -r "instead/git/instead/games/tutorial3" "$DESTDIR/games"
(cd $DESTDIR && node list_games.js)
(cd $DIST && zip -qr instead-js.zip instead-js)
rm -rf $DESTDIR
