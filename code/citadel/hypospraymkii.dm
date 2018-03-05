#define HYPO_SPRAY 0
#define HYPO_INJECT 1

//A vial-loaded hypospray. Cartridge-based!
/obj/item/reagent_containers/hypospray/mkii
	name = "hypospray mk.II"
	icon = 'icons/obj/citadel/hypospray.dmi'
	icon_state = "hypo2"
	var/list/allowed_containers = list(/obj/item/reagent_containers/glass/bottle/vial)
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	volume = 0
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15)
	var/mode = HYPO_INJECT
	var/obj/item/reagent_containers/glass/bottle/vial
	var/loaded_vial = /obj/item/reagent_containers/glass/bottle/vial
	var/spawnwithvial = TRUE
	var/start_vial = null
	var/list/vials = list()
	var/list/inject_sounds = list('sound/items/hypospray.ogg','sound/items/hypospray2.ogg')

/obj/item/reagent_containers/hypospray/mkii/CMO
	name = "hypospray mk.II deluxe"
	allowed_containers = list(/obj/item/reagent_containers/glass/bottle/vial, /obj/item/reagent_containers/glass/bottle/vial/large)
	icon_state = "cmo2"
	ignore_flags = 1
	desc = "The Chief Medical Officer's hypospray is identically functional to the base model, excepting that it can take larger vials in addition to regular sized. It is also able to penetrate harder materials and deliver more reagents per spray."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	loaded_vial = /obj/item/reagent_containers/glass/bottle/vial/large/preloaded/CMO
	possible_transfer_amounts = list(5,10,15,30,60) //cmo hypo should be able to dump lots into it

/obj/item/reagent_containers/hypospray/mkii/Initialize()
	. = ..()
	if(!spawnwithvial)
		update_icon()
		return
	if (!start_vial)
		start_vial = new loaded_vial(src)
	update_icon()

/obj/item/reagent_containers/hypospray/mkii/update_icon()
	..()
	icon_state = "[initial(icon_state)][loaded_vial ? "" : "-e"]"
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
	return

/obj/item/reagent_containers/hypospray/mkii/examine(mob/user)
	. = ..()
	to_chat(user, "[src] is set to [mode ? "Inject" : "Spray"] contents on application.")

/obj/item/reagent_containers/hypospray/mkii/proc/unload_hypo(mob/user)
	testing("unload_hypo triggered")
	if(vial && contents >= 1)
		var/obj/item/reagent_containers/glass/bottle/vial/V = vial
		testing("passed hypo check in unload_hypo")
		reagents.trans_to(V, volume)
		volume = 0
		testing("put_in_hands")
		V.forceMove(user.loc)
		user.put_in_hands(V)
		to_chat(user, "<span class='notice'>You remove the vial from the [src].</span>")
		vial = null
		testing("put_in_hands passed or dropped it")
		update_icon()
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, "<span class='notice'>This hypo isn't loaded!</span>")
		return

/obj/item/reagent_containers/hypospray/mkii/proc/load_hypo(obj/item/I, mob/user)
	testing("load_hypo triggered")
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial) && contents >= 1))
		to_chat(user, "<span class='warning'>[src] can not hold more than one vial!</span>")
		return
	testing("we don't already have a vial in the hypo")
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial)))
		var/obj/item/reagent_containers/glass/bottle/vial/V = I
		testing("item is a vial")
		if(!is_type_in_list(V, allowed_containers))
			to_chat(user, "<span class='notice'>\The [src] doesn't accept this vial.</span>")
			return
		testing("correct sized vial")
		. = 1 //no afterattack
		if(!user.transferItemToLoc(V,src))
			return
		testing("able to transferitemtoloc")
		if(!do_after(user,30) || V || !(V in user))
			return FALSE
		testing("passed do_after check")
		volume = V.volume
		testing("trans_to triggered")
		V.reagents.trans_to(src, V.volume)
		user.visible_message("<span class='notice'>[user] has loads vial into \the [src].</span>","<span class='notice'>You have loaded [vial] into \the [src].</span>")
		update_icon()
		playsound(loc, 'sound/weapons/autoguninsert.ogg', 50, 1)
	else
		to_chat(user, "<span class='notice'>This doesn't fit in \the [src].</span>")
		return

/obj/item/reagent_containers/hypospray/mkii/attackby(obj/item/I, mob/living/user)
	load_hypo(I, src)

/obj/item/reagent_containers/hypospray/mkii/attack(obj/item/I, mob/user, params)
	return

/obj/item/reagent_containers/hypospray/mkii/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !target.reagents)
		return

	var/mob/living/L
	if(isliving(target))
		L = target
		if(!L.can_inject(user, 1))
			return

//Always log attemped injections for admins
	var/list/rinject = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		rinject += R.name
	var/contained = english_list(rinject)
	add_logs(user, L, "attemped to inject", src, addition="which had [contained]")
	if(!reagents.total_volume)
		to_chat(user, "<span class='notice'>[src]'s cartridge is empty.</span>")
		return
	if(!L && !target.is_injectable()) //only checks on non-living mobs, due to how can_inject() handles
		to_chat(user, "<span class='warning'>You cannot directly fill [target]!</span>")
		return

	if(target.reagents.total_volume >= target.reagents.maximum_volume)
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	if(L) //living mob
		if(!L.can_inject(user, TRUE))
			return
		if(L != user)
			L.visible_message("<span class='danger'>[user] is trying to inject [L] with [src]!</span>", \
							"<span class='userdanger'>[user] is trying to inject [L] with the [src]!</span>")
			if(!do_mob(user, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject,user,1)))
				return
			if(!reagents.total_volume)
				return
			if(L.reagents.total_volume >= L.reagents.maximum_volume)
				return
			if(possible_transfer_amounts >= 15)
				playsound(src,'sound/items/hypospray_long.ogg',50, 1, -1)
			else
				playsound(src, "inject_sounds", 50, 1, -1)
			L.visible_message("<span class='danger'>[user] injects [L] with the [src]!", \
							"<span class='userdanger'>[user] injects [L] with the [src]!</span>")

		if(L != user)
			add_logs(user, L, "injected", src, addition="which had [contained]")
		else
			if(possible_transfer_amounts >= 15)
				playsound(src,'sound/items/hypospray_long.ogg',50, 1, -1)
			else
				playsound(src, "inject_sounds", 50, 1, -1)
			log_attack("<font color='red'>[user.name] ([user.ckey]) applied [src] to [L.name] ([L.ckey]), which had [contained] (INTENT: [uppertext(user.a_intent)])</font>")
			L.log_message("<font color='orange'>applied [src] to  themselves ([contained]).</font>", INDIVIDUAL_ATTACK_LOG)

		if(HYPO_INJECT)
			var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
			reagents.reaction(L, INJECT, fraction)
			reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You inject [amount_per_transfer_from_this] units of the solution. The hypospray's cartridge now contains [reagents.total_volume] units.</span>")

		else if(HYPO_SPRAY)
			var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
			reagents.reaction(L, PATCH, fraction)
			reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You spray [amount_per_transfer_from_this] units of the solution. The hypospray's cartridge now contains [reagents.total_volume] units.</span>")

/obj/item/reagent_containers/hypospray/mkii/AltClick(mob/living/user)
	if(user)
		testing("Has user")
		if(user.incapacitated())
			return
		else if(!contents)
			to_chat(user, "This Hypo needs to be loaded first!")
			return
		else
			for(var/obj/item/I in contents)
				testing("Has contents, unload_hypo please")
				unload_hypo(I,user)

/obj/item/reagent_containers/hypospray/mkii/verb/modes(mob/living/user)
	set name = "Change Application Method"
	set category = "Object"
	var/choice = alert(user, "Which application mode should this be? Current mode is: [mode ? "Spray" : "Inject"]", "", "Spray", "Cancel", "Inject")
	switch(choice)
		if("Cancel")
			return
		if("Inject")
			mode = HYPO_INJECT
		if("Spray")
			mode = HYPO_SPRAY