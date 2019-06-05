#define DRYING_TIME 5 * 60*10 //for 1 unit of depth in puddle (amount var)
#define BLOOD_SIZE_SMALL     1
#define BLOOD_SIZE_MEDIUM    2
#define BLOOD_SIZE_BIG       3
#define BLOOD_SIZE_NO_MERGE -1

var/global/list/image/splatter_cache=list()

/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's thick and gooey. Perhaps it's the chef's cooking?"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	blood_DNA = list()
	generic_filth = TRUE
	persistent = TRUE
	appearance_flags = NO_CLIENT_COLOR
	var/base_icon = 'icons/effects/blood.dmi'
	var/list/viruses = list()
	var/basecolor=BLOOD_COLOR_HUMAN // Color when wet.
	var/list/datum/disease2/disease/virus2 = list()
	var/amount = 5
	var/drytime
	var/dryname = "dried blood"
	var/drydesc = "It's dry and crusty. Someone is not doing their job."
	var/blood_size = BLOOD_SIZE_MEDIUM // A relative size; larger-sized blood will not override smaller-sized blood, except maybe at mapload.

/obj/effect/decal/cleanable/blood/clean_blood()
	fluorescent = 0
	if(invisibility != 100)
		set_invisibility(100)
		amount = 0
		STOP_PROCESSING(SSobj, src)
	..(ignore=1)

/obj/effect/decal/cleanable/blood/hide()
	return

/obj/effect/decal/cleanable/blood/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/blood/Initialize(mapload)
	. = ..()
	if(merge_with_blood(!mapload))
		return INITIALIZE_HINT_QDEL
	start_drying()

// Returns true if overriden and needs deletion. If the argument is false, we will merge into any existing blood.
/obj/effect/decal/cleanable/blood/proc/merge_with_blood(var/override = TRUE)
	. = FALSE
	if(blood_size == BLOOD_SIZE_NO_MERGE)
		return
	if(isturf(loc))
		for(var/obj/effect/decal/cleanable/blood/B in loc)
			if(B == src)
				continue
			if(B.blood_size == BLOOD_SIZE_NO_MERGE)
				continue
			if(override && blood_size >= B.blood_size)
				if (B.blood_DNA)
					blood_DNA |= B.blood_DNA.Copy()
				qdel(B)
				continue
			if(B.blood_DNA)
				B.blood_DNA |= blood_DNA.Copy()
			. = TRUE

/obj/effect/decal/cleanable/blood/proc/start_drying()
	drytime = world.time + DRYING_TIME * (amount+1)
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/Process()
	if(world.time > drytime)
		dry()

/obj/effect/decal/cleanable/blood/on_update_icon()
	if(basecolor == "rainbow") basecolor = get_random_colour(1)
	color = basecolor
	if(basecolor == SYNTH_BLOOD_COLOUR)
		SetName("oil")
		desc = "It's black and greasy."
	else
		SetName(initial(name))
		desc = initial(desc)

/obj/effect/decal/cleanable/blood/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1)
		return

	var/obj/item/organ/external/l_foot = perp.get_organ(BP_L_FOOT)
	var/obj/item/organ/external/r_foot = perp.get_organ(BP_R_FOOT)
	var/hasfeet = 1
	if((!l_foot || l_foot.is_stump()) && (!r_foot || r_foot.is_stump()))
		hasfeet = 0
	if(perp.shoes && !perp.buckled)//Adding blood to shoes
		var/obj/item/clothing/shoes/S = perp.shoes
		if(istype(S))
			S.blood_color = basecolor
			S.track_blood = max(amount,S.track_blood)
			if(!S.blood_overlay)
				S.add_blood_overlay()
			if(!S.blood_DNA)
				S.blood_DNA = list()
				S.blood_overlay.color = basecolor
				S.overlays += S.blood_overlay
			if(S.blood_overlay && S.blood_overlay.color != basecolor)
				S.blood_overlay.color = basecolor
				S.overlays.Cut()
				S.overlays += S.blood_overlay
			S.blood_DNA |= blood_DNA.Copy()

	else if (hasfeet)//Or feet
		perp.feet_blood_color = basecolor
		perp.track_blood = max(amount,perp.track_blood)
		if(!perp.feet_blood_DNA)
			perp.feet_blood_DNA = list()
		perp.feet_blood_DNA |= blood_DNA.Copy()
	else if (perp.buckled && istype(perp.buckled, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/W = perp.buckled
		W.bloodiness = 4

	perp.update_inv_shoes(1)
	amount--

/obj/effect/decal/cleanable/blood/proc/dry()
	name = dryname
	desc = drydesc
	color = adjust_brightness(color, -50)
	amount = 0
	STOP_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/update_icon()
	color = blood_DNA_to_color()


/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		if (user.gloves)
			return
		var/taken = rand(1,amount)
		amount -= taken
		to_chat(user, "<span class='notice'>You get some of \the [src] on your hands.</span>")
		if (!user.blood_DNA)
			user.blood_DNA = list()
		user.blood_DNA |= blood_DNA.Copy()
		user.bloody_hands = taken
		user.hand_blood_color = basecolor
		user.update_inv_gloves(1)

/obj/effect/decal/cleanable/blood/old
	name = "dried blood"
	desc = "Looks like it's been here a while. Eew."
	bloodiness = 0
	color = "#3a0505"

/obj/effect/decal/cleanable/blood/old/Initialize(mapload, list/datum/disease/diseases)
	..()
	icon_state += "-old"
	add_blood(list("Non-human DNA" = "A+"))

/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")
	amount = 2
	blood_size = BLOOD_SIZE_BIG


/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	icon_state = "gibbl5"
	layer = LOW_OBJ_LAYER
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	blood_size = BLOOD_SIZE_NO_MERGE
	var/gib_overlay = FALSE
	var/slimy_gibs = FALSE
	var/body_colors = "#ffffff"

/obj/effect/decal/cleanable/blood/gibs/proc/update_icon()
	var/image/giblets = new(base_icon, icon_state+ "-overlay", dir)
	var/image/giblets2 = new(base_icon, icon_state + "c-overlay", dir)
	giblets.color = body_colors

	var/icon/blood = new(base_icon,"[icon_state]",dir)
	if(basecolor == "rainbow") basecolor = get_random_colour(1)
	blood.Blend(basecolor,ICON_MULTIPLY)

	icon = blood
	overlays.Cut()
	if(gib_overlay)
		if(!slimy_gibs)
			add_overlay(giblets)
		else
			add_overlay(giblets)
			add_overlay(giblets2)

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/blood/gibs/Crossed(mob/living/L)
	if(istype(L) && has_gravity(loc))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.mind.assigned_role == "Detective") //Gumshoe perks yo
				playsound(loc, 'sound/effects/gib_step.ogg', 10, 1)
			else
				playsound(loc, 'sound/effects/gib_step.ogg', H.has_trait(TRAIT_LIGHT_STEP) ? 20 : 50, 1)
		else
			playsound(loc, 'sound/effects/gib_step.ogg', L.has_trait(TRAIT_LIGHT_STEP) ? 20 : 50, 1)
	. = ..()

/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(loc)
				b.basecolor = src.basecolor
				b.update_icon()
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/blood/gibs/start_drying()
	return

/obj/effect/decal/cleanable/blood/gibs/merge_with_blood()
	return FALSE

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = "Space Jesus, why didn't anyone clean this up?  It smells terrible."
	bloodiness = 0

/obj/effect/decal/cleanable/blood/gibs/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	setDir(pick(1,2,4,8))
	icon_state += "-old"
	add_blood(list("Non-human DNA" = "A+"))

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's gooey."
	gender = PLURAL
	icon_state = "1"
	random_icon_states = list("drip1","drip2","drip3","drip4","drip5")
	amount = 0
	var/list/drips
	blood_size = BLOOD_SIZE_SMALL

/obj/effect/decal/cleanable/blood/drip/Initialize()
	. = ..()
	drips = list(icon_state)

/obj/effect/decal/cleanable/blood/drip/can_bloodcrawl_in()
	return TRUE

/obj/effect/decal/cleanable/blood/gibs/human

/obj/effect/decal/cleanable/blood/gibs/human/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidgibs", 5)
	guts()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/human/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE
	slimy_gibs = TRUE

// Slime Gibs
/obj/effect/decal/cleanable/blood/gibs/slime
	desc = "They look gooey and gruesome."

/obj/effect/decal/cleanable/blood/gibs/slime/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidslimegibs", 5)
	update_icon()
	guts()

/obj/effect/decal/cleanable/blood/gibs/slime/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/synth
	desc = "They look sludgy and disgusting."

/obj/effect/decal/cleanable/blood/gibs/synth/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidsyntheticgibs", 5)
	update_icon()
	guts()

//IPCs
/obj/effect/decal/cleanable/blood/gibs/ipc
	desc = "They look sharp yet oozing."

/obj/effect/decal/cleanable/blood/gibs/ipc/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidoilgibs", 5)
	update_icon()
	guts()

/obj/effect/decal/cleanable/blood/gibs/ipc/guts()
	if(gib_overlay)
		var/mutable_appearance/gibz = mutable_appearance(icon, icon_state + "-ipcoverlay", color = blood_color, layer = -LOW_OBJ_LAYER)
		var/mutable_appearance/gibz2 = mutable_appearance(icon, icon_state + "c-ipcoverlay", color = body_colors, layer = -LOW_OBJ_LAYER)
		if(!slimy_gibs)
			gibz.appearance_flags = RESET_COLOR
			add_overlay(gibz)
		else
			gibz.appearance_flags = RESET_COLOR
			add_overlay(gibz)
			add_overlay(gibz2)

/obj/effect/decal/cleanable/blood/gibs/ipc/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/synth
	desc = "They look sludgy and disgusting."

/obj/effect/decal/cleanable/blood/gibs/synth/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidsyntheticgibs", 5)
	update_icon()
	guts()

#undef BLOOD_SIZE_SMALL
#undef BLOOD_SIZE_MEDIUM
#undef BLOOD_SIZE_BIG
#undef BLOOD_SIZE_NO_MERGE