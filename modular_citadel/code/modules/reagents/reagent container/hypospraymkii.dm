#define HYPO_SPRAY 0
#define HYPO_INJECT 1

//A vial-loaded hypospray. Cartridge-based!
/obj/item/reagent_containers/hypospray/mkii
	name = "hypospray mk.II"
	icon = 'modular_citadel/icons/obj/hypospraymkii.dmi'
	icon_state = "hypo2"
	var/list/allowed_containers = list(/obj/item/reagent_containers/glass/bottle/vial/small)
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	volume = 0
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15)
	var/mode = HYPO_INJECT
	var/obj/item/reagent_containers/glass/bottle/vial/vial
	var/loaded_vial = /obj/item/reagent_containers/glass/bottle/vial/small
	var/spawnwithvial = TRUE
	var/start_vial = null

/obj/item/reagent_containers/hypospray/mkii/CMO
	name = "hypospray mk.II deluxe"
	allowed_containers = list(/obj/item/reagent_containers/glass/bottle/vial/small, /obj/item/reagent_containers/glass/bottle/vial/large)
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
		vial = start_vial
	update_icon()

/obj/item/reagent_containers/hypospray/mkii/update_icon()
	..()
	icon_state = "[initial(icon_state)][vial ? "" : "-e"]"
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
	return

/obj/item/reagent_containers/hypospray/mkii/examine(mob/user)
	. = ..()
	to_chat(user, "[src] is set to [mode ? "Inject" : "Spray"] contents on application.")

/obj/item/reagent_containers/hypospray/mkii/proc/unload_hypo(obj/item/I, mob/user)
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial)))
		var/obj/item/reagent_containers/glass/bottle/vial/V = I
		reagents.trans_to(V, reagents.total_volume)
		reagents.maximum_volume = 0
		V.forceMove(user.loc)
		user.put_in_hands(V)
		to_chat(user, "<span class='notice'>You remove the vial from the [src].</span>")
		vial = null
		update_icon()
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, "<span class='notice'>This hypo isn't loaded!</span>")
		return

/obj/item/reagent_containers/hypospray/mkii/attackby(obj/item/I, mob/living/user)
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial) && vial != null))
		to_chat(user, "<span class='warning'>[src] can not hold more than one vial!</span>")
		return FALSE
	if((istype(I, /obj/item/reagent_containers/glass/bottle/vial)))
		var/obj/item/reagent_containers/glass/bottle/vial/V = I
		if(!is_type_in_list(V, allowed_containers))
			to_chat(user, "<span class='notice'>\The [src] doesn't accept this vial.</span>")
			return
		vial = V
		reagents.maximum_volume = V.volume
		V.reagents.trans_to(src, V.reagents.total_volume)
		if(!user.transferItemToLoc(V,src))
			return
		user.visible_message("<span class='notice'>[user] has loads vial into \the [src].</span>","<span class='notice'>You have loaded [vial] into \the [src].</span>")
		update_icon()
		playsound(loc, 'sound/weapons/autoguninsert.ogg', 50, 1)
		return TRUE
	else
		to_chat(user, "<span class='notice'>This doesn't fit in \the [src].</span>")
		return FALSE
	return FALSE

/obj/item/reagent_containers/hypospray/mkii/attack(obj/item/I, mob/user, params)
	return

/obj/item/reagent_containers/hypospray/mkii/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(!ismob(target))
		return

	var/mob/living/L
	if(isliving(target))
		L = target
		if(!L.can_inject(user, 1))
			return

	if(!L && !target.is_injectable()) //only checks on non-living mobs, due to how can_inject() handles
		to_chat(user, "<span class='warning'>You cannot directly fill [target]!</span>")
		return

	if(target.reagents.total_volume >= target.reagents.maximum_volume)
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	if(ishuman(L))
		var/obj/item/bodypart/affecting = L.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			to_chat(user, "<span class='warning'>The limb is missing!</span>")
			return
		if(affecting.status != BODYPART_ORGANIC)
			to_chat(user, "<span class='notice'>Medicine won't work on a robotic limb!</span>")
			return

	var/contained = reagents.log_list()
	add_logs(user, L, "attemped to inject", src, addition="which had [contained]")
//Always log attemped injections for admins
	if(vial != null)
		switch(mode)
			if(HYPO_INJECT)
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
						L.visible_message("<span class='danger'>[user] uses the [src] on [L]!</span>", \
										"<span class='userdanger'>[user] uses the [src] on [L]!</span>")
					else
						if(!do_mob(user, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject,user,1)))
							return
						if(!reagents.total_volume)
							return
						if(L.reagents.total_volume >= L.reagents.maximum_volume)
							return
						log_attack("<font color='red'>[user.name] ([user.ckey]) applied [src] to [L.name] ([L.ckey]), which had [contained] (INTENT: [uppertext(user.a_intent)]) (MODE: [src.mode])</font>")
						L.log_message("<font color='orange'>applied [src] to  themselves ([contained]).</font>", INDIVIDUAL_ATTACK_LOG)

				var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
				reagents.reaction(L, INJECT, fraction)
				reagents.trans_to(target, amount_per_transfer_from_this)
				if(amount_per_transfer_from_this >= 15)
					playsound(loc,'sound/items/hypospray_long.ogg',50, 1, -1)
				if(amount_per_transfer_from_this < 15)
					playsound(loc,  pick('sound/items/hypospray.ogg','sound/items/hypospray2.ogg'), 50, 1, -1)
				to_chat(user, "<span class='notice'>You inject [amount_per_transfer_from_this] units of the solution. The hypospray's cartridge now contains [reagents.total_volume] units.</span>")

			if(HYPO_SPRAY)
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
						L.visible_message("<span class='danger'>[user] uses the [src] on [L]!</span>", \
										"<span class='userdanger'>[user] uses the [src] on [L]!</span>")
					else
						if(!do_mob(user, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject,user,1)))
							return
						if(!reagents.total_volume)
							return
						if(L.reagents.total_volume >= L.reagents.maximum_volume)
							return
						log_attack("<font color='red'>[user.name] ([user.ckey]) applied [src] to [L.name] ([L.ckey]), which had [contained] (INTENT: [uppertext(user.a_intent)]) (MODE: [src.mode])</font>")
						L.log_message("<font color='orange'>applied [src] to  themselves ([contained]).</font>", INDIVIDUAL_ATTACK_LOG)
				var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
				reagents.reaction(L, PATCH, fraction)
				reagents.trans_to(target, amount_per_transfer_from_this)
				if(amount_per_transfer_from_this >= 15)
					playsound(loc,'sound/items/hypospray_long.ogg',50, 1, -1)
				if(amount_per_transfer_from_this < 15)
					playsound(loc,  pick('sound/items/hypospray.ogg','sound/items/hypospray2.ogg'), 50, 1, -1)
				to_chat(user, "<span class='notice'>You spray [amount_per_transfer_from_this] units of the solution. The hypospray's cartridge now contains [reagents.total_volume] units.</span>")
	else
		to_chat(user, "<span class='notice'>[src] doesn't work here!</span>")
		return

/obj/item/reagent_containers/hypospray/mkii/AltClick(mob/living/user)
	if(user)
		if(user.incapacitated())
			return
		else if(!contents)
			to_chat(user, "This Hypo needs to be loaded first!")
			return
		else
			for(var/obj/item/I in contents)
				unload_hypo(I,user)

/obj/item/reagent_containers/hypospray/mkii/verb/modes()
	set name = "Change Application Method"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	var/choice = alert(M, "Which application mode should this be? Current mode is: [mode ? "Spray" : "Inject"]", "", "Spray", "Cancel", "Inject")
	switch(choice)
		if("Cancel")
			return
		if("Inject")
			mode = HYPO_INJECT
			to_chat(M, "[src] is now set to inject contents on application.")
		if("Spray")
			mode = HYPO_SPRAY
			to_chat(M, "[src] is now set to spray contents on application.")