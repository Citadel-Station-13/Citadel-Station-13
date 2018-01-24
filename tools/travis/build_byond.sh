#!/bin/bash

#nb: must be bash to support shopt globstar
set -e
shopt -s globstar

if [ "$BUILD_TOOLS" = false ]; then
	if grep '"aaa" = \(.+\)' _maps/**/*.dmm;	then
    	echo "Non-TGM formatted map detected. Please convert it using Map Merger!"
    	exit 1
	fi;
	if grep 'step_[xy]' _maps/**/*.dmm;	then
    	echo "step_[xy] variables detected in maps, please remove them."
    	exit 1
	fi;
	if grep 'pixel_[xy] = 0' _maps/**/*.dmm;	then
    	echo "pixel_[xy] = 0 detected in maps, please review to ensure they are not dirty varedits."
	fi;
	if grep '\td[1-2] =' _maps/**/*.dmm;	then
    	echo "d[1-2] cable variables detected in maps, please remove them."
    	exit 1
	fi;
	if grep '^/area/.+[\{]' _maps/**/*.dmm;	then
    	echo "Vareditted /area path use detected in maps, please replace with proper paths."
    	exit 1
	fi;
	if grep '\W\/turf\s*[,\){]' _maps/**/*.dmm; then
    	echo "base /turf path use detected in maps, please replace with proper paths."
    	exit 1
	fi;
	if grep '^/*var/' code/**/*.dm; then
		echo "Unmanaged global var use detected in code, please use the helpers."
		grep '^var/' code/*.dm | echo
		exit 1
	fi;

	#config folder should not be mandatory
	rm -rf config/*
	
	#disable all ruins
	echo -e "LAVALAND_BUDGET 0\nSPACE_BUDGET 0" > config/config.txt

    source $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/byondsetup
	if [ "$BUILD_TESTING" = true ]; then
		tools/travis/dm.sh -DTRAVISBUILDING -DTRAVISTESTING -DALL_MAPS tgstation.dme
	else
		tools/travis/dm.sh -DTRAVISBUILDING tgstation.dme
	fi;
fi;
