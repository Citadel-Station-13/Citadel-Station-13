#define WORKPIECE_PRESENT 1
#define WORKPIECE_INPROGRESS 2
#define WORKPIECE_FINISHED 3
#define WORKPIECE_SLAG 5

#define RECIPE_SMALLPICK "dbp" //draw bend punch
#define RECIPE_LARGEPICK "ddbp" //draw draw bend punch
#define RECIPE_SHOVEL "dfup" //draw fold upset punch
#define RECIPE_SMALLKNIFE "sdd" //shrink draw draw
#define RECIPE_HAMMER "sfp" //shrink fold punch
#define RECIPE_AXE "ufp" //upset fold punch
#define RECIPE_SHORTSWORD "dff" //draw fold fold
#define RECIPE_JAVELIN "dbf" //draw bend fold
#define RECIPE_SCYTHE "bdf" //bend draw fold
#define RECIPE_COGHEAD "bsf" //bend shrink fold.
#define RECIPE_BROADSWORD "dfufd" //draw fold upset fold draw
#define RECIPE_HALBERD "duffp" //draw upset fold fold punch

#define STEPS_CAP 8
/obj/structure/anvil
	name = "anvil"
	desc = "Base class of anvil. This shouldn't exist, but is useable."
	icon = 'icons/obj/smith.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	var/workpiece_state = FALSE
	var/datum/material/workpiece_material
	var/anvilquality = 0
	var/qualitymod = 0
	var/currentquality = 0 //lolman? what the fuck do these vars do?
	var/currentsteps = 0 //even i don't know
	var/strengthstepcostmod = 1 //todo: document this shit
	var/stepsdone = ""
	var/list/smithrecipes = list(RECIPE_AXE = /obj/item/smithing/axehead,
	RECIPE_HAMMER = /obj/item/smithing/hammerhead,
	RECIPE_SCYTHE = /obj/item/smithing/scytheblade,
	RECIPE_SHOVEL = /obj/item/smithing/shovelhead,
	RECIPE_COGHEAD = /obj/item/smithing/cogheadclubhead,
	RECIPE_JAVELIN = /obj/item/smithing/javelinhead,
	RECIPE_LARGEPICK = /obj/item/smithing/pickaxehead,
	RECIPE_SMALLPICK = /obj/item/smithing/prospectingpickhead,
	RECIPE_SHORTSWORD = /obj/item/smithing/shortswordblade,
	RECIPE_SMALLKNIFE = /obj/item/smithing/knifeblade,
	RECIPE_BROADSWORD = /obj/item/smithing/broadblade,
	RECIPE_HALBERD = /obj/item/smithing/halberdhead)

/obj/structure/anvil/Initialize()
	..()
	qualitymod = anvilquality

/obj/structure/anvil/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ingot))
		var/obj/item/ingot/notsword = I
		if(workpiece_state)
			to_chat(user, "There's already a workpiece! Finish it or take it off.")
			return FALSE
		if(notsword.workability == "shapeable")
			workpiece_state = WORKPIECE_PRESENT
			workpiece_material = notsword.custom_materials
			to_chat(user, "You place the [notsword] on the [src].")
			currentquality = qualitymod
			qdel(notsword)
		else
			to_chat(user, "The ingot isn't workable yet!")
			return FALSE
		return
	else if(istype(I, /obj/item/melee/smith/hammer))
		var/obj/item/melee/smith/hammer/hammertime = I
		if(workpiece_state == WORKPIECE_PRESENT || workpiece_state == WORKPIECE_INPROGRESS)
			do_shaping(user, hammertime.qualitymod)
			return
		else
		 to_chat(user, "You can't work an empty anvil!")
		 return FALSE
	return ..()

/obj/structure/anvil/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE


/obj/structure/anvil/proc/do_shaping(mob/user, var/qualitychange)
	qualitymod += qualitychange
	var/list/shapingsteps = list("weak hit", "strong hit", "heavy hit", "fold", "draw", "shrink", "bend", "punch", "upset") //weak/strong/heavy hit affect strength. All the other steps shape.
	workpiece_state = WORKPIECE_INPROGRESS
	var/stepdone = input(user, "How would you like to work the metal?") in shapingsteps
	switch(stepdone)
		if("weak hit")
			currentsteps += 1 * strengthstepcostmod
			strengthstepcostmod += 0.3
			qualitymod += 1
		if("strong hit")
			currentsteps += 1.25 * strengthstepcostmod
			strengthstepcostmod += 0.5
			qualitymod += 2
		if("heavy hit")
			currentsteps += 1.5 * strengthstepcostmod
			strengthstepcostmod += 0.7
			qualitymod += 3
		if("fold")
			stepsdone += "f"
			currentsteps += 1
			qualitymod -= 2
		if("draw")
			stepsdone += "d"
			currentsteps += 1
			qualitymod -= 2
		if("shrink")
			stepsdone += "s"
			currentsteps += 1
			qualitymod -= 2
		if("bend")
			stepsdone += "b"
			currentsteps += 1
			qualitymod -= 2
		if("punch")
			stepsdone += "p"
			currentsteps += 1
			qualitymod -= 2
		if("upset")
			stepsdone += "u"
			currentsteps += 1
			qualitymod -= 2
	to_chat(user, "You [stepdone] the metal.")
	currentquality += qualitymod
	to_chat(user, stepsdone)
	if(length(stepsdone) >= 3)
		tryfinish(user)

/obj/structure/anvil/proc/tryfinish(mob/user)
	if(currentsteps > STEPS_CAP)
		to_chat(user, "You overwork the metal, causing it to turn into useless slag!")
		var/turf/T = get_turf(user)
		workpiece_state = FALSE
		new /obj/item/stack/ore/slag(T)
		currentquality = 0
		qualitymod = anvilquality
		stepsdone = ""
		currentsteps = 0
	for(var/i in smithrecipes)
		to_chat(user, "comparing [i] to [stepsdone]")
		if(i == stepsdone)
			var/turf/T = get_turf(user)
			var/obj/item/smithing/create = smithrecipes[stepsdone]
			var/obj/item/smithing/finisheditem = new create(T)
			to_chat(user, "You finish your [finisheditem]!")
			workpiece_state = FALSE
			finisheditem.quality = currentquality
			finisheditem.set_custom_materials(workpiece_material)
			currentquality = 0
			qualitymod = anvilquality
			stepsdone = ""
			currentsteps = 0
			break


#undef WORKPIECE_PRESENT
#undef WORKPIECE_INPROGRESS
#undef WORKPIECE_FINISHED
#undef WORKPIECE_SLAG
