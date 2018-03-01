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
	var/spray_mode = 0
	var/mode = HYPO_INJECT
	var/obj/item/reagent_containers/glass/bottle/vial/cart = null
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

/obj/item/reagent_containers/hypospray/mkii/examine(mob/user)
	. = ..()
	to_chat(user, "[src] is set to [mode ? "Inject" : "Spray"] contents on application.")

/obj/item/reagent_containers/hypospray/mkii/proc/unload_hypo(obj/item/reagent_containers/glass/bottle/vial/W, mob/user as mob)
	if(contents == null)
		to_chat(user, "This doesn't have a vial!")
		return
	else
		reagents.trans_to(W, volume)
		volume = 0
		W.loc = get_turf(user.loc)
		W.update_icon()
		user.put_in_hands(W)
		contents -= W
		to_chat(user, "<span class='notice'>You remove the vial from the [src].</span>")
		update_icon()
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1)

/obj/item/reagent_containers/hypospray/mkii/proc/load_hypo(obj/item/reagent_containers/glass/bottle/vial/W, mob/user as mob)
	if(!is_type_in_list(W, allowed_containers))
		. = 1 //no afterattack
		to_chat(user, "<span class='notice'>\The [src] only accepts hypospray vials!</span>")
		return
	else
		if(contents.len == 1)
			to_chat(user, "<span class='warning'>[src] can not hold more than one vial!</span>")
			return
		else
			user.visible_message("<span class='notice'>[user] begins loading a vial into \the [src].</span>","<span class='notice'>You start loading [W] into \the [src].</span>")
			if(!do_after(user,30) || W || !(W in user))
				return FALSE
			contents += W
			volume = W.volume
			W.reagents.trans_to(src, W.volume)
			user.visible_message("<span class='notice'>[user] has loaded a vial into \the [src].</span>","<span class='notice'>You have loaded [W] into \the [src].</span>")
			update_icon()
			playsound(loc, 'sound/weapons/autoguninsert.ogg', 50, 1)

/obj/item/reagent_containers/hypospray/mkii/attackby(obj/item/reagent_containers/glass/bottle/vial/W, mob/user as mob)
	load_hypo(src, W)

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
	if(HYPO_INJECT)
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
					playsound(loc,'sound/items/hypospray_long.ogg',50, 1, -1)
				else
					playsound(loc, "inject_sounds", 50, 1, -1)
				L.visible_message("<span class='danger'>[user] injects [L] with the [src]!", \
								"<span class='userdanger'>[user] injects [L] with the [src]!</span>")

			if(L != user)
				add_logs(user, L, "injected", src, addition="which had [contained]")
			else
				if(src.possible_transfer_amounts >= 15)
					playsound(loc,'sound/items/hypospray_long.ogg',50, 1, -1)
				else
					playsound(loc, "inject_sounds", 50, 1, -1)
				log_attack("<font color='red'>[user.name] ([user.ckey]) injected [L.name] ([L.ckey]) with [src], which had [contained] (INTENT: [uppertext(user.a_intent)])</font>")
				L.log_message("<font color='orange'>Injected themselves ([contained]) with [src].</font>", INDIVIDUAL_ATTACK_LOG)

			var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
			reagents.reaction(L, INJECT, fraction)
			reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You inject [amount_per_transfer_from_this] units of the solution. The hypospray's cartridge now contains [reagents.total_volume] units.</span>")

	if(HYPO_SPRAY)
		//Always log attemped injections for admins
		var/list/rinject = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			rinject += R.name
		var/contained = english_list(rinject)
		add_logs(user, L, "attemped to spray", src, addition="which had [contained]")

		if(!reagents.total_volume)
			to_chat(user, "<span class='notice'>[src]'s cartridge is empty.</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='notice'>[target] is full.</span>")
			return

		if(L) //living mob
			if(!L.can_inject(user, TRUE))
				return
			if(L != user)
				L.visible_message("<span class='danger'>[user] is trying to spray [L] with [src]!</span>", \
									"<span class='userdanger'>[user] is trying to spray [L] with the [src]!</span>")
				if(!do_mob(user, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject,user,1)))
					return
				if(!reagents.total_volume)
					return
				if(L.reagents.total_volume >= L.reagents.maximum_volume)
					return
				if(src.possible_transfer_amounts >= 15)
					playsound(loc,'sound/items/hypospray_long.ogg',50, 1, -1)
				else
					playsound(loc, "inject_sounds", 50, 1, -1)
				L.visible_message("<span class='danger'>[user] injects [L] with the [src]!", \
								"<span class='userdanger'>[user] injects [L] with the [src]!</span>")

			if(L != user)
				add_logs(user, L, "sprayed", src, addition="which had [contained]")
			else
				if(src.possible_transfer_amounts >= 15)
					playsound(loc,'sound/items/hypospray_long.ogg',50, 1, -1)
				else
					playsound(loc, "inject_sounds", 50, 1, -1)
				log_attack("<font color='red'>[user.name] ([user.ckey]) sprayed [L.name] ([L.ckey]) with [src.name], which had [contained] (INTENT: [uppertext(user.a_intent)])</font>")
				L.log_message("<font color='orange'>Sprayed themselves ([contained]) with [src.name].</font>", INDIVIDUAL_ATTACK_LOG)
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
		reagents.reaction(L, TOUCH, fraction)
		reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You spray [amount_per_transfer_from_this] units of the solution. The hypospray's cartridge now contains [reagents.total_volume] units.</span>")

/obj/item/reagent_containers/hypospray/mkii/update_icon()
	..()
	icon_state = "[initial(icon_state)][loaded_vial ? "" : "-e"]"
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
	return

/obj/item/reagent_containers/hypospray/mkii/AltClick(var/obj/item/reagent_containers/glass/bottle/vial/W, mob/living/user)
	if(!in_range(src, user))
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(contents == null)
		to_chat(usr, "This Hypo needs to be loaded first!")
		return
	else
		unload_hypo(src, W)

/obj/item/reagent_containers/hypospray/mkii/verb/modes()
	set name = "Change Application Method"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return
	var/choice = alert(usr, "Which application mode should this be? Current mode is: [mode ? "Spray" : "Inject"]", "", "Spray", "Cancel", "Inject")
	switch(choice)
		if("Cancel")
			return
		if("Inject")
			mode = HYPO_INJECT
		if("Spray")
			mode = HYPO_SPRAY