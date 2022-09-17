//his isn't a subtype of the syringe gun because the syringegun subtype is made to hold syringes
//this is meant to hold reagents/obj/item/gun/syringe
/obj/item/gun/chem
	name = "Reagent Repeater"
	desc = "A Nanotrasen smartdart repeater rifle, modified to automatically synthesize piercing darts."
	icon_state = "chemgun"
	item_state = "chemgun"
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 7
	force = 4
	inaccuracy_modifier = 0.25
	custom_materials = list(/datum/material/iron=2000)
	clumsy_check = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	var/time_per_syringe = 200
	var/syringes_left = 3
	var/max_syringes = 6
	var/last_synth = 0
	var/obj/item/reagent_containers/glass/bottle/vial/vial
	var/list/allowed_containers = list(/obj/item/reagent_containers/glass/bottle/vial/small, /obj/item/reagent_containers/glass/bottle/vial/large)
	var/quickload = TRUE

/obj/item/gun/chem/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/chemgun(src)
	START_PROCESSING(SSobj, src)

/obj/item/gun/chem/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

//bunch of hypospray copy paste
/obj/item/gun/chem/examine(mob/user)
	. = ..()
	if(vial)
		. += "[vial] has [vial.reagents.total_volume]u remaining."
	else
		. += "It has no vial loaded in."

/obj/item/gun/chem/proc/unload_hypo(obj/item/I, mob/user)
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial)))
		var/obj/item/reagent_containers/glass/bottle/vial/V = I
		V.forceMove(user.loc)
		user.put_in_hands(V)
		to_chat(user, "<span class='notice'>You remove [vial] from [src].</span>")
		vial = null
		update_icon()
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, "<span class='notice'>The weapon isn't loaded!</span>")
		return

/obj/item/gun/chem/attackby(obj/item/I, mob/living/user)
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial)))
		if(vial)
			if(!quickload)
				to_chat(user, "<span class='warning'>[src] can not hold more than one vial!</span>")
				return FALSE
			unload_hypo(vial, user)
		var/obj/item/reagent_containers/glass/bottle/vial/V = I
		if(!is_type_in_list(V, allowed_containers))
			to_chat(user, "<span class='notice'>[src] doesn't accept this type of vial.</span>")
			return FALSE
		if(!user.transferItemToLoc(V,src))
			return FALSE
		vial = V
		user.visible_message("<span class='notice'>[user] has loaded a vial into [src].</span>","<span class='notice'>You have loaded [vial] into [src].</span>")
		update_icon()
		playsound(loc, 'sound/weapons/autoguninsert.ogg', 35, 1)
		return TRUE
	else
		to_chat(user, "<span class='notice'>This doesn't fit in [src].</span>")
		return FALSE

/obj/item/gun/chem/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..() //Don't bother changing this or removing it from containers will break.

/obj/item/gun/chem/attack_self(mob/living/user)
	if(user && !user.incapacitated())
		if(!vial)
			to_chat(user, "This Hypo needs to be loaded first!")
		else
			unload_hypo(vial,user)

/obj/item/gun/chem/attack(obj/item/I, mob/user, params)
	return

/obj/item/gun/chem/can_shoot()
	return syringes_left

/obj/item/gun/chem/process_chamber()
	if(chambered && !chambered.BB && syringes_left)
		chambered.newshot()

/obj/item/gun/chem/process()
	if(syringes_left >= max_syringes)
		return
	if(world.time < last_synth+time_per_syringe)
		return
	to_chat(loc, "<span class='warning'>You hear a click as [src] synthesizes a new dart.</span>")
	syringes_left++
	if(chambered && !chambered.BB)
		chambered.newshot()
	last_synth = world.time

//Smart dart version of the reagent launcher
/obj/item/gun/chem/smart
	name = "Smartdart repeater rifle"
	desc = "An experimental improved version of the smartdart rifle. It synthesizes medicinal smart darts which it fills using an inserted hypovial. It can accommodate both large and small hypovials."
	icon_state = "chemgunrepeater"
	item_state = "syringegun"

obj/item/gun/chem/smart/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/chemgun/smart(src)

