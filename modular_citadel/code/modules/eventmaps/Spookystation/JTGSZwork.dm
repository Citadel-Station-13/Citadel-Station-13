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
//JT is weird, considering my handle is a acronym.
//Considering I can't grab defines from everywhere, I hope you enjoy strings and numbers plebs.
//Update - Moved to modular citadel so we are after everything has loaded...probably we gucci - jtgsz

/*
	AREAS
			*/
//This is generally how you handle planet areas, gen 1 large outside area is good for outside effects.
//PS: Mountain has a soundloop, outside has a soundloop, inside has a soundloop, mountaininside is silent
//This is for the rain weather my man.
/area/eventmap
	name = "Dont use this" //Its the parent to any dunces out there.
	has_gravity = STANDARD_GRAVITY //We have gravity
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/areas.dmi' //It unsets the icon. don't make a err icon.
	requires_power = 0 // We don't need power anywhere.
	flags_1 = NONE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/eventmap/outside //We are outside
	name = "Outside"
	icon_state = "outside"
	outdoors = 0 //I set outdoors to false. So areas can be edited.

/area/eventmap/inside //We are inside, all things are pretty normal.
	name = "Inside"
	icon_state = "inside"

/area/eventmap/mountain //Mostly so I can see the area lines of the mountain area in the minimap.
	name = "Mountain"
	icon_state = "mountain"
	var/mountain = 1

/area/eventmap/mountaininside
	name = "Silent Mountain Inside"
	icon_state = "mountain_inside"
	outdoors = 0

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

//In a ideal world, we would have split the turfs onto a single parent.
//Then we would tree from INSIDE and OUTSIDE, with outside having the lighting set, for the day/night subsystem to change.
//Outside would also have the planetary atmos and config on it.
//Inside would be a case to case basis depending on if you want it to scrub or not.. and not have the lighting.
//Along with what needs to be constructed on etc.
//This is not a ideal world so enjoy the overload.

//Parent of all our outside turfs. Both the inside and outside should be on a parent like this.
/turf/open/floor/spooktime //But for now, we just handle what is outside, for light control etc.
	name = "You fucked up pal"
	desc = "Don't use this turf its a parent and just a holder."
	planetary_atmos = 1 //REVERT TO INITIAL AIR GASMIX OVER TIME WITH LINDA. AKA SUPERSCRUBBER
	light_range = 3 //MIDNIGHT BLUE
	light_power = 0.15 //NOT PITCH BLACK, JUST REALLY DARK
	light_color = "#00111a" //The light can technically cycle on a timer worldwide, but no daynight cycle.
	baseturfs = /turf/open/floor/plating/spookbase/dirtattachmentpoint //If we explode or die somehow, we just become grass
	gender = PLURAL //THE GENDER IS PLURAL
	tiled_dirt = 0 //NO TILESMOOTHING DIRT/DIRT SPAWNS OR SOME SHIT

/turf/open/floor/spooktime/break_tile()
	return
/turf/open/floor/spooktime/burn_tile()
	return

/turf/open/floor/spooktime/pry_tile(obj/item/I, mob/user, silent = FALSE)
	return //No prying these tiles, you instead shovel it if avail.

/*
	Baseturf, when we call scrapeaway() after a shoveling. So people can attach tiles
																						*/

//WARNING VERY IMPORTANT AND HACKJOBBISH - Basically this handles construction on everything.
/turf/open/floor/plating/spookbase/dirtattachmentpoint //Lighted variant
	name = "the ground"
	desc = "Looks like its been dugged out and prepped for construction"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "dugdirt"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	attachment_holes = TRUE
	planetary_atmos = 1
	light_range = 3 //We reset this
	light_power = 0.15 //The lighting will unset when people place their tiles/etc on it.
	light_color = "#00111a" //It should be fine

	baseturfs = /turf/open/floor/plating/spookbase/dirtattachmentpoint //No going lower than this.

/turf/open/floor/plating/spookbase/dirtattachmentpoint/mountain
	name = "the ground"
	desc = "It has been dug out and prepared for construction."
	light_range = 0
	light_power = 0

	baseturfs = /turf/open/floor/plating/spookbase/dirtattachmentpoint/mountain

/turf/open/floor/plating/spookbase/sandattachmentpoint
	name = "the sand"
	desc = "Looks like its been dugged out and prepped for construction"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "dugsand"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	attachment_holes = TRUE
	planetary_atmos = 1
	light_range = 3
	light_power = 0.15
	light_color = "#00111a"

	baseturfs = /turf/open/floor/plating/spookbase/sandattachmentpoint // The sand version.

/*
	FLOOR TILES
							*/
/obj/item/stack/tile/nonspooktimegrass
	name = "clumps of grass"
	singular_name = "clump of grass"
	desc = "This is a clump of grass."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "grass_clump"
	turf_type = /turf/open/floor/spooktime/nonspooktimegrass
	resistance_flags = FLAMMABLE

/obj/item/stack/tile/normalasssand
	name = "piles of sand"
	singular_name = "pile of sand"
	desc = "This is a pile of sand"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "sand_clump"
	turf_type = /turf/open/floor/spooktime/beach

/*
	IMPORTANT TURFS */

//Grass with no flora generation on it.
/turf/open/floor/spooktime/nonspooktimegrass
	name = "grass patch"
	desc = "You can't tell if this is real grass... Ah, who are you kidding, it totally is real grass."
	icon_state = "grass_1" //Grass of the varied variety.
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	baseturfs = /turf/open/floor/plating/spookbase/dirtattachmentpoint
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	var/turfverb = "dig out"

/turf/open/floor/spooktime/nonspooktimegrass/Initialize(mapload) //Init rng icon.
	. = ..()
	icon_state = "grass_[rand(1,3)]"

/turf/open/floor/spooktime/nonspooktimegrass/attackby(obj/item/C, mob/user, params) //We dig it out with a shovel.
	if((C.tool_behaviour == TOOL_SHOVEL) && params) //And beneath it we reveal dirt
		new /obj/item/stack/tile/nonspooktimegrass(src)
		user.visible_message("[user] digs up [src].", "<span class='notice'>You [turfverb] [src].</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		make_plating()
	if(..())
		return


//Dirt patches with no lighting.
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
	baseturfs = /turf/open/floor/plating/spookbase/dirtattachmentpoint/mountain //no light variant
	var/turfverb = "dig out"

/turf/open/floor/spooktime/dirtpatch/attackby(obj/item/C, mob/user, params) //We dig it out with a shovel.
	if((C.tool_behaviour == TOOL_SHOVEL) && params) //And beneath it we reveal dirt
		user.visible_message("[user] digs up [src].", "<span class='notice'>You [turfverb] [src].</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		make_plating()
	if(..())
		return

//Snow with no planetary atmos, so the map doesn't atmos crash.
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
	var/turfverb = "dig out"


	baseturfs = /turf/open/floor/plating/spookbase/dirtattachmentpoint //beneath the grass there is dirt.

	//Holders for what can occur on the turf.
	var/obj/structure/flora/turfGrass = null
	var/obj/structure/flora/turfTree = null
	var/obj/structure/flora/turfAusflora = null
	var/obj/structure/flora/turfRocks = null
	var/obj/structure/flora/turfDebris = null


/turf/open/floor/spooktime/spooktimegrass/Initialize(mapload) //Considering adding dirtgen here too.
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

/turf/open/floor/spooktime/spooktimegrass/attackby(obj/item/C, mob/user, params) //We dig it out with a shovel.
	if((C.tool_behaviour == TOOL_SHOVEL) && params) //And beneath it we reveal dirt)
		new /obj/item/stack/tile/nonspooktimegrass(src)
		user.visible_message("[user] digs up [src].", "<span class='notice'>You [turfverb] [src].</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		make_plating()
	if(..())
		return

/turf/open/floor/spooktime/spooktimegrass/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return //No replacing it

/turf/open/floor/spooktime/spooktimegrass/burn_tile()
	return //No burning it

/turf/open/floor/spooktime/spooktimegrass/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return //No slippery

/turf/open/floor/spooktime/spooktimegrass/MakeDry()
	return //No making it dry.

/*
	FLORA GEN PROCEDURE
						*/

//This is mostly for flora/doodads. I don't feel like there needs to be lake/cave and animals generation..
//For the halloween map at least, so I used the f13 flora gen and appended to it instead of usin cellular automata.
//Soooo, its just tied to the turf initialize on init right now.
//Right now each segment generates independantly, but it wouldn't be hard to do it in a chain
//And check for what else is there before a list of objects has the option to appear.
//Or even change weighting based on the weight of other things that the turf has checked in its range.
//But at the same time, the stacked flora/rocks etc look pretty okay together honestly.
//On the other side of the coin, you could even adjust their pixel x and y for better thickets.
//Since after-all things in nature don't just occupy one spot each a lot of the time.

//That being said you have somewhere around 50 seconds of init, and 160 seconds of pre-game time.
//To finish generation if you need to split it up by chunks and add more checks.
//Its more time than you could ever want considering how fast it finishes like this without hiccups really.
//Ironically, not very resource intensive or slow to do this much of it.

//I have turned what used to be simple into hell.
//We can keep appending stuff here as we go, it basically just spawns it all on turf spooktimegrass on init.

//============> Current Set value // JTGSZ Tuned Reference Value <==============
#define GRASS_SPONTANEOUS 		2//2 //chance it appears on the tile on its own
#define GRASS_WEIGHT 			4//4 //multiplier increase if theres some nearby
#define TREE_SPONTANEOUS		4//4
#define TREE_WEIGHT				4//4
#define AUSFLORA_SPONTANEOUS	2//2
#define AUSFLORA_WEIGHT			3//3
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
	if(prob(GRASS_SPONTANEOUS)) //If probability THE DEFINE NUMBER
		randGrass = pickweight(LUSH_GRASS_SPAWN_LIST) //randgrass is assigned a obj from the weighted list
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
	if(prob(grassWeight)) //Basically the probability goes by the DEFINE WEIGHT the more of it is around.
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
/turf/open/floor/spooktime/spooktimegrass/ChangeTurf(flags = CHANGETURF_INHERIT_AIR)
	if(turfGrass)
		qdel(turfGrass)
	//if(turfTree)
	//	qdel(turfTree)
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

//A reference to this list is passed into area sound managers, and it's modified in a manner that preserves that reference in ash_storm.dm
GLOBAL_LIST_EMPTY(rain_sounds)

// HEY!! IF THIS DOES NOT WORK CHECK LOGIN.DM !!!!!

/*
	HERE COMES THE MOTHERFUCKING RAIN
										*/
/datum/weather/long_rain
	name = "Long rain at midnight"
	desc = "The planet sometimes rains, nothing special about it really."

	telegraph_duration = 130
	telegraph_message = "<span class='notice'>Water droplets begin falling from the sky.</span>"
	telegraph_overlay = "regular_rain" //Ya my apologies for not making a new rain icon

	weather_message = "<span class='notice'>The droplets become a downpour, rain now falls all around you from the night sky.</span>"
	weather_overlay = "regular_rain" //But I need to work on my mouse on the day of 10/24/2019, so lets call it here.
	weather_duration_lower = 12000 //these are deciseconds.
	weather_duration_upper = 15000

	end_duration = 100
	end_message = "<span class='notice'>The downpour gradually slows until it stops.</span>"

	area_type = /area/eventmap/outside
	target_trait = ZTRAIT_LONGRAIN
	probability = 90

	barometer_predictable = TRUE

	var/list/outside_longrain = list()
	var/list/inside_longrain = list()
	var/list/mountain_longrain = list()
	// var/datum/looping_sound/active_outside_longrain/sound_ao = new(list(), FALSE, TRUE) //Outside
	// var/datum/looping_sound/active_inside_longrain/sound_ai = new(list(), FALSE, TRUE) //Inside
	// var/datum/looping_sound/active_mountain_longrain/sound_am = new(list(), FALSE, TRUE) //Mountain

/datum/weather/long_rain/telegraph() //Yeah, I'm sorry but I just stole ash storm sound loops
	. = ..()
	var/list/eligible_areas = list()
	for(var/z in impacted_z_levels) //We check the Z level
		eligible_areas += SSmapping.areas_in_z["[z]"] //And append them to eligible areas list


	for(var/i in 1 to eligible_areas.len)
		var/area/place = eligible_areas[i]
		if(istype(place, /area/eventmap/outside)) //If the place is this path
			outside_longrain[place] = /datum/looping_sound/active_outside_longrain //Outside areas is the place
		if(istype(place, /area/eventmap/inside))
			inside_longrain[place] = /datum/looping_sound/active_inside_longrain
		if(istype(place, /area/eventmap/mountain))
			mountain_longrain[place] = /datum/looping_sound/active_mountain_longrain

		CHECK_TICK

	//We modify this list instead of setting it to weak/stron sounds in order to preserve things that hold a reference to it
	//It's essentially a playlist for a bunch of components that chose what sound to loop based on the area a player is in
	GLOB.rain_sounds += outside_longrain
	return ..()

/datum/weather/long_rain/start()
	GLOB.ash_storm_sounds += mountain_longrain
	GLOB.ash_storm_sounds += inside_longrain
	return ..()

/datum/weather/long_rain/end()
	GLOB.ash_storm_sounds -= outside_longrain
	GLOB.ash_storm_sounds -= inside_longrain
	GLOB.ash_storm_sounds -= mountain_longrain
	return ..()

/datum/looping_sound/active_outside_longrain
	mid_sounds = list('modular_citadel/code/modules/eventmaps/Spookystation/outsideloop1.ogg'=1,
					  'modular_citadel/code/modules/eventmaps/Spookystation/outsideloop2.ogg'=1)
	mid_length = 3.8 //ahahaa aaaaaaaaaa fucking shit man, but its what I got.
	volume = 70
	start_sound = 'sound/ambience/acidrain_start.ogg'
	start_length = 13
	end_sound = 'sound/ambience/acidrain_end.ogg'

/datum/looping_sound/active_inside_longrain
	mid_sounds = list('modular_citadel/code/modules/eventmaps/Spookystation/insideloop1.ogg'=1,
					'modular_citadel/code/modules/eventmaps/Spookystation/insideloop2.ogg'=1,
					'modular_citadel/code/modules/eventmaps/Spookystation/insideloop3.ogg'=1,
					'modular_citadel/code/modules/eventmaps/Spookystation/insideloop4.ogg'=1)
	mid_length = 5.1 //AAAAAAAAAAAAAAAAAAAAAAA
	volume = 60

/datum/looping_sound/active_mountain_longrain
	mid_sounds = list('modular_citadel/code/modules/eventmaps/Spookystation/basecaveloop.ogg'=1)
	mid_length = 12 //Why are we still here? Just to suffer?
	volume = 60

/*
	GRANDFATHER CLOCK
						*/

/*
	1:00 AM		- 	overlay-2
	2:00 AM		-	overlay-2
	3:00 AM		-	overlay-3
	4:00 AM		-	overlay-4
	5:00 AM		- 	overlay-4
	6:00 AM 	- 	overlay-6
	7:00 AM 	- 	overlay-7
	8:00 AM 	- 	overlay-7
	9:00 AM 	- 	overlay-9
	10:00 AM 	- 	overlay-10
	11:00 AM 	- 	overlay-10
	12:00 AM	-	overlay-0
								 */

/obj/machinery/grandfatherclock
	name = "Grandfather Clock"
	desc = "Keeps track of the time with its dials."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/clock32x49.dmi'
	icon_state = "grandfathermk4right"
	density = 1
	anchored = 1
	use_power = 0
	max_integrity = 250
	var/HRimgstate = "asshouroverlay-0"
	var/MMimgstate = "assminuteoverlay-0"
	var/ticktock = 0 // We hold this here
	var/dyndial_cycle_ticker = 0 //How many
	var/playchime = 1 //Procs will reset their vars.

/obj/machinery/grandfatherclock/Initialize(mapload)
	. = ..()
	update_icon() //We get it done

/obj/machinery/grandfatherclock/process()
	doodad_clock_ticker()


/obj/machinery/grandfatherclock/proc/doodad_clock_ticker() //We basically throttle the rest of this machine here.

	dyndial_cycle_ticker++

	if(ticktock) //If we are true
		playsound(src.loc, 'modular_citadel/code/modules/eventmaps/Spookystation/Tock.ogg', 100,0)
		icon_state = "grandfathermk4right"
		flick("tick", src)
		ticktock = 0 //Play this noise set to false
	else
		playsound(src.loc, 'modular_citadel/code/modules/eventmaps/Spookystation/Tick.ogg', 100,0)
		flick("tock", src)
		icon_state = "grandfathermk4left"
		ticktock = 1 //If we are not true, play this noise set to true

	if(dyndial_cycle_ticker >= 20) //Handles the dynamic dial
		dyndial_cycle()
		dyndial_cycle_ticker = 0

/obj/machinery/grandfatherclock/proc/dyndial_cycle()
	var/ass_time = STATION_TIME(TRUE, world.time) //Fun fact, space station time has a timezone offset, If its not on display time. I added world.time to fix the compile error. I dunno if it works as intended still!!
	var/hour = (text2num(time2text(ass_time, "hh"))%12)
	var/minute = text2num(time2text(ass_time, "mm"))

	//to_chat(world, "dyndial cycle current says: [hour]:[minute] - Ass_time currently says [ass_time]")
	if(playchime && hour == 0)
		playsound(src.loc, 'modular_citadel/code/modules/eventmaps/Spookystation/midnightchime.ogg', 100, 0)
		playchime = 0
	if(!playchime && hour == 11)
		playchime = 1

	switch(hour)
		if(1, 2)
			HRimgstate = "asshouroverlay-2" //Now it is ass, mostly because someones going to kill me for the other names.
		if(3)
			HRimgstate = "asshouroverlay-3"
		if(4, 5)
			HRimgstate = "asshouroverlay-4"
		if(6)
			HRimgstate = "asshouroverlay-6"
		if(7, 8)
			HRimgstate = "asshouroverlay-7"
		if(9)
			HRimgstate = "asshouroverlay-9"
		if(10, 11)
			HRimgstate = "asshouroverlay-10"
		else
			HRimgstate = "asshouroverlay-0" //Station time wraps to 0, and so does our hours.

	switch(minute)
		if(0 to 3)
			MMimgstate = "assminuteoverlay-0"
		if(4 to 15)
			MMimgstate = "assminuteoverlay-2"
		if(16 to 22)
			MMimgstate = "assminuteoverlay-3"
		if(23 to 28)
			MMimgstate = "assminuteoverlay-4"
		if(29 to 33)
			MMimgstate = "assminuteoverlay-6"
		if(34 to 41)
			MMimgstate = "assminuteoverlay-7"
		if(42 to 49)
			MMimgstate = "assminuteoverlay-9"
		if(50 to 57)
			MMimgstate = "assminuteoverlay-10"
		else
			MMimgstate = "assminuteoverlay-0" //This has 58 to 60 and everything else.

	update_icon() //Everything is set, lets update.

/obj/machinery/grandfatherclock/update_icon()
	cut_overlays() //We cut the overlays.

	add_overlay(MMimgstate) //And append our new states, Minute
	add_overlay(HRimgstate) //Hour.

/*
	The Flora that is generated onto the basic grassturf, or can be placed for tone building.
																								*/

//For ease of use, I should have appended it all here..
//Stripped the other segments out, people don't need hay and interactions right now you know man?
//Technically we could also randomize the pixel_x, pixel_y placement of these guys for more dynamic thickets.
/obj/structure/flora/grass/spookytime
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi' //32x32 iconfile
	desc = "Some dry, virtually dead grass, cause its fall and not a wasteland this time."
	icon_state = "tall_grass_1"

/obj/structure/flora/grass/spookytime/New()
	..()
	icon_state = "tall_grass_[rand(1,8)]" //We have 8 states.

/obj/structure/flora/grass/spookytime/attackby(obj/item/W, mob/user, params)
	if(W.sharpness && W.force > 0 && !(NODECONSTRUCT_1 in flags_1))
		to_chat(user, "You begin to harvest [src]...")
		if(do_after(user, 100/W.force, target = user))
			to_chat(user, "<span class='notice'>You've collected [src]</span>")
			var/obj/item/stack/sheet/hay/H = user.get_inactive_held_item()
			if(istype(H))
				H.add(1)
			else
				new /obj/item/stack/sheet/hay/(get_turf(src))
			qdel(src)
			return TRUE
	else
		. = ..()

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

/*
	WALLS - BECAUSE I HAD TO REPLACE ALL OF THEM ON THE MAP AND DO IT RIGHT THIS TIME
																						*/
/turf/closed/wall/mineral/wood


/obj/structure/falsewall/wood

//Due to the behavior of walls generally, I'm not going to make a microcosm of full flexibility
//and functionability for a ball map, but heres everything we are usually using for future reference.

/*
	TURF DIRECTIONALS, OVERALL SPAMMED STUFF ETC
												*/

//Mostly here because I was tired of searching the top stuff.
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
	var/turfverb = "dig up"

	baseturfs = /turf/open/floor/plating/spookbase/sandattachmentpoint //Alas, now people can dig out lakes.

/turf/open/floor/spooktime/beach/attackby(obj/item/C, mob/user, params) //We dig it out with a shovel.
	if((C.tool_behaviour == TOOL_SHOVEL) && params) //And beneath it we reveal dirt
		new /obj/item/stack/tile/normalasssand(src) //EDIT THIS
		user.visible_message("[user] digs up [src].", "<span class='notice'>You [turfverb] [src].</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		make_plating()
	if(..())
		return

//Beaches and coasts and sand and shit.
/turf/open/floor/spooktime/beach/coasts
	gender = NEUTER
	name = "coastline"
	desc = "The coastline of a sandy shore"
	icon_state = "sandwater_t_S"

/turf/open/floor/spooktime/beach/coasts/attackby(obj/item/C, mob/user, params)
	return //Upon testing, digging out the coasts makes the map look like ass.

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
	desc = "Its water that seems to be a bit deep, still can wade through though."
	icon_state = "water"
	bullet_sizzle = 1
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/turf/open/floor/spooktime/beach/water/attackby(obj/item/C, mob/user, params)
	return //haha nope

//Slightly darker than the beach water color.
/turf/open/floor/spooktime/beach/watersolid //Gotta stop you at a certain point man
	name = "water"
	desc = "Water thats deep enough to where your spaceman ass cannot swim."
	icon_state = "water2" //Now its darker lol
	bullet_sizzle = 1
	density = 1 //We are now dense
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/turf/open/floor/spooktime/beach/watersolid/attackby(obj/item/C, mob/user, params)
	return //You aren't digging my lake out unless I want you to fool.

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

//A tiny tiny bit of the total road icon file from f13 edited for grass not desert hastily.
//Theres something like 30 pieces including crosswalks, sidewalks, potholes and other shit in it man.
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

/turf/open/indestructible/spooknecropolis
	name = "necropolis floor"
	desc = "It's regarding you suspiciously."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro1"
	baseturfs = /turf/open/indestructible/necropolis
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	tiled_dirt = FALSE

//Fermis's umbrella

/obj/item/umbrella
    name = "umbrella"
    desc = "To keep the rain off you. Use with caution on windy days."
    icon = 'icons/obj/items_and_weapons.dmi'
    lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/items_righthand.dmi'
    icon_state = "umbrella_closed"
    slot_flags = ITEM_SLOT_BELT
    force = 5
    throwforce = 5
    w_class = WEIGHT_CLASS_SMALL
    var/open = FALSE

/obj/item/umbrella/Initialize(mapload)
    ..()
    color = RANDOM_COLOUR
    update_icon()

/obj/item/umbrella/attack_self()
    toggle_umbrella()

/obj/item/umbrella/proc/toggle_umbrella()
    open = !open
    icon_state = "umbrella_[open ? "open" : "closed"]"
    item_state = icon_state
    update_icon()

//Keep the mechs out of the mech arena
/obj/structure/trap/ctf/nomech
	name = "anti-mech barrier"
	desc = "attempts to bring mechs into the regular ball space may result in spontaneous crabification"

/obj/structure/trap/ctf/nomech/Crossed(atom/movable/AM)
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	flare()
	if(ismecha(AM) || istype(AM, /obj/item/mecha_parts) || istype(AM, /obj/structure/mecha_wreckage))
		qdel(AM)

/*
	Shitty Hay Objects Sprited by me in a rush when I was half-asleep at 9am + The material
																							*/

GLOBAL_LIST_INIT(hay_recipes, list ( \
	new/datum/stack_recipe("Rice Hat", /obj/item/clothing/head/rice_hat, 4, time = 5, one_per_turf = 0, on_floor = 0), \
	new/datum/stack_recipe("Hay Bed", /obj/structure/bed/badhaybed, 4, time = 15, one_per_turf = 1, on_floor = 0), \
	new/datum/stack_recipe("Wicker Basket", /obj/structure/closet/crate/awfulwickerbasket, 5, time = 40, one_per_turf = 0, on_floor = 1), \
))
//Thanks Gomble
/obj/item/stack/sheet/hay
	name = "hay"
	desc = "A bundle of hay. Food for livestock, and useful for weaving. Hail the Wickerman."
	singular_name = "hay stalk"
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "hay"
	item_state = "hay"
	force = 1
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	max_amount = 500
	attack_verb = list("tickled", "poked", "whipped")
	hitsound = 'sound/weapons/grenadelaunch.ogg'

/obj/item/stack/sheet/hay/get_main_recipes()
	. = ..()
	. += GLOB.hay_recipes

/obj/item/stack/sheet/hay/fifty
	amount = 50

/obj/item/stack/sheet/hay/twenty
	amount = 20

/obj/item/stack/sheet/hay/ten
	amount = 10

/obj/item/stack/sheet/hay/five
	amount = 5


/obj/item/stack/sheet/hay/update_icon_state()
	var/amount = get_amount()
	if((amount <= 4) && (amount > 0))
		icon_state = "hay[amount]"
	else
		icon_state = "hay"

/*
	Hay Objects hastily drawn by me at 9am in a rush.
														*/
//Shitty bed
/obj/structure/bed/badhaybed
	name = "Low-quality Hay Bed"
	desc = "It looks like someone hastily put this together, even if the builder didn't."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "shitty_hay_bed"
	anchored = 1
	can_buckle = 1
	buckle_lying = 1
	resistance_flags = FLAMMABLE
	max_integrity = 50
	integrity_failure = 30
	buildstacktype = /obj/item/stack/sheet/hay
	buildstackamount = 5

//Awful Wicker Basket
/obj/structure/closet/crate/awfulwickerbasket
	name = "Low-quality Wicker Basket"
	desc = "A handmade wicker basket, you don't know why it looks like this. But you probably don't like it."
	icon = 'modular_citadel/code/modules/eventmaps/Spookystation/iconfile32.dmi'
	icon_state = "shitty_basket" //yes, there is no space on crates so the other state is shitty_basketopen
	resistance_flags = FLAMMABLE
	material_drop = /obj/item/stack/sheet/hay
	material_drop_amount = 5
