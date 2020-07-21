/obj/structure/chair
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair"
	anchored = TRUE
	can_buckle = 1
	buckle_lying = 0 //you sit in a chair, not lay
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 0.1
	custom_materials = list(/datum/material/iron = 2000)
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 1
	var/item_chair = /obj/item/chair // if null it can't be picked up
	layer = OBJ_LAYER

/obj/structure/chair/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It's held together by a couple of <b>bolts</b>.</span>"
	if(!has_buckled_mobs())
		. += "<span class='notice'>Drag your sprite to sit in it.</span>"

/obj/structure/chair/Initialize()
	. = ..()
	if(!anchored)	//why would you put these on the shuttle?
		addtimer(CALLBACK(src, .proc/RemoveFromLatejoin), 0)

/obj/structure/chair/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, .proc/can_user_rotate),CALLBACK(src, .proc/can_be_rotated),null)

/obj/structure/chair/proc/can_be_rotated(mob/user)
	return TRUE

/obj/structure/chair/proc/can_user_rotate(mob/user)
	var/mob/living/L = user

	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			return FALSE
		else
			return TRUE
	else if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE

/obj/structure/chair/Destroy()
	RemoveFromLatejoin()
	return ..()

/obj/structure/chair/proc/RemoveFromLatejoin()
	SSjob.latejoin_trackers -= src	//These may be here due to the arrivals shuttle

/obj/structure/chair/deconstruct()
	// If we have materials, and don't have the NOCONSTRUCT flag
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
		else
			for(var/i in custom_materials)
				var/datum/material/M = i
				new M.sheet_type(loc, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))
	..()

/obj/structure/chair/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/chair/narsie_act()
	var/obj/structure/chair/wood/W = new/obj/structure/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/structure/chair/ratvar_act()
	var/obj/structure/chair/brass/B = new(get_turf(src))
	B.setDir(dir)
	qdel(src)

/obj/structure/chair/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wrench) && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct()
	else if(istype(W, /obj/item/assembly/shock_kit))
		if(!user.temporarilyRemoveItemFromInventory(W))
			return
		var/obj/item/assembly/shock_kit/SK = W
		var/obj/structure/chair/e_chair/E = new /obj/structure/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
		E.setDir(dir)
		E.part = SK
		SK.forceMove(E)
		SK.master = E
		qdel(src)
	else
		return ..()

/obj/structure/chair/alt_attack_hand(mob/living/user)
	if(Adjacent(user) && istype(user))
		if(!item_chair || !user.can_hold_items() || !has_buckled_mobs() || buckled_mobs.len > 1 || dir != user.dir || flags_1 & NODECONSTRUCT_1)
			return TRUE
		if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			to_chat(user, "<span class='warning'>You can't do that right now!</span>")
			return TRUE
		if(IS_STAMCRIT(user))
			to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")
			return TRUE
		var/mob/living/poordude = buckled_mobs[1]
		if(!istype(poordude))
			return TRUE
		user.visible_message("<span class='notice'>[user] pulls [src] out from under [poordude].</span>", "<span class='notice'>You pull [src] out from under [poordude].</span>")
		var/obj/item/chair/C = new item_chair(loc)
		C.set_custom_materials(custom_materials)
		TransferComponents(C)
		user.put_in_hands(C)
		poordude.DefaultCombatKnockdown(20)//rip in peace
		user.adjustStaminaLoss(5)
		unbuckle_all_mobs(TRUE)
		qdel(src)
		return TRUE

/obj/structure/chair/attack_tk(mob/user)
	if(!anchored || has_buckled_mobs() || !isturf(user.loc))
		..()
	else
		setDir(turn(dir,-90))

/obj/structure/chair/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/chair/proc/handle_layer()
	if(has_buckled_mobs() && dir == NORTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = OBJ_LAYER

/obj/structure/chair/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()

/obj/structure/chair/post_unbuckle_mob()
	. = ..()
	handle_layer()

/obj/structure/chair/setDir(newdir)
	..()
	handle_rotation(newdir)

// Chair types


///Material chair
/obj/structure/chair/greyscale
	icon_state = "chair_greyscale"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	item_chair = /obj/item/chair/greyscale
	buildstacktype = null //Custom mats handle this

/obj/structure/chair/wood
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3
	item_chair = /obj/item/chair/wood

/obj/structure/chair/wood/narsie_act()
	return

/obj/structure/chair/wood/normal //Kept for map compatibility


/obj/structure/chair/wood/wings
	icon_state = "wooden_chair_wings"
	item_chair = /obj/item/chair/wood/wings

/obj/structure/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."
	icon_state = "comfychair"
	color = rgb(255,255,255)
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 2
	item_chair = null
	var/mutable_appearance/armrest

/obj/structure/chair/comfy/Initialize()
	armrest = GetArmrest()
	armrest.layer = ABOVE_MOB_LAYER
	return ..()

/obj/structure/chair/comfy/proc/GetArmrest()
	return mutable_appearance('icons/obj/chairs.dmi', "comfychair_armrest")

/obj/structure/chair/comfy/Destroy()
	QDEL_NULL(armrest)
	return ..()

/obj/structure/chair/comfy/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()

/obj/structure/chair/comfy/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/chair/comfy/post_unbuckle_mob()
	. = ..()
	update_armrest()

/obj/structure/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/chair/comfy/green
	color = rgb(81,173,106)

/obj/structure/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/chair/comfy/purple
	color = rgb(255,50,230)

/obj/structure/chair/comfy/plywood
	name = "plywood chair"
	desc = "A relaxing plywood chair."
	icon_state = "plywood_chair"
	anchored = FALSE
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 4

/obj/structure/chair/comfy/plywood/GetArmrest()
	return mutable_appearance('icons/obj/chairs.dmi', "plywood_chair_armrest")

/obj/structure/chair/comfy/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a more sturdy looking buckling system, for smoother flights."
	icon_state = "shuttle_chair"

/obj/structure/chair/comfy/shuttle/GetArmrest()
	return mutable_appearance('icons/obj/chairs.dmi', "shuttle_chair_armrest")

/obj/structure/chair/office
	anchored = FALSE
	buildstackamount = 5
	item_chair = null


/obj/structure/chair/office/Moved()
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, 1)

/obj/structure/chair/office/light
	icon_state = "officechair_white"

/obj/structure/chair/office/dark
	icon_state = "officechair_dark"

//Stool

/obj/structure/chair/stool
	name = "stool"
	desc = "Apply butt."
	icon_state = "stool"
	can_buckle = 0
	buildstackamount = 1
	item_chair = /obj/item/chair/stool

/obj/structure/chair/stool/narsie_act()
	return

/obj/structure/chair/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!item_chair || !usr.can_hold_items() || has_buckled_mobs() || src.flags_1 & NODECONSTRUCT_1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE, ismonkey(usr)))
			return
		usr.visible_message("<span class='notice'>[usr] grabs \the [src.name].</span>", "<span class='notice'>You grab \the [src.name].</span>")
		var/obj/item/C = new item_chair(loc)
		C.set_custom_materials(custom_materials)
		TransferComponents(C)
		usr.put_in_hands(C)
		qdel(src)

/obj/structure/chair/stool/bar
	name = "bar stool"
	desc = "It has some unsavory stains on it..."
	icon_state = "bar"
	item_chair = /obj/item/chair/stool/bar

/obj/item/chair
	name = "chair"
	desc = "Bar brawl essential."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair_toppled"
	item_state = "chair"
	lefthand_file = 'icons/mob/inhands/misc/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 8
	throwforce = 10
	throw_range = 3
	hitsound = 'sound/items/trayhit1.ogg'
	block_chance = 50
	custom_materials = list(/datum/material/iron = 2000)
	var/break_chance = 5 //Likely hood of smashing the chair.
	var/obj/structure/chair/origin_type = /obj/structure/chair

/obj/item/chair/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins hitting [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(src,hitsound,50,1)
	return BRUTELOSS

/obj/item/chair/narsie_act()
	var/obj/item/chair/wood/W = new/obj/item/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/item/chair/attack_self(mob/user)
	plant(user)

/obj/item/chair/proc/plant(mob/user)
	for(var/obj/A in get_turf(loc))
		if(istype(A, /obj/structure/chair))
			to_chat(user, "<span class='danger'>There is already a chair here.</span>")
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, "<span class='danger'>There is already something here.</span>")
			return

	user.visible_message("<span class='notice'>[user] rights \the [src.name].</span>", "<span class='notice'>You right \the [name].</span>")
	var/obj/structure/chair/C = new origin_type(get_turf(loc))
	C.set_custom_materials(custom_materials)
	TransferComponents(C)
	C.setDir(dir)
	qdel(src)

/obj/item/chair/proc/smash(mob/living/user)
	var/stack_type = initial(origin_type.buildstacktype)
	if(!stack_type)
		return
	var/remaining_mats = initial(origin_type.buildstackamount)
	remaining_mats-- //Part of the chair was rendered completely unusable. It magically dissapears. Maybe make some dirt?
	if(remaining_mats)
		for(var/M=1 to remaining_mats)
			new stack_type(get_turf(loc))
	qdel(src)

/obj/item/chair/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!(attack_type & ATTACK_TYPE_UNARMED))
		return NONE
	return ..()

/obj/item/chair/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(prob(break_chance))
		user.visible_message("<span class='danger'>[user] smashes [src] to pieces against [target]</span>")
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(C.health < C.maxHealth*0.5)
				C.DefaultCombatKnockdown(20)
		smash(user)

/obj/item/chair/greyscale
	icon_state = "chair_greyscale_toppled"
	item_state = "chair_greyscale"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	origin_type = /obj/structure/chair/greyscale

/obj/item/chair/stool
	name = "stool"
	icon_state = "stool_toppled"
	item_state = "stool"
	origin_type = /obj/structure/chair/stool
	break_chance = 0 //It's too sturdy.

/obj/item/chair/stool/bar
	name = "bar stool"
	icon_state = "bar_toppled"
	item_state = "stool_bar"
	origin_type = /obj/structure/chair/stool/bar

//////////////////////////
//Alien(Disco) Stools!////
//////////////////////////

/obj/structure/chair/stool/alien
	name = "alien stool"
	desc = "A hard stool made of advanced alien alloy."
	icon_state = "stoolalien"
	icon = 'icons/obj/abductor.dmi'
	item_chair = /obj/item/chair/stool/alien
	buildstacktype = /obj/item/stack/sheet/mineral/abductor
	buildstackamount = 1

/obj/structure/chair/stool/bar/alien
	name = "alien bar stool"
	desc = "A hard bar stool made of advanced alien alloy."
	icon_state = "baralien"
	icon = 'icons/obj/abductor.dmi'
	item_chair = /obj/item/chair/stool/bar/alien
	buildstacktype = /obj/item/stack/sheet/mineral/abductor
	buildstackamount = 1

/obj/item/chair/stool/alien
	name = "stool"
	icon_state = "stoolalien_toppled"
	item_state = "stoolalien"
	icon = 'icons/obj/abductor.dmi'
	origin_type = /obj/structure/chair/stool/alien
	break_chance = 0 //It's too sturdy.

/obj/item/chair/stool/bar/alien
	name = "bar stool"
	icon_state = "baralien_toppled"
	item_state = "baralien"
	icon = 'icons/obj/abductor.dmi'
	origin_type = /obj/structure/chair/stool/bar/alien

//////////////////////////
//Brass & Bronze stools!//
//////////////////////////

/obj/structure/chair/stool/bar/brass
	name = "brass bar stool"
	desc = "A brass bar stool with red silk for a pillow."
	icon_state = "barbrass"
	item_chair = /obj/item/chair/stool/bar/brass
	buildstacktype = /obj/item/stack/tile/brass
	buildstackamount = 1

/obj/structure/chair/stool/bar/bronze
	name = "bronze bar stool"
	desc = "A bronze bar stool with red silk for a pillow."
	icon_state = "barbrass"
	item_chair = /obj/item/chair/stool/bar/bronze
	buildstacktype = /obj/item/stack/tile/bronze
	buildstackamount = 1

/obj/structure/chair/stool/brass
	name = "brass stool"
	desc = "A brass stool with a silk top for comfort."
	icon_state = "stoolbrass"
	item_chair = /obj/item/chair/stool/brass
	buildstacktype = /obj/item/stack/tile/brass
	buildstackamount = 1

/obj/structure/chair/stool/bronze
	name = "bronze stool"
	desc = "A bronze stool with a silk top for comfort."
	icon_state = "stoolbrass"
	item_chair = /obj/item/chair/stool/bronze
	buildstacktype = /obj/item/stack/tile/bronze
	buildstackamount = 1

/obj/item/chair/stool/brass
	name = "brass stool"
	icon_state = "stoolbrass_toppled"
	item_state = "stoolbrass"
	origin_type = /obj/structure/chair/stool/brass

/obj/item/chair/stool/bar/brass
	name = "brass bar stool"
	icon_state = "barbrass_toppled"
	item_state = "stoolbrass_bar"
	origin_type = /obj/structure/chair/stool/bar/brass

/obj/item/chair/stool/bronze
	name = "bronze stool"
	icon_state = "stoolbrass_toppled"
	item_state = "stoolbrass"
	origin_type = /obj/structure/chair/stool/bronze

/obj/item/chair/stool/bar/bronze
	name = "bronze bar stool"
	icon_state = "barbrass_toppled"
	item_state = "stoolbrass_bar"
	origin_type = /obj/structure/chair/stool/bar/bronze

/////////////////////////////////
//End of Brass & Bronze stools!//
/////////////////////////////////

/obj/item/chair/stool/narsie_act()
	return //sturdy enough to ignore a god

/obj/item/chair/wood
	name = "wooden chair"
	icon_state = "wooden_chair_toppled"
	item_state = "woodenchair"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	hitsound = 'sound/weapons/genhit1.ogg'
	origin_type = /obj/structure/chair/wood
	custom_materials = null
	break_chance = 50

/obj/item/chair/wood/narsie_act()
	return

/obj/item/chair/wood/wings
	icon_state = "wooden_chair_wings_toppled"
	origin_type = /obj/structure/chair/wood/wings

/obj/structure/chair/old
	name = "strange chair"
	desc = "You sit in this. Either by will or force. Looks REALLY uncomfortable."
	icon_state = "chairold"
	item_chair = null

/obj/structure/chair/brass
	name = "brass chair"
	desc = "A spinny chair made of brass. It looks uncomfortable."
	icon_state = "brass_chair"
	max_integrity = 150
	buildstacktype = /obj/item/stack/tile/brass
	buildstackamount = 1
	item_chair = null
	var/turns = 0

/obj/structure/chair/brass/ComponentInitialize()
	return //it spins with the power of ratvar, not components.

/obj/structure/chair/brass/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	. = ..()

/obj/structure/chair/brass/process()
	setDir(turn(dir,-90))
	playsound(src, 'sound/effects/servostep.ogg', 50, FALSE)
	turns++
	if(turns >= 8)
		STOP_PROCESSING(SSfastprocess, src)

/obj/structure/chair/brass/ratvar_act()
	return

/obj/structure/chair/brass/AltClick(mob/living/user)
	. = ..()
	turns = 0
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(!(datum_flags & DF_ISPROCESSING))
		user.visible_message("<span class='notice'>[user] spins [src] around, and Ratvarian technology keeps it spinning FOREVER.</span>", \
		"<span class='notice'>Automated spinny chairs. The pinnacle of Ratvarian technology.</span>")
		START_PROCESSING(SSfastprocess, src)
	else
		user.visible_message("<span class='notice'>[user] stops [src]'s uncontrollable spinning.</span>", \
		"<span class='notice'>You grab [src] and stop its wild spinning.</span>")
		STOP_PROCESSING(SSfastprocess, src)
	return TRUE

/obj/structure/chair/bronze
	name = "brass chair"
	desc = "A spinny chair made of bronze. It has little cogs for wheels!"
	anchored = FALSE
	icon_state = "brass_chair"
	buildstacktype = /obj/item/stack/tile/bronze
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/bronze/Moved()
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/machines/clockcult/integration_cog_install.ogg', 50, TRUE)
