#!/bin/bash
rm -r /home/ss13/nostration/code
rm -r /home/ss13/nostration/interface
rm -r /home/ss13/nostration/icons
rm -r /home/ss13/nostration/modular_citadel
rm -r /home/ss13/nostration/tgui
rm -r /home/ss13/nostration/html
rm -r /home/ss13/nostration/_maps
rm    /home/ss13/nostration/tgstation.dme

cp -r /home/git/ss13-nostration/code            /home/ss13/nostration/
cp -r /home/git/ss13-nostration/interface       /home/ss13/nostration/
cp -r /home/git/ss13-nostration/icons           /home/ss13/nostration/
cp -r /home/git/ss13-nostration/modular_citadel /home/ss13/nostration/
cp -r /home/git/ss13-nostration/tgui            /home/ss13/nostration/
cp -r /home/git/ss13-nostration/html            /home/ss13/nostration/
cp -r /home/git/ss13-nostration/_maps           /home/ss13/nostration/
cp    /home/git/ss13-nostration/tgstation.dme   /home/ss13/nostration/
