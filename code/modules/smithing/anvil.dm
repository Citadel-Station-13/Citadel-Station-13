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

/obj/structure/anvil
	name = "anvil"
	desc = "Base class of anvil. This shouldn't exist, but is useable."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "loom"
	density = TRUE
	anchored = TRUE
	var/workpiece_state = FALSE
	var/qualitymod = 0
	var/currentquality = qualitymod
	var/currentsteps = 0
	var/strengthstepcostmod = 1
	var/stepsdone
	var/list/recipes = (RECIPE_AXE, RECIPE_HAMMER, RECIPE_SCYTHE, RECIPE_SHOVEL, RECIPE_COGHEAD, RECIPE_JAVELIN, RECIPE_LARGEPICK, RECIPE_SMALLPICK, RECIPE_SHORTSWORD, RECIPE_SMALLKNIFE)

/obj/structure/anvil/attackby(obj/item/I, mob/user)
	if(istype(I, obj/item/ingot))
		var/obj/item/ingot/notsword = I
		if(workpiece_state)
			to_chat(user, "There's already a workpiece! Finish it or take it off.")
			return FALSE
		if(notsword.workability == "shapeable")
			workpiece_state = WORKPIECE_PRESENT
			to_chat(user, "You place the [notsword] on the [src].")
		else
			to_chat(user, "The ingot isn't workable yet!")
			return FALSE
		return
	return ..()

/obj/structure/anvil/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE


/obj/structure/anvil/proc/do_shaping(mob/user)
	var/list/shapingsteps = ("weak hit", "strong hit", "heavy hit", "fold", "draw", "shrink", "bend", "punch", "upset") //weak/strong/heavy hit affect strength. All the other steps shape.
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
	if(length(stepsdone) >= 3)
		//todo: TRYFINISHTHEPIECE
	//TODO: CHECK IF IT'S TOO WORKED
