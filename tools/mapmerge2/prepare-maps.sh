#!/bin/bash
cd ../../_maps
find -name *.dmm -exec cp -v \{\} \{\}.backup \;
