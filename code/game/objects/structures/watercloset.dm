/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 0
	var/open = FALSE			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie
	var/buildstacktype = /obj/item/stack/sheet/metal //they're metal now, shut up
	var/buildstackamount = 1

/obj/structure/toilet/Initialize()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(swirlie)
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src.loc, "swing_hit", 25, 1)
		swirlie.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie]'s head!</span>", "<span class='userdanger'>[user] slams the toilet seat onto your head!</span>", "<span class='italics'>You hear reverberating porcelain.</span>")
		swirlie.adjustBruteLoss(5)

	else if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		user.changeNext_move(CLICK_CD_MELEE)
		var/mob/living/GM = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(GM.loc != get_turf(src))
				to_chat(user, "<span class='warning'>[GM] needs to be on [src]!</span>")
				return
			if(!swirlie)
				if(open)
					GM.visible_message("<span class='danger'>[user] starts to give [GM] a swirlie!</span>", "<span class='userdanger'>[user] starts to give you a swirlie...</span>")
					swirlie = GM
					if(do_after(user, 30, 0, target = src))
						GM.visible_message("<span class='danger'>[user] gives [GM] a swirlie!</span>", "<span class='userdanger'>[user] gives you a swirlie!</span>", "<span class='italics'>You hear a toilet flushing.</span>")
						if(iscarbon(GM))
							var/mob/living/carbon/C = GM
							if(!C.internal)
								C.adjustOxyLoss(5)
						else
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
					GM.visible_message("<span class='danger'>[user] slams [GM.name] into [src]!</span>", "<span class='userdanger'>[user] slams you into [src]!</span>")
					GM.adjustBruteLoss(5)
		else
			to_chat(user, "<span class='warning'>You need a tighter grip!</span>")

	else if(cistern && !open && user.CanReach(src))
		if(!contents.len)
			to_chat(user, "<span class='notice'>The cistern is empty.</span>")
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(drop_location())
			to_chat(user, "<span class='notice'>You find [I] in the cistern.</span>")
			w_items = max(w_items - I.w_class, 0)
	else
		open = !open
		update_icon()

/obj/structure/toilet/update_icon_state()
	icon_state = "toilet[open][cistern]"

/obj/structure/toilet/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
		else
			for(var/i in custom_materials)
				var/datum/material/M = i
				new M.sheet_type(loc, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))
	..()

/obj/structure/toilet/attackby(obj/item/I, mob/living/user, params)
	add_fingerprint(user)
	if(istype(I, /obj/item/crowbar))
		to_chat(user, "<span class='notice'>You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]...</span>")
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(I.use_tool(src, user, 30))
			user.visible_message("[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!", "<span class='notice'>You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!</span>", "<span class='italics'>You hear grinding porcelain.</span>")
			cistern = !cistern
			update_icon()
	else if(I.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		I.play_tool_sound(src)
		deconstruct()
	else if(cistern)
		if(user.a_intent != INTENT_HARM)
			if(I.w_class > WEIGHT_CLASS_NORMAL)
				to_chat(user, "<span class='warning'>[I] does not fit!</span>")
				return
			if(w_items + I.w_class > WEIGHT_CLASS_HUGE)
				to_chat(user, "<span class='warning'>The cistern is full!</span>")
				return
			if(!user.transferItemToLoc(I, src))
				to_chat(user, "<span class='warning'>\The [I] is stuck to your hand, you cannot put it in the cistern!</span>")
				return
			w_items += I.w_class
			to_chat(user, "<span class='notice'>You carefully place [I] into the cistern.</span>")

	if(istype(I, /obj/item/reagent_containers/food/snacks/cube))
		var/obj/item/reagent_containers/food/snacks/cube/cube = I
		cube.Expand()
		return
	else if(istype(I, /obj/item/reagent_containers))
		if (!open)
			return
		var/obj/item/reagent_containers/RG = I
		RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		to_chat(user, "<span class='notice'>You fill [RG] from [src]. Gross.</span>")
	else
		return ..()

/obj/structure/toilet/secret
	var/obj/item/secret
	var/secret_type = null

/obj/structure/toilet/secret/Initialize(mapload)
	. = ..()
	if (secret_type)
		secret = new secret_type(src)
		secret.desc += "" //In case you want to add something to the item that spawns
		contents += secret

/obj/structure/toilet/secret/LateInitialize()
	. = ..()
	w_items = 0 //recalculate total weight thanks to the secret.
	for(var/obj/item/I in contents)
		w_items += I.w_class

/obj/structure/toilet/secret/low_loot
	secret_type = /obj/effect/spawner/lootdrop/low_loot_toilet

/obj/structure/toilet/secret/high_loot
	secret_type = /obj/effect/spawner/lootdrop/high_loot_toilet

/obj/structure/toilet/secret/prison
	secret_type = /obj/effect/spawner/lootdrop/prison_loot_toilet

/obj/structure/toilet/greyscale

	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR
	buildstacktype = null

/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal. Comes complete with experimental urinal cake."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	var/exposed = 0 // can you currently put an item inside
	var/obj/item/hiddenitem = null // what's in the urinal

/obj/structure/urinal/New()
	..()
	hiddenitem = new /obj/item/reagent_containers/food/urinalcake

/obj/structure/urinal/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		var/mob/living/GM = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(GM.loc != get_turf(src))
				to_chat(user, "<span class='notice'>[GM.name] needs to be on [src].</span>")
				return
			user.changeNext_move(CLICK_CD_MELEE)
			user.visible_message("<span class='danger'>[user] slams [GM] into [src]!</span>", "<span class='danger'>You slam [GM] into [src]!</span>")
			GM.adjustBruteLoss(8)
		else
			to_chat(user, "<span class='warning'>You need a tighter grip!</span>")

	else if(exposed)
		if(!hiddenitem)
			to_chat(user, "<span class='notice'>There is nothing in the drain holder.</span>")
		else
			if(ishuman(user))
				user.put_in_hands(hiddenitem)
			else
				hiddenitem.forceMove(get_turf(src))
			to_chat(user, "<span class='notice'>You fish [hiddenitem] out of the drain enclosure.</span>")
			hiddenitem = null
	else
		..()

/obj/structure/urinal/attackby(obj/item/I, mob/living/user, params)
	if(exposed)
		if (hiddenitem)
			to_chat(user, "<span class='warning'>There is already something in the drain enclosure.</span>")
			return
		if(I.w_class > 1)
			to_chat(user, "<span class='warning'>[I] is too large for the drain enclosure.</span>")
			return
		if(!user.transferItemToLoc(I, src))
			to_chat(user, "<span class='warning'>\[I] is stuck to your hand, you cannot put it in the drain enclosure!</span>")
			return
		hiddenitem = I
		to_chat(user, "<span class='notice'>You place [I] into the drain enclosure.</span>")
	else
		return ..()

/obj/structure/urinal/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	to_chat(user, "<span class='notice'>You start to [exposed ? "screw the cap back into place" : "unscrew the cap to the drain protector"]...</span>")
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
	if(I.use_tool(src, user, 20))
		user.visible_message("[user] [exposed ? "screws the cap back into place" : "unscrew the cap to the drain protector"]!",
			"<span class='notice'>You [exposed ? "screw the cap back into place" : "unscrew the cap on the drain"]!</span>",
			"<span class='italics'>You hear metal and squishing noises.</span>")
		exposed = !exposed
	return TRUE

/obj/item/reagent_containers/food/urinalcake
	name = "urinal cake"
	desc = "The noble urinal cake, protecting the station's pipes from the station's pee. Do not eat."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "urinalcake"
	w_class = WEIGHT_CLASS_TINY
	list_reagents = list(/datum/reagent/chlorine = 3, /datum/reagent/ammonia = 1)

/obj/item/reagent_containers/food/urinalcake/attack_self(mob/living/user)
	user.visible_message("<span class='notice'>[user] squishes [src]!</span>", "<span class='notice'>You squish [src].</span>", "<i>You hear a squish.</i>")
	icon_state = "urinalcake_squish"
	addtimer(VARSET_CALLBACK(src, icon_state, "urinalcake"), 8)

/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2550s by the Nanotrasen Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	use_power = NO_POWER_USE
	var/on = FALSE
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/datum/looping_sound/showering/soundloop

/obj/machinery/shower/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/obj/machinery/shower/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = FLY_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/machinery/shower/interact(mob/M)
	on = !on
	update_icon()
	handle_mist()
	add_fingerprint(M)
	if(on)
		START_PROCESSING(SSmachines, src)
		soundloop.start()
		wash_turf()
		for(var/atom/movable/G in loc)
			SEND_SIGNAL(G, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
			if(isliving(G))
				var/mob/living/L = G
				wash_mob(L)
			else if(isobj(G)) // Skip the light objects
				wash_obj(G)
	else
		soundloop.stop()
		if(isopenturf(loc))
			var/turf/open/tile = loc
			tile.MakeSlippery(TURF_WET_WATER, min_wet_time = 5 SECONDS, wet_time_to_add = 1 SECONDS)

/obj/machinery/shower/attackby(obj/item/I, mob/user, params)
	if(I.type == /obj/item/analyzer)
		to_chat(user, "<span class='notice'>The water temperature seems to be [watertemp].</span>")
	else
		return ..()

/obj/machinery/shower/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, "<span class='notice'>You begin to adjust the temperature valve with \the [I]...</span>")
	if(I.use_tool(src, user, 50))
		switch(watertemp)
			if("normal")
				watertemp = "freezing"
			if("freezing")
				watertemp = "boiling"
			if("boiling")
				watertemp = "normal"
		user.visible_message("<span class='notice'>[user] adjusts the shower with \the [I].</span>", "<span class='notice'>You adjust the shower with \the [I] to [watertemp] temperature.</span>")
		log_game("[key_name(user)] has wrenched a shower to [watertemp] at ([x],[y],[z])")
		add_hiddenprint(user)
	return TRUE

/obj/machinery/shower/update_overlays()
	. = ..()
	if(on)
		. += mutable_appearance('icons/obj/watercloset.dmi', "water", ABOVE_MOB_LAYER)

/obj/machinery/shower/proc/handle_mist()
	// If there is no mist, and the shower was turned on (on a non-freezing temp): make mist in 5 seconds
	// If there was already mist, and the shower was turned off (or made cold): remove the existing mist in 25 sec
	var/obj/effect/mist/mist = locate() in loc
	if(!mist && on && watertemp != "freezing")
		addtimer(CALLBACK(src, .proc/make_mist), 5 SECONDS)

	if(mist && (!on || watertemp == "freezing"))
		addtimer(CALLBACK(src, .proc/clear_mist), 25 SECONDS)

/obj/machinery/shower/proc/make_mist()
	var/obj/effect/mist/mist = locate() in loc
	if(!mist && on && watertemp != "freezing")
		new /obj/effect/mist(loc)

/obj/machinery/shower/proc/clear_mist()
	var/obj/effect/mist/mist = locate() in loc
	if(mist && (!on || watertemp == "freezing"))
		qdel(mist)

/obj/machinery/shower/Crossed(atom/movable/AM)
	..()
	if(on)
		if(isliving(AM))
			var/mob/living/L = AM
			if(wash_mob(L)) //it's a carbon mob.
				var/mob/living/carbon/C = L
				C.slip(80,null,NO_SLIP_WHEN_WALKING)
		else if(isobj(AM))
			wash_obj(AM)

/obj/machinery/shower/proc/wash_obj(obj/O)
	. = SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
	. = O.clean_blood()
	O.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	if(isitem(O))
		var/obj/item/I = O
		I.acid_level = 0
		I.extinguish()

/obj/machinery/shower/proc/wash_turf()
	if(isturf(loc))
		var/turf/tile = loc
		tile.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
		tile.clean_blood()
		SEND_SIGNAL(tile, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
		for(var/obj/effect/E in tile)
			if(is_cleanable(E))
				qdel(E)

/obj/machinery/shower/proc/wash_mob(mob/living/L)
	SEND_SIGNAL(L, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
	L.wash_cream()
	L.ExtinguishMob()
	L.adjust_fire_stacks(-20) //Douse ourselves with water to avoid fire more easily
	L.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "shower", /datum/mood_event/nice_shower)
	if(iscarbon(L))
		var/mob/living/carbon/M = L
		. = TRUE
		check_heat(M)
		for(var/obj/item/I in M.held_items)
			wash_obj(I)
		if(M.back)
			if(wash_obj(M.back))
				M.update_inv_back(0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/washgloves = TRUE
			var/washshoes = TRUE
			var/washmask = TRUE
			var/washears = TRUE
			var/washglasses = TRUE

			if(H.wear_suit)
				washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
				washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

			if(H.head)
				washmask = !(H.head.flags_inv & HIDEMASK)
				washglasses = !(H.head.flags_inv & HIDEEYES)
				washears = !(H.head.flags_inv & HIDEEARS)

			if(H.wear_mask)
				if (washears)
					washears = !(H.wear_mask.flags_inv & HIDEEARS)
				if (washglasses)
					washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

			if(H.head && wash_obj(H.head))
				H.update_inv_head()
			if(H.wear_suit && wash_obj(H.wear_suit))
				H.update_inv_wear_suit()
			else if(H.w_uniform && wash_obj(H.w_uniform))
				H.update_inv_w_uniform()
			if(washgloves)
				H.clean_blood()
				SEND_SIGNAL(H, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
			if(H.shoes && washshoes && wash_obj(H.shoes))
				H.update_inv_shoes()
			if(H.wear_mask && washmask && wash_obj(H.wear_mask))
				H.update_inv_wear_mask()
			else
				H.lip_style = null
				H.update_body()
			if(H.glasses && washglasses && wash_obj(H.glasses))
				H.update_inv_glasses()
			if(H.ears && washears && wash_obj(H.ears))
				H.update_inv_ears()
			if(H.belt && wash_obj(H.belt))
				H.update_inv_belt()
		else
			if(M.wear_mask && wash_obj(M.wear_mask))
				M.update_inv_wear_mask(0)
			M.clean_blood()
			SEND_SIGNAL(M, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
	else
		L.clean_blood()
		SEND_SIGNAL(L, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)

/obj/machinery/shower/proc/contamination_cleanse(atom/movable/thing)
	var/datum/component/radioactive/healthy_green_glow = thing.GetComponent(/datum/component/radioactive)
	if(!healthy_green_glow || QDELETED(healthy_green_glow))
		return
	var/strength = healthy_green_glow.strength
	if(strength <= RAD_BACKGROUND_RADIATION)
		qdel(healthy_green_glow)
		return
	healthy_green_glow.strength = max(strength-1, 0)

/obj/machinery/shower/process()
	if(on)
		wash_turf()
		for(var/atom/movable/AM in loc)
			if(isliving(AM))
				wash_mob(AM)
			else if(isobj(AM))
				wash_obj(AM)
			contamination_cleanse(AM)
	else
		return PROCESS_KILL

/obj/machinery/shower/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/metal (loc, 3)
	qdel(src)

/obj/machinery/shower/proc/check_heat(mob/living/carbon/C)
	if(watertemp == "freezing")
		C.adjust_bodytemperature(-80, 80)
		to_chat(C, "<span class='warning'>The water is freezing!</span>")
	else if(watertemp == "boiling")
		C.adjust_bodytemperature(35, 0, 500)
		C.adjustFireLoss(5)
		to_chat(C, "<span class='danger'>The water is searing!</span>")

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = FALSE 	//Something's being washed at the moment
	var/dispensedreagent = /datum/reagent/water // for whenever plumbing happens
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 1

/obj/structure/sink/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!user || !istype(user))
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, "<span class='notice'>Someone's already washing here.</span>")
		return
	var/selected_area = parse_zone(user.zone_selected)
	var/washing_face = 0
	if(selected_area in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES))
		washing_face = 1
	user.visible_message("<span class='notice'>[user] starts washing [user.p_their()] [washing_face ? "face" : "hands"]...</span>", \
						"<span class='notice'>You start washing your [washing_face ? "face" : "hands"]...</span>")
	busy = TRUE

	if(!do_after(user, 40, target = src))
		busy = FALSE
		return

	busy = FALSE

	user.visible_message("<span class='notice'>[user] washes [user.p_their()] [washing_face ? "face" : "hands"] using [src].</span>", \
						"<span class='notice'>You wash your [washing_face ? "face" : "hands"] using [src].</span>")
	if(washing_face)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.lip_style = null //Washes off lipstick
			H.lip_color = initial(H.lip_color)
			H.wash_cream()
			H.regenerate_icons()
		user.drowsyness = max(user.drowsyness - rand(2,3), 0) //Washing your face wakes you up if you're falling asleep
	else
		SEND_SIGNAL(user, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
		user.clean_blood()

/obj/structure/sink/attackby(obj/item/O, mob/living/user, params)
	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here!</span>")
		return

	if(istype(O, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RG = O
		if(RG.is_refillable())
			if(!RG.reagents.holder_full())
				RG.reagents.add_reagent(dispensedreagent, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
				to_chat(user, "<span class='notice'>You fill [RG] from [src].</span>")
				return TRUE
			to_chat(user, "<span class='notice'>\The [RG] is full.</span>")
			return FALSE

	if(istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.cell)
			if(B.cell.charge > 0 && B.turned_on)
				flick("baton_active", src)
				var/stunforce = B.stamforce
				user.DefaultCombatKnockdown(stunforce * 2)
				user.stuttering = stunforce/20
				B.deductcharge(B.hitcost)
				user.visible_message("<span class='warning'>[user] shocks [user.p_them()]self while attempting to wash the active [B.name]!</span>", \
									"<span class='userdanger'>You unwisely attempt to wash [B] while it's still on.</span>")
				playsound(src, "sparks", 50, 1)
				return

	if(istype(O, /obj/item/mop))
		O.reagents.add_reagent(dispensedreagent, 5)
		to_chat(user, "<span class='notice'>You wet [O] in [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

	if(O.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		O.play_tool_sound(src)
		deconstruct()
		return

	if(istype(O, /obj/item/stack/medical/gauze))
		var/obj/item/stack/medical/gauze/G = O
		new /obj/item/reagent_containers/rag(src.loc)
		to_chat(user, "<span class='notice'>You tear off a strip of gauze and make a rag.</span>")
		G.use(1)
		return

	if(!istype(O))
		return
	if(O.item_flags & ABSTRACT) //Abstract items like grabs won't wash. No-drop items will though because it's still technically an item in your hand.
		return

	if(user.a_intent != INTENT_HARM)
		to_chat(user, "<span class='notice'>You start washing [O]...</span>")
		busy = TRUE
		if(!do_after(user, 40, target = src))
			busy = FALSE
			return 1
		busy = FALSE
		SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
		O.clean_blood()
		O.acid_level = 0
		create_reagents(5)
		reagents.add_reagent(dispensedreagent, 5)
		reagents.reaction(O, TOUCH)
		user.visible_message("<span class='notice'>[user] washes [O] using [src].</span>", \
							"<span class='notice'>You wash [O] using [src].</span>")
		return 1
	else
		return ..()

/obj/structure/sink/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		drop_materials()
	..()

/obj/structure/sink/proc/drop_materials()
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	else
		for(var/i in custom_materials)
			var/datum/material/M = i
			new M.sheet_type(loc, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/sink/well
	name = "well"
	desc = "A well, used to get water from an underground reservoir."
	icon_state = "well"

//The making of the well
/obj/structure/well_foundation
	name = "well foundation"
	desc = "A small patch of dirt, ready for a well to be made over it. Just use a shovel!"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "well_1"
	density = FALSE
	anchored = TRUE
	max_integrity = 1000
	var/steps = 0

/obj/structure/well_foundation/attackby(obj/item/S, mob/user, params)
	if(steps == 0 && S.tool_behaviour == TOOL_SHOVEL)
		S.use_tool(src, user, 80, volume=100)
		steps = 1
		desc = "A deep patch of dirt, ready for a well to be made over it. Just add some sandstone!"
		icon_state = "well_1"
		return TRUE
	if(steps == 1 && istype(S, /obj/item/stack/sheet/mineral/sandstone))
		if(S.use(15))
			steps = 2
			desc = "A patch of dirt and bricks. Just add some more sandstone!"
			icon_state = "well_2"
			return TRUE
		else
			to_chat(user, "<span class='warning'>You need at least fifteen pieces of sandstone!</span>")
			return
	if(steps == 2 && istype(S, /obj/item/stack/sheet/mineral/sandstone))
		if(S.use(25))
			steps = 3
			desc = "A large well foundation ready to be dug out. Just use a shovel!"
			icon_state = "well_3"
			return TRUE
		else
			to_chat(user, "<span class='warning'>You need at least tweenty-five pieces of sandstone!</span>")
			return
	if(steps == 3 && S.tool_behaviour == TOOL_SHOVEL)
		S.use_tool(src, user, 80, volume=100)
		steps = 4
		desc = "A deep patch of dirt, needs something to hold a bucket and rope. Just add some wood planks!"
		icon_state = "well_3"
		return TRUE
	if(steps == 4 && istype(S, /obj/item/stack/sheet/mineral/wood))
		if(S.use(3))
			steps = 5
			desc = "A dug out well, A dug out well with out rope. Just add some cloth!"
			icon_state = "well_4"
			return TRUE
		else
			to_chat(user, "<span class='warning'>You need at least three planks!</span>")
			return
	if(steps == 5 && istype(S, /obj/item/stack/sheet/cloth))
		if(S.use(2))
			steps = 6
			desc = "A dug out well with a rope. Just add a wooden bucket!"
			icon_state = "well_5"
			return TRUE
		else
			to_chat(user, "<span class='warning'>You need at least two pieces of cloth!</span>")
			return
	if(steps == 6 && istype(S, /obj/item/reagent_containers/glass/bucket/wood))
		new /obj/structure/sink/well(loc)
		qdel(S)
		qdel(src)
		return
	else
		return ..()

/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	desc = "A puddle used for washing one's hands and face."
	icon_state = "puddle"
	resistance_flags = UNACIDABLE

/obj/structure/sink/greyscale
	icon_state = "sink_greyscale"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR
	buildstacktype = null

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/sink/puddle/attack_hand(mob/M)
	icon_state = "puddle-splash"
	. = ..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O, mob/user, params)
	icon_state = "puddle-splash"
	. = ..()
	icon_state = "puddle"

/obj/structure/sink/puddle/deconstruct(disassembled = TRUE)
	qdel(src)

/obj/structure/sink/greyscale
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR
	buildstacktype = null

//Shower Curtains//
//Defines used are pre-existing in layers.dm//

/obj/structure/curtain
	name = "curtain"
	desc = "Contains less than 1% mercury."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "open"
	color = "#ACD1E9" //Default color, didn't bother hardcoding other colors, mappers can and should easily change it.
	alpha = 200 //Mappers can also just set this to 255 if they want curtains that can't be seen through <- No longer necessary unless you don't want to see through it no matter what.
	layer = SIGN_LAYER
	anchored = TRUE
	max_integrity = 25 //This makes cloth shower curtains as durable as a directional glass window. 300 integrity buildable shower curtains as a cover mechanic is a meta I don't want to see.
	opacity = 0
	density = FALSE
	var/open = TRUE

/obj/structure/curtain/proc/toggle()
	open = !open
	update_icon()

/obj/structure/curtain/update_icon_state()
	if(!open)
		icon_state = "closed"
		layer = WALL_OBJ_LAYER
		density = TRUE
		open = FALSE
		opacity = TRUE

	else
		icon_state = "open"
		layer = SIGN_LAYER
		density = FALSE
		open = TRUE
		opacity = FALSE

/obj/structure/curtain/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/toy/crayon))
		color = input(user,"","Choose Color",color) as color
	else
		return ..()

/obj/structure/curtain/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 50)
	return TRUE

/obj/structure/curtain/wirecutter_act(mob/living/user, obj/item/I)
	if(anchored)
		return TRUE

	user.visible_message("<span class='warning'>[user] cuts apart [src].</span>",
		"<span class='notice'>You start to cut apart [src].</span>", "You hear cutting.")
	if(I.use_tool(src, user, 50, volume=100) && !anchored)
		to_chat(user, "<span class='notice'>You cut apart [src].</span>")
		deconstruct()

	return TRUE

/obj/structure/curtain/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	playsound(loc, 'sound/effects/curtain.ogg', 50, 1)
	toggle()

/obj/structure/curtain/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/cloth (loc, 2)
	new /obj/item/stack/sheet/plastic (loc, 2)
	new /obj/item/stack/rods (loc, 1)
	qdel(src)

/obj/structure/curtain/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, 1)
