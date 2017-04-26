/obj/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "iv_drip"
	anchored = 0
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/mob/living/carbon/attached = null
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/obj/item/weapon/reagent_containers/beaker = null
	var/list/drip_containers = list(/obj/item/weapon/reagent_containers/blood,
											/obj/item/weapon/reagent_containers/food,
											/obj/item/weapon/reagent_containers/glass)

/obj/machinery/iv_drip/Initialize()
	..()
	update_icon()
	drip_containers = typecacheof(drip_containers)

/obj/machinery/iv_drip/update_icon()
	if(attached)
		if(mode)
			icon_state = "injecting"
		else
			icon_state = "donating"
	else
		if(mode)
			icon_state = "injectidle"
		else
			icon_state = "donateidle"

	cut_overlays()

	if(beaker)
		if(attached)
			add_overlay("beakeractive")
		else
			add_overlay("beakeridle")
		if(beaker.reagents.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/iv_drip.dmi', "reagent")

			var/percent = round((beaker.reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling_overlay.icon_state = "reagent0"
				if(10 to 24)
					filling_overlay.icon_state = "reagent10"
				if(25 to 49)
					filling_overlay.icon_state = "reagent25"
				if(50 to 74)
					filling_overlay.icon_state = "reagent50"
				if(75 to 79)
					filling_overlay.icon_state = "reagent75"
				if(80 to 90)
					filling_overlay.icon_state = "reagent80"
				if(91 to INFINITY)
					filling_overlay.icon_state = "reagent100"

			filling_overlay.color = list("#0000", "#0000", "#0000", "#000f", mix_color_from_reagents(beaker.reagents.reagent_list))
			add_overlay(filling_overlay)

/obj/machinery/iv_drip/MouseDrop(mob/living/target)
	if(!ishuman(usr) || !usr.canUseTopic(src,BE_CLOSE) || !isliving(target))
		return

	if(attached)
		visible_message("<span class='warning'>[attached] is detached from \the [src].</span>")
		attached = null
		update_icon()
		return

	if(!target.has_dna())
		to_chat(usr, "<span class='danger'>The drip beeps: Warning, incompatible creature!</span>")
		return

	if(Adjacent(target) && usr.Adjacent(target))
		if(beaker)
			usr.visible_message("<span class='warning'>[usr] attaches \the [src] to \the [target].</span>", "<span class='notice'>You attach \the [src] to \the [target].</span>")
			attached = target
			START_PROCESSING(SSmachines, src)
			update_icon()
		else
			to_chat(usr, "<span class='warning'>There's nothing attached to the IV drip!</span>")


/obj/machinery/iv_drip/attackby(obj/item/weapon/W, mob/user, params)
	if (is_type_in_typecache(W, drip_containers))
		if(!isnull(beaker))
			to_chat(user, "<span class='warning'>There is already a reagent container loaded!</span>")
			return
		if(!user.drop_item())
			return

		W.loc = src
		beaker = W
		to_chat(user, "<span class='notice'>You attach \the [W] to \the [src].</span>")
		update_icon()
		return
	else
		return ..()

/obj/machinery/iv_drip/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		new /obj/item/stack/sheet/metal(loc)
	qdel(src)

/obj/machinery/iv_drip/process()
	if(!attached)
		return PROCESS_KILL

	if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
		to_chat(attached, "<span class='userdanger'>The IV drip needle is ripped out of you!</span>")
		attached.apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
		attached = null
		update_icon()
		return PROCESS_KILL

	if(beaker)
		// Give blood
		if(mode)
			if(beaker.volume > 0)
				var/transfer_amount = 5
				if(istype(beaker, /obj/item/weapon/reagent_containers/blood))
					// speed up transfer on blood packs
					transfer_amount = 10
				var/fraction = min(transfer_amount/beaker.volume, 1) //the fraction that is transfered of the total volume
				beaker.reagents.reaction(attached, INJECT, fraction,0) //make reagents reacts, but don't spam messages
				beaker.reagents.trans_to(attached, transfer_amount)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5)) visible_message("\The [src] pings.")
				return

			// If the human is losing too much blood, beep.
			if(attached.blood_volume < BLOOD_VOLUME_SAFE && prob(5))
				visible_message("\The [src] beeps loudly.")
				playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			attached.transfer_blood_to(beaker, amount)
			update_icon()

/obj/machinery/iv_drip/attack_hand(mob/user)
	if(!ishuman(user))
		return
	if(attached)
		visible_message("[attached] is detached from \the [src]")
		attached = null
		update_icon()
		return
	else if(beaker)
		eject_beaker(user)
	else
		toggle_mode()

/obj/machinery/iv_drip/verb/eject_beaker(mob/user)
	set category = "Object"
	set name = "Remove IV Container"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, "<span class='warning'>You can't do that!</span>")
		return

	if(usr.stat)
		return

	if(beaker)
		beaker.loc = get_turf(src)
		beaker = null
		update_icon()

/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, "<span class='warning'>You can't do that!</span>")
		return

	if(usr.stat)
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")
	update_icon()

/obj/machinery/iv_drip/examine()
	set src in view()
	..()
	if (!(usr in view(2)) && usr!=loc) return

	to_chat(usr, "The IV drip is [mode ? "injecting" : "taking blood"].")

	if(beaker)
		if(beaker.reagents && beaker.reagents.reagent_list.len)
			to_chat(usr, "<span class='notice'>Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.</span>")
		else
			to_chat(usr, "<span class='notice'>Attached is an empty [beaker].</span>")
	else
		to_chat(usr, "<span class='notice'>No chemicals are attached.</span>")

	to_chat(usr, "<span class='notice'>[attached ? attached : "No one"] is attached.</span>")
