/*
⢀⡴⠑⡄⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠸⡇⠀⠿⡀⠀⠀⠀⣀⡴⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠑⢄⣠⠾⠁⣀⣄⡈⠙⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⡀⠁⠀⠀⠈⠙⠛⠂⠈⣿⣿⣿⣿⣿⠿⡿⢿⣆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⡾⣁⣀⠀⠴⠂⠙⣗⡀⠀⢻⣿⣿⠭⢤⣴⣦⣤⣹⠀⠀⠀⢀⢴⣶⣆
⠀⠀⢀⣾⣿⣿⣿⣷⣮⣽⣾⣿⣥⣴⣿⣿⡿⢂⠔⢚⡿⢿⣿⣦⣴⣾⠁⠸⣼⡿
⠀⢀⡞⠁⠙⠻⠿⠟⠉⠀⠛⢹⣿⣿⣿⣿⣿⣌⢤⣼⣿⣾⣿⡟⠉⠀⠀⠀⠀⠀
⠀⣾⣷⣶⠇⠀⠀⣤⣄⣀⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 		WARNING: THE SHITCODE BELOW HAS BEEN HASTILY
⠀⠉⠈⠉⠀⠀⢦⡈⢻⣿⣿⣿⣶⣶⣶⣶⣤⣽⡹⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 		COPY AND PASTED, PORTED FROM AWKWARD PLACES, AND PROBABLY MADE WORSE.
⠀⠀⠀⠀⠀⠀⠀⠉⠲⣽⡻⢿⣿⣿⣿⣿⣿⣿⣷⣜⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣶⣮⣭⣽⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀ WELCOME TO JT's TG-CODE HALLOWEEN BALL CODEFILE.
⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀ 					ALL OF IT WILL HOPEFULLY BE BELOW.
⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⠿⠿⠛⠉
*/
//Also Shrek will crash your dmlang server repeatedly if you edit him.

//Considering I can't grab defines from everywhere, I hope you enjoy strings and numbers plebs.
//Update - Moved to modular citadel so we are after everything has loaded...probably we gucci - jtgsz

/*
	AREAS
			*/
//We are on ruin so I can inherit things from the parent elsewhere.
/area/eventmap
	name = "Dont use this" //Its the parent to any dunces out there.
	has_gravity = STANDARD_GRAVITY //We have gravity
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/areas.dmi' //It unsets the icon.
	requires_power = 1 // We don't need power anywhere.			//That means you get a error icon if its in blank.
	flags_1 = NONE

/area/eventmap/outside //We are outside
	name = "Outside"
	icon_state = "outside"
	outdoors = 1 //Outdoors is true, no area editing here.
	lightswitch = 0 //Lightswitch is false, no turning the lights on outside.
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/eventmap/inside //We are inside, all things are pretty normal.
	name = "Inside"
	icon_state = "inside"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/eventmap/mountain //Mostly so I can see the area lines of the mountain area in the minimap.
	name = "Mountain"
	icon_state = "mountain"
	outdoors = 1
	lightswitch = 0
/*
	OUTSIDE WALLS I WANT NOT NEED
										*/
//These exist mostly to limit the amount of space we use organically really.
//Decided to just use the denserock within the regular code.

/turf/closed/indestructible/spookytime/matrixblocker //Two times the reference power.
	name = "matrix"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "matrix"
	desc = "<font color='#157206'>You suddenly realize the truth - there is no spoon.<br>Digital simulation ends here ONCE AGAIN.</font>"

/*
	OUTSIDE TURFS WITH NO GEN JUS MIDNIGHT LIGHT BABY
														*/

//Parent of all our outside turfs. Both the inside and outside should be on a parent like this.
/turf/open/floor/spooktime //But for now, we just handle what is outside, for light control etc.
	name = "You fucked up pal"
	desc = "Don't use this turf its a parent and just a holder."
	planetary_atmos = 1 //REVERT TO INITIAL AIR GASMIX OVER TIME WITH LINDA
	light_range = 3 //MIDNIGHT BLUE
	light_power = 0.15 //NOT PITCH BLACK, JUST REALLY DARK
	light_color = "#00111a" //The light can technically cycle on a timer worldwide, but no daynight cycle.
	baseturfs = /turf/open/floor/spooktime/spooktimegrass //If we explode or die somehow, we just become grass
	gender = PLURAL //THE GENDER IS PLURAL
	tiled_dirt = 0 //NO TILESMOOTHING DIRT/DIRT SPAWNS OR SOME SHIT


//Damaged plasteel plates, cause fuck varediting all these icons my man.
//Just search damturf for the tree

/turf/open/floor/plasteel/damturf //ez search plasteel parent
/turf/open/floor/plasteel/damturf/damage1
	icon_state = "damaged1"
/turf/open/floor/plasteel/damturf/damage2
	icon_state = "damaged2"
/turf/open/floor/plasteel/damturf/
	icon_state = "damaged3"
/turf/open/floor/plasteel/damturf/damage4
	icon_state = "damaged4"
/turf/open/floor/plasteel/damturf/damage5
	icon_state = "damaged5"
/turf/open/floor/plasteel/damturf/scorched
	icon_state = "panelscorched"
/turf/open/floor/plasteel/damturf/scorched1
	icon_state = "floorscorched1"
/turf/open/floor/plasteel/damturf/scorched2
	icon_state = "floorscorched2"
/turf/open/floor/plasteel/damturf/platdmg1
	icon_state = "platingdmg1"
/turf/open/floor/plasteel/damturf/platdmg2
	icon_state = "platingdmg2"
/turf/open/floor/plasteel/damturf/platdmg3
	icon_state = "platingdmg3"

/turf/open/floor/wood/damturf //ez search wood parent
/turf/open/floor/wood/damturf/broken1
	icon_state = "wood-broken"
/turf/open/floor/wood/damturf/broken2
	icon_state = "wood-broken2"
/turf/open/floor/wood/damturf/broken3
	icon_state = "wood-broken3"
/turf/open/floor/wood/damturf/broken4
	icon_state = "wood-broken4"
/turf/open/floor/wood/damturf/broken5
	icon_state = "wood-broken5"
/turf/open/floor/wood/damturf/broken6
	icon_state = "wood-broken6"
/turf/open/floor/wood/damturf/broken7
	icon_state = "wood-broken7"

//Parent that goes into coasts too
/turf/open/floor/spooktime/beach //laketime
	gender = PLURAL
	name = "sand"
	desc = "ITS SAND!"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "sand"
	bullet_bounce_sound = null
	tiled_dirt = 0

//Beaches and coasts and sand and shit.
/turf/open/floor/spooktime/beach/coasts
	gender = NEUTER
	name = "coastline"
	desc = "The coastline of a sandy shore"
	icon_state = "sandwater_t_S"

//The water that follows the coastline also animated.
/turf/open/floor/spooktime/beach/coasts/coastS
	icon_state = "sandwater_t_S"
/turf/open/floor/spooktime/beach/coasts/coastN
	icon_state = "sandwater_t_N"
/turf/open/floor/spooktime/beach/coasts/coastE
	icon_state = "sandwater_t_E"
/turf/open/floor/spooktime/beach/coasts/coastW
	icon_state = "sandwater_t_W"
/turf/open/floor/spooktime/beach/coasts/coastSE
	icon_state = "sandwater_t_SE"
/turf/open/floor/spooktime/beach/coasts/coastSW
	icon_state = "sandwater_t_SW"
/turf/open/floor/spooktime/beach/coasts/coastNE
	icon_state = "sandwater_t_NE"
/turf/open/floor/spooktime/beach/coasts/coastNW
	icon_state = "sandwater_t_NW"

//The coastline itself with sand
/turf/open/floor/spooktime/beach/coasts/watercoastS
	icon_state = "sandwater_b_S"
/turf/open/floor/spooktime/beach/coasts/watercoastN
	icon_state = "sandwater_b_N"
/turf/open/floor/spooktime/beach/coasts/watercoastW
	icon_state = "sandwater_b_W"
/turf/open/floor/spooktime/beach/coasts/watercoastE
	icon_state = "sandwater_b_E"
/turf/open/floor/spooktime/beach/coasts/watercoastSE
	icon_state = "sandwater_b_SE"
/turf/open/floor/spooktime/beach/coasts/watercoastSW
	icon_state = "sandwater_b_SW"
/turf/open/floor/spooktime/beach/coasts/watercoastNE
	icon_state = "sandwater_b_NE"
/turf/open/floor/spooktime/beach/coasts/watercoastNW
	icon_state = "sandwater_b_NW"

//Beach corners
/turf/open/floor/spooktime/beach/coasts/innerN
	icon_state = "sandwater_inner_N"
/turf/open/floor/spooktime/beach/coasts/innerS
	icon_state = "sandwater_inner_S"
/turf/open/floor/spooktime/beach/coasts/innerE
	icon_state = "sandwater_inner_E"
/turf/open/floor/spooktime/beach/coasts/innerW
	icon_state = "sandwater_inner_W"

//Shallow water same color as beach water
/turf/open/floor/spooktime/beach/water
	name = "water"
	icon_state = "water"
	bullet_sizzle = 1
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

//Slightly darker than the beach water color.
/turf/open/floor/spooktime/beach/watersolid //Gotta stop you at a certain point man
	name = "water"
	icon_state = "water2" //Now its darker lol
	bullet_sizzle = 1
	density = 1 //We are now dense
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

//Motion river water with the lighting on it.
/turf/open/floor/spooktime/riverwatermotion
	gender = PLURAL
	name = "water"
	desc = "Shallow water."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "riverwater_motion"
	slowdown = 1
	bullet_sizzle = 1
	bullet_bounce_sound = null //needs a splashing sound one day.
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

//No motion river water with the lighting on it.
/turf/open/floor/spooktime/riverwatermotion/nomotion
	icon_state = "riverwater"

//Grass with no flora generation on it.
/turf/open/floor/spooktime/nonspooktimegrass
	name = "grass patch"
	desc = "You can't tell if this is real grass... Ah, who are you kidding, it totally is real grass."
	icon_state = "grass_1" //Grass of the varied variety.
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/spooktime/nongenspooktimegrass/Initialize() //Init rng icon.
	. = ..()
	icon_state = "grass_[rand(1,3)]"

/turf/open/floor/spooktime/dirtpatch
	name = "clearly dirt"
	desc = "Its dirt alright"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "smoothdarkdirt"
	light_range = 0 //We set the lights to nothing on the CLEARLY DIRT
	light_power = 0 //ayep
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/spooktime/snow
	gender = PLURAL
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	desc = "Looks cold."
	icon_state = "snow"
	slowdown = 2
	light_range = 0
	light_power = 0
	bullet_sizzle = 1
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/spooktime/snow/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/spooktime/snow/crowbar_act(mob/living/user, obj/item/I)
	return


//Cobblestone and all of its directions tied to the parent.
/turf/open/floor/spooktime/cobble //Middle and parent
	name = "cobblestone path" //We don't use directional varedits otherwise the map can load them incorrect.
	desc = "A simple but beautiful path made of various sized stones."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "cobble_mid" //as to why? Sometimes it will spawn the turf elsewhere and move it into place.
	//That means the direction will change because of this movement, usually when theres things ontop of it.
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = 0

/turf/open/floor/spooktime/cobble/roadmid //Center piece
	name = "road"
	desc = "Its asphault alright"
	icon_state = "road"

/turf/open/floor/spooktime/cobble/roadsideN //road edges, I have a lot of these
	icon_state = "road_side_N"
/turf/open/floor/spooktime/cobble/roadsideS //But i don't feel like adding them all for a temp map.
	icon_state = "road_side_S"
/turf/open/floor/spooktime/cobble/roadsideE
	icon_state = "road_side_E"
/turf/open/floor/spooktime/cobble/roadsideW
	icon_state = "road_side_W"
/turf/open/floor/spooktime/cobble/roadcornerSW
	icon_state = "road_corner_sw"

/turf/open/floor/spooktime/cobble/cornerNW //First corner
	icon_state = "cobble_corner_nw"
/turf/open/floor/spooktime/cobble/cornerNE //Now that these are hardcoded individuals.
	icon_state = "cobble_corner_ne"			//Movement won't change what they are on mapload.
/turf/open/floor/spooktime/cobble/cornerSW
	icon_state = "cobble_corner_sw"
/turf/open/floor/spooktime/cobble/cornerSE //I found i don't need most of these but still lol.
	icon_state = "cobble_corner_se"

/turf/open/floor/spooktime/cobble/sideN //First Side
	icon_state = "cobble_side_n"
/turf/open/floor/spooktime/cobble/sideS
	icon_state = "cobble_side_s"
/turf/open/floor/spooktime/cobble/sideE
	icon_state = "cobble_side_e"
/turf/open/floor/spooktime/cobble/sideW
	icon_state = "cobble_side_w"
/*
	Basic Grass turf w Flora gen
									*/
/turf/open/floor/spooktime/spooktimegrass
	name = "the ground"
	desc = "It clearly looks like grass and dirt, clearly."
	icon_state = "grass_1"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi' //32x32 iconfile, sry we had different sizes.
	broken_states = list("sand")
	footstep = FOOTSTEP_GRASS //Finally I can have my footstep noises
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	baseturfs = /turf/open/floor/spooktime/spooktimegrass //BENEATH SPOOKTIMEGRASS THERE IS SPOOKTIMEGRASS

	//Holders for what can occur on the turf.
	var/obj/structure/flora/turfGrass = null
	var/obj/structure/flora/turfTree = null
	var/obj/structure/flora/turfAusflora = null
	var/obj/structure/flora/turfRocks = null
	var/obj/structure/flora/turfDebris = null


/turf/open/floor/spooktime/spooktimegrass/Initialize() //Considering adding dirtgen here too.
	. = ..()
	if(prob(1))
		icon_state = "smoothdarkdirt" //Sometimes we can be dirt.
	else
		icon_state = "grass_[rand(1,3)]" //Icon state variation for how many states of grass I got... 3 lul
	//If no fences, machines (soil patches are machines), etc. try to plant grass
	if(!(\
			(locate(/obj/structure) in src) || \
			(locate(/obj/machinery) in src) ))
		floraGen() //And off we go riding into hell.
	update_icon()

//FEEL FREE TO FIDDLE WITH THIS BLACKMAJOR/FERMI/ETC. I'm still going to tune it in initially tho. -JTGSZ
//It'll work alongside any trees you place too, so its all gucci man dw.

//This is mostly for flora/doodads. I don't feel like there needs to be lake/cave and animals generation..
//For the halloween map at least, so I used the f13 flora gen and appended to it instead of usin cellular automata.
//Soooo, its just tied to the turf initialize on init right now.
//Right now each segment generates independantly, but it wouldn't be hard to do it in a chain
//And check for what else is there before a list of objects has the option to appear.
//Or even change weighting based on the weight of other things that the turf has checked in its range.
//But at the same time, the stacked flora/rocks etc look pretty okay together honestly.
//On the other side of the coin, you could even adjust their pixelx and y.
//Since after-all things in nature don't just occupy one spot each a lot of the time.

//That being said you have somewhere around 50 seconds of init, and 160 seconds of pre-game time.
//To finish generation if you need to split it up by chunks and add more checks.
//Its plenty of time considering how fast it finishes like this without hiccups really.

//I have turned what used to be simple into hell.
//We can keep appending stuff here as we go, it basically just spawns it all on turf spooktimegrass on init.

		    //=========>Set value // Initial Reference Value <=============
#define GRASS_SPONTANEOUS 		2//2 //chance it appears on the tile on its own
#define GRASS_WEIGHT 			4//4 //multiplier increase if theres some nearby
#define TREE_SPONTANEOUS		4//2
#define TREE_WEIGHT				4//4
#define AUSFLORA_SPONTANEOUS	2//2
#define AUSFLORA_WEIGHT			3//4
#define ROCKS_SPONTANEOUS		2//2 //Technically this can be moved to the desolate spawn list tied to grass.
#define ROCKS_WEIGHT			1//1 //Lower weight cause rock clusters were too common...But cool honestly.
#define DEBRIS_SPONTANEOUS		2//2
#define DEBRIS_WEIGHT			2//2

//These are basically what can spawn in the lists, the number is the weight.
//The weight dictates how likely it is to spawn over other things in the lists. If you were to use pickweight.
#define LUSH_GRASS_SPAWN_LIST list(/obj/structure/flora/grass/spookytime = 4,\
 								/obj/structure/flora/ausbushes/lavendergrass = 3,\
								  /obj/structure/flora/ausbushes/sparsegrass = 6,\
								   /obj/structure/flora/ausbushes/fullgrass = 1\
								   )

#define TREE_SPAWN_LIST list(/obj/structure/flora/tree/spookytime = 9,\
								 /obj/structure/flora/tree/spookytimexl = 2,\
								 /obj/structure/flora/tree/jungle = 1,\
								 /obj/structure/flora/tree/jungle/small = 1\
								 )
								 
#define AUSFLORA_SPAWN_LIST list(/obj/structure/flora/ausbushes = 3,\
								/obj/structure/flora/ausbushes/grassybush = 3,\
								 /obj/structure/flora/ausbushes/fernybush = 1,\
								 /obj/structure/flora/ausbushes/sunnybush = 1,\
								 /obj/structure/flora/ausbushes/reedbush = 1,\
								 /obj/structure/flora/ausbushes/palebush = 1,\
								 /obj/structure/flora/ausbushes/stalkybush = 1\
								 )

#define ROCKS_SPAWN_LIST	list(/obj/structure/flora/spookyrock = 1\
								)

#define DEBRIS_SPAWN_LIST	list(/obj/structure/flora/tree/spookybranch = 5, \
								/obj/structure/flora/tree/spookylog = 1\
								)

//Lists that occur when the cluster doesn't happen but probability dictates it tries.
#define DESOLATE_SPAWN_LIST list(/obj/structure/flora/grass/spookytime = 1,\
								/obj/structure/flora/ausbushes/sparsegrass = 1\
								)

//I just kinda made it worse... Like a lot worse. Ngl man.
/turf/open/floor/spooktime/spooktimegrass/proc/floraGen()
	var/grassWeight = 0 //grassWeight holders for each individual layer
	var/treeWeight = 0
	var/ausfloraWeight = 0
	var/rocksWeight = 0
	var/debrisWeight = 0

	var/randGrass = null //The random plant picked
	var/randTree = null //The random deadtree picked
	var/randAusflora = null //The random Ausflora picked
	var/randRocks = null //The random rock picked
	var/randDebris = null //The random wood debris picked

	//spontaneously spawn the objects based on probability from the define.
	//Ngl, a lot of this is going to be have to generate in certain orders later in this proc.
	if(prob(GRASS_SPONTANEOUS))
		randGrass = pickweight(LUSH_GRASS_SPAWN_LIST) //Create a new grass object at this location, and assign var
		turfGrass = new randGrass(src) //The var on the turf now has a new randgrass from the list.

	if(prob(TREE_SPONTANEOUS))
		randTree = pickweight(TREE_SPAWN_LIST)
		turfTree = new randTree(src)

	if(prob(AUSFLORA_SPONTANEOUS))
		randAusflora = pickweight(AUSFLORA_SPAWN_LIST)
		turfAusflora = new randAusflora(src)

	if(prob(ROCKS_SPONTANEOUS))
		randRocks = pickweight(ROCKS_SPAWN_LIST)
		turfRocks = new randRocks(src)

	if(prob(DEBRIS_SPONTANEOUS))
		randDebris = pickweight(DEBRIS_SPAWN_LIST)
		turfDebris = new randDebris(src)


	//loop through neighbouring turfs, if they have grass, then increase weight, cluster prep.
	for(var/turf/open/floor/spooktime/spooktimegrass/T in RANGE_TURFS(3, src))
		if(T.turfGrass) //We check what is around our turf
			grassWeight += GRASS_WEIGHT //The weight is increased by grass weight per every grass we find
		if(T.turfTree)
			treeWeight += TREE_WEIGHT
		if(T.turfAusflora)
			ausfloraWeight += AUSFLORA_WEIGHT
		if(T.turfRocks)
			rocksWeight += ROCKS_WEIGHT
		if(T.turfDebris)
			debrisWeight += DEBRIS_WEIGHT


	//Below is where we handle clusters really.
	//use weight to try to spawn grass
	if(prob(grassWeight)) //Basically after the earlier calc, we now roll probability.
		//If surrounded on 5+ sides, pick from lush
		if(grassWeight == (5 * GRASS_WEIGHT)) //If we are five times the define value, aka 5 detected.
			randGrass = pickweight(LUSH_GRASS_SPAWN_LIST) //We weighted pick from the lush list, aka boys that can be together.
		else //Else.
			randGrass = pickweight(DESOLATE_SPAWN_LIST) //We weighted pick from boys that are fine being alone.
		turfGrass = new randGrass(src) //And at the end we set the turfgrass to this object.

	if(prob(treeWeight)) //We can technically redirect individuals down here too, but lets just focus on clumps.
		randTree = pickweight(TREE_SPAWN_LIST)
		turfTree = new randTree(src)

	if(prob(ausfloraWeight))
		randAusflora = pickweight(AUSFLORA_SPAWN_LIST)
		turfAusflora = new randAusflora(src)

	if(prob(rocksWeight))
		randRocks = pickweight(ROCKS_SPAWN_LIST)
		turfRocks = new randRocks(src)

	if(prob(debrisWeight))
		randDebris = pickweight(DEBRIS_SPAWN_LIST)
		turfDebris = new randDebris(src)

//Make sure we delete the objects if we ever change turfs
/turf/open/floor/spooktime/spooktimegrass/ChangeTurf()
	if(turfGrass)
		qdel(turfGrass)
	if(turfTree)
		qdel(turfTree)
	if(turfAusflora)
		qdel(turfAusflora)
	if(turfRocks)
		qdel(turfRocks)
	if(turfDebris)
		qdel(turfDebris)
	. =  ..()

//Grass baseturf helper, more than likely completely unneeded since its set on the original turf too.
/obj/effect/baseturf_helper/spooktimegrass
	name = "grass baseturf helper" //Basically just changes the baseturf into grass
	baseturf = /turf/open/floor/spooktime/spooktimegrass //Wherever it is at.

/* so we can't break this */
/turf/open/floor/spooktime/spooktimegrass/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return //No replacing it

/turf/open/floor/spooktime/spooktimegrass/burn_tile()
	return //No burning it

/turf/open/floor/spooktime/spooktimegrass/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return //No slippery

/turf/open/floor/spooktime/spooktimegrass/MakeDry()
	return //No making it dry.

/*
	The Flora that is generated onto the basic grassturf, or can be placed for tone building.
																								*/

//For ease of use, I'm appending ausflora variations here too.
//Stripped the other segments out, people don't need hay and interactions right now you know man?
//Technically we could also randomize the pixel_x, pixel_y placement of these guys for more dynamic thickets.
/obj/structure/flora/grass/spookytime
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi' //32x32 iconfile
	desc = "Some dry, virtually dead grass, cause its fall and not a wasteland this time."
	icon_state = "tall_grass_1"

/obj/structure/flora/grass/spookytime/New()
	..()
	icon_state = "tall_grass_[rand(1,8)]" //We have 8 states.

/obj/structure/flora/tree/spookytime
	name = "dead tree"
	desc = "It's a tree. Useful for combustion and/or construction."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile64.dmi' //64x64 iconfile
	icon_state = "deadtree_1"
	log_amount = 3
	density = 1
	obj_integrity = 100
	max_integrity = 100

/obj/structure/flora/tree/spookytime/New()
	icon_state = "deadtree_[rand(1,6)]" //We have 6 states
	..()

/obj/structure/flora/tree/spookytimexl
	name = "tall dead tree"
	desc = "It's a tree. Useful for combustion and/or construction. This ones quite tall"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/talltree128.dmi'
	icon_state = "tree_1"
	log_amount = 12
	density = 1
	obj_integrity = 200
	max_integrity = 200

/obj/structure/flora/tree/spookytimexl/New()
	icon_state = "tree_[rand(1,3)]" //We have 3 states.
	..()

/obj/structure/flora/tree/spookybranch
	name = "fallen branch"
	desc = "A branch from a tree"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "branch_1"
	log_amount = 1
	density = 0
	obj_integrity = 30
	max_integrity = 30

/obj/structure/flora/tree/spookybranch/New()
	icon_state = "branch_[rand(1,4)]"
	..()

/obj/structure/flora/tree/spookylog
	name = "fallen tree"
	desc = "A tree, that turned horizontal after it died"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "timber"
	log_amount = 5
	density = 0
	obj_integrity = 100
	max_integrity = 100 //only got one state man.

/obj/structure/flora/spookyrock
	name = "rock"
	desc = "Its a rock man. Hard as shit, and for you quite impassible."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "rock_1"
	density = 1

/obj/structure/flora/spookyrock/New()
	icon_state = "rock_[rand(1,3)]"
	..()