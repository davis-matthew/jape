#!/bin/bash
# claims to be, in bash, the way to find source directory.
# from https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel/60157372#60157372
full_path_to_script="$(realpath "$0")"
launchdir="$(dirname "$full_path_to_script")"
appdir="$HOME/.local/share/Jape.app"
echo $appdir
rm -fr $appdir; mkdir $appdir
cd $launchdir
cp -pR jape_engine jre launchstub iconset Pics $appdir
cp -pR examples $USER_PWD
rm -f $USER_PWD/Jape; ln -s $appdir/launchstub $USER_PWD/Jape
cat <<ENDSCRIPT>Jape.desktop
[Desktop Entry]
Version=1.0
Name=Jape
Comment=Jape proof editor for Linux
Exec=$appdir/launchstub
Icon=$appdir/Pics/japeicon.png
Terminal=false
Type=Application
Categories=Development
StartupWMClass=uk-org-jape-Jape
ENDSCRIPT
cp Jape.desktop ~/.local/share/applications/Jape.desktop

