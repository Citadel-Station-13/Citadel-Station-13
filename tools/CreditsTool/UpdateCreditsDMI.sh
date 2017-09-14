#!/bin/bash

#If you hit github's rate limit, add a 3rd parameter here that is a github personal access token
./program Citadel-Station-13 Citadel-Station-13

rm ../../icons/credits.dmi

for filename in credit_pngs/*.png; do
	realname=$(basename "$filename")
	java -jar ../dmitool/dmitool.jar import ../../icons/credits.dmi "${realname%.*}" "$filename"
done

rm -rf credit_pngs
read -n 1 -p "Input Selection:" mainmenuinput