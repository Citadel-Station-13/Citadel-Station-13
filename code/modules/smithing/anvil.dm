

/obj/structure/anvil
	name = "anvil"
	desc = "Base class of anvil. This shouldn't exist, but is useable."
	icon = 'icons/obj/smith.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	var/busy = FALSE //If someone is already interacting with this anvil
	var/workpiece_state = FALSE
	var/obj/item/ingot/workpiece
	var/debug = FALSE //vv this if you want an artifact
	var/variance = 0
	var/anvilqualityadd = 0

/obj/structure/anvil/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ingot))
		var/obj/item/ingot/notsword = I
		if(workpiece_state)
			to_chat(user, "<span class='danger'>There's already a workpiece! Finish it or take it off.</span>")
			return FALSE
		if(notsword.worktemp > 0)
			var/datum/smith_recipe/todone
			if(!notsword.plan)
				todone = input(user, "What do you plan to make?") as null|anything in GLOB.smith_recipes //todo radial
				if(!todone)
					return FALSE
				else
					notsword.plan = todone
					to_chat(user, "<span class='notice'>You decide to make a [todone.initial(displayname)].</notice>")
			workpiece_state = TRUE
			to_chat(user, "You place the [notsword] on the [src].")
			workpiece = notsword
			notsword.forceMove(src)
		else
			to_chat(user, "<span class='danger'>The ingot isn't hot enough to work yet!</span>")
			return FALSE
		return
	else if(istype(I, /obj/item/melee/smith/hammer))
		var/obj/item/melee/smith/hammer/hammertime = I
		if(!workpiece)
			to_chat(user, "<span class='danger'>You can't work an empty anvil!</span>")
			return FALSE
		if(workpiece && workpiece.worktemp == 0)
			to_chat(user, "<span class='danger'>The piece is too cold to work!</span>")
			return FALSE
		if(busy)
			to_chat(user, "<span class='danger'>This anvil is already being worked!</span>")
			return FALSE
		do_shaping(user, hammertime)
		return
	return ..()

/obj/structure/anvil/examine(mob/user)
	. = ..()
	if(workpiece)
		. += "<span class='notice'> It looks like the ingot is around [workpiece.height]." //wow it's really hard to both quantify and qualify a value so here we are, magic numbers

/obj/structure/anvil/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE

/obj/structure/anvil/AltClick(mob/living/user)
	..()
	if(busy)
		to_chat(user, "<span class='notice'>You can't move the ingot, it's being worked on!</span>")
	if(workpiece && workpiece_state)
		user.visible_message("<span class='notice'>[user] pushes the [workpiece] off the anvil!!</span>")
		workpiece.forceMove(get_turf(src))
		workpiece_state = FALSE
		workpiece = null
	else
		to_chat(user, "<span class='notice'>There's nothing there.</span>")


/obj/structure/anvil/proc/do_shaping(mob/user, var/obj/item/melee/smith/hammer/ham)
	busy = TRUE
	var/list/shapingsteps = list(STEP_HIT_LIGHT, STEP_HIT_MODERATE, STEP_HIT_HEAVY, STEP_DRAW, STEP_PUNCH, STEP_BEND, STEP_UPSET, STEP_FOLD)
	var/stepdone = input(user, "How would you like to work the metal?") in shapingsteps //todo radial
	var/steptime = 50 * ham.toolspeed
	if(user.mind.skill_holder)
		var/skillmod = user.mind.get_skill_level(/datum/skill/level/dwarfy/blacksmithing)/10 + 1
		steptime = 50 / skillmod
	playsound(src, 'sound/effects/clang2.ogg',40, 2)
	if(!do_after(user, steptime, target = src))
		busy = FALSE
		return FALSE
	switch(stepdone)
		if(STEP_HIT_LIGHT)
			workpiece.height -= 2
		if(STEP_HIT_MODERATE)
			workpiece.height -= 8
		if(STEP_HIT_HEAVY)
			workpiece.height -= 16
		if(STEP_DRAW)
			workpiece.height -= 24
		if(STEP_PUNCH)
			workpiece.height += 3
		if(STEP_BEND)
			workpiece.height += 6
		if(STEP_UPSET)
			workpiece.height += 12
		if(STEP_FOLD)
			workpiece.height += 24
	workpiece.worktemp--
	workpiece.add_step(stepdone)
	user.visible_message("<span class='notice'>[user] works the metal on the anvil with their hammer with a loud clang!</span>", \
						"<span class='notice'>You work the metal with a loud clang!</span>")
	playsound(src, 'sound/effects/clang2.ogg',40, 2)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, 'sound/effects/clang2.ogg', 40, 2), 15)
	tryfinish(user)
	busy = FALSE

	tryfinish(user)


/obj/structure/anvil/proc/tryfinish(mob/user)
	var/datum/smith_recipe/recipe = workpiece.plan
	var/list/pls = pls = recipe.initial(planlaststeps)
	if(!recipe)
		return FALSE
	if(workpiece.height > recipe.initial(target_height_min) && workpiece.height < recipe.initial(target_height_max))
		switch(recipe.planlaststeps.len)
			if(1)
				if(pls[STEP_LAST] != workpiece.last3steps[STEP_LAST])
					return FALSE
			if(2)
				if(pls[STEP_LAST] != workpiece.last3steps[STEP_LAST] && pls[STEP_SECOND_LAST] != workpiece.last3steps[STEP_SECOND_LAST])
					return FALSE
			if(3)
				if(pls != workpiece.last3steps)
					return FALSE
		generateitem(user)
	else if(workpiece.height > 144 || workpiece.height < 0)
		to_chat(user, "<span class='danger'> You ruin the [workpiece] by overworking it!</span>")
		qdel(workpiece)
		workpiece_state = FALSE
		workpiece = null
	else
		return FALSE



/obj/structure/anvil/proc/generateitem(mob/user)
	var/skillmod = 0
	var/finalquality = 0
	var/_artifact = FALSE
	if(user.mind.skill_holder)
		skillmod = user.mind.get_skill_level(/datum/skill/level/dwarfy/blacksmithing)/2
	if(workpiece.height == workpiece.plan.target_height_perfect)
		finalquality++
	finalquality += workpiece.currentquality + skillmod + anvilqualityadd
	if(debug || prob(0.5*finalquality))
		_artifact = TRUE

	var/obj/item/smithing/output = new(workpiece.plan.output_type)
	output.quality = finalquality
	output.artifact = _artifact
	output.forceMove(get_turf(src))

/obj/structure/anvil/debugsuper
	name = "super ultra epic anvil of debugging."
	desc = "WOW. A DEBUG <del>ITEM</DEL> STRUCTURE. EPIC."
	icon_state = "anvil"
	anvilqualityadd = 9001

/obj/structure/anvil/obtainable
	name = "anvil"
	desc = "Base class of anvil. This shouldn't exist, but is useable."

/obj/structure/anvil/obtainable/table
	name = "table anvil"
	desc = "A slightly reinforced table. Good luck."
	icon_state = "tablevil"
	variance = 4


/obj/structure/anvil/obtainable/table/do_shaping(mob/user, var/qualitychange)
	if(prob(5))
		to_chat(user, "<span class='danger'>The [src] breaks under the strain!</span>")
		take_damage(max_integrity)
		return FALSE
	else
		..()

/obj/structure/anvil/obtainable/bronze
	name = "slab of bronze"
	desc = "A big block of bronze. Useable as an anvil."
	custom_materials = list(/datum/material/bronze=8000)
	icon_state = "ratvaranvil"

/obj/structure/anvil/obtainable/sandstone
	name = "sandstone brick anvil"
	desc = "A big block of sandstone. Useable as an anvil."
	custom_materials = list(/datum/material/sandstone=8000)
	icon_state = "sandvil"
	variance = 2

/obj/structure/anvil/obtainable/basalt
	name = "basalt brick anvil"
	desc = "A big block of basalt. Useable as an anvil, better than sandstone. Igneous!"
	icon_state = "sandvilnoir"

/obj/structure/anvil/obtainable/basic
	name = "anvil"
	desc = "An anvil. It's got wheels bolted to the bottom."
	anvilqualityadd = 1

/obj/structure/anvil/obtainable/ratvar
	name = "brass anvil"
	desc = "A big block of what appears to be brass. Useable as an anvil. May contain traces of clock magic."
	custom_materials = list(/datum/material/brass=8000)
	icon_state = "ratvaranvil"
	anvilqualityadd = 2

/obj/structure/anvil/obtainable/ratvar/attackby(obj/item/I, mob/user)
	if(is_servant_of_ratvar(user))
		return ..()
	else
		to_chat(user, "<span class='neovgre'>KNPXWN, QNJCQNW!</span>")

/obj/structure/anvil/obtainable/narsie
	name = "runic anvil"
	desc = "An anvil made of a strange, runic metal."
	custom_materials = list(/datum/material/runedmetal=8000)
	icon = 'icons/obj/smith.dmi'
	icon_state = "evil"
	anvilqualityadd = 2

/obj/structure/anvil/obtainable/narsie/attackby(obj/item/I, mob/user)
	if(iscultist(user))
		return ..()
	else
		to_chat(user, "<span class='narsiesmall'>That is not yours to use!</span>")
