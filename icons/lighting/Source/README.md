# Europalighting shadow rendering scene

This is a very simple recreation of the scene used to render Europalight's shadows. It was created by Bhijn for the Europalighting port on Citadel. This file should make it a lot easier to expand the lighting system's lighting range limits. It was created in Blender 2.80 beta.

## License

its literally just a fucking plane, a pillar, an orthographic camera, an empty node, and a point light. How in the actual fuck do you license it. Do whatever the fuck you want with it, I don't give a shit.

## How 2 use???

Aight so first install Blender from https://www.blender.org/ and make sure you download the Blender 2.80 Beta (alternatively, if you're from the future, go with whatever's the latest!)

Once you've got that installed, just open the .blend file in this directory in Blender.
All you have to do to render a shadow is use the "Render Image" option. By default, the hotkey for this is F12. After that, just wait for it to finish rendering, then hit Shift+S on the window that popped up to save it.

To render a shadow at a different distance from the light source, simply move the "Master" object. For unmodified Europalights, you should be moving the "Master" object in 1 meter steps, but if you've made modifications to the system then use your own judgement.

If for whatever reason you need to render a shadow from a distance larger than 14 SS13 tiles away, simply scale both the orthographic camera and plane up to match the desired distance.

Once you have your massive collection of shadow images, all you have to do is crop it down to your desired size. If you're rendering shadows for a shadow1 DMI, then be sure to nudge the image one pixel down and one pixel to the left, otherwise the sprite will look a little off. The proper dimensions are:
- light_range_SCALE_shadow1.dmi:  (SCALE+0.5)\*32 x (SCALE+0.5)\*32
- light_range_SCALE_shadow2.dmi: (SCALE*2+1)\*32 x (SCALE+0.5)\*32

Yes. There is no process to automate this, or at least there isn't yet. Have fun, repo-snooping spaceman.