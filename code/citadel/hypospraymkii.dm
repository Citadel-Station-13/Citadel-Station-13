//A vial-loaded hypospray. Cartridge-based!
/obj/item/reagent_containers/hypospray
	var/vial_size = obj/item/reagent_containers/glass/bottle/vial/small

/obj/item/reagent_containers/hypospray/mkii
	name = "Hypospray mk.II"
	icon = 'icons/obj/citadel/hypospray.dmi'
	icon_state = 'hypo2loaded'
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	volume = 0

/obj/item/reagent_containers/hypospray/mkii/CMO
	vial_size = /obj/item/reagent_containers/glass/bottle/vial/large
	icon_state = 'cmo2loaded'

/obj/item/reagent_containers/hypospray/mkii/New()
	..()
	loaded_vial = new /obj/item/reagent_containers/beaker/vial/small(src) //Comes with an empty vial
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/reagent_containers/hypospray/mkii/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(loaded_vial)
			reagents.trans_to_holder(loaded_vial.reagents,volume)
			reagents.maximum_volume = 0
			loaded_vial.update_icon()
			user.put_in_hands(loaded_vial)
			loaded_vial = null
			user << "<span class='notice'>You remove the vial from the [src].</span>"
			update_icon()
			playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
			return
		..()
	else
		return ..()

/obj/item/reagent_containers/hypospray/mkii/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/glass/beaker/vial))
		if(!loaded_vial)
			user.visible_message("<span class='notice'>[user] begins loading a vial into \the [src].</span>","<span class='notice'>You start loading [W] into \the [src].</span>")
			if(!do_after(user,30) || loaded_vial || !(W in user))
				return FALSE
			if(W.is_open_container())
				W.flags ^= OPENCONTAINER
				W.update_icon()
			user.drop_item()
			W.loc = src
			loaded_vial = W
			reagents.maximum_volume = loaded_vial.reagents.maximum_volume
			loaded_vial.reagents.trans_to_holder(reagents,volume)
			user.visible_message("<span class='notice'>[user] has loaded a vial into \the [src].</span>","<span class='notice'>You have loaded [W] into \the [src].</span>")
			update_icon()
			playsound(src.loc, 'sound/weapons/autoguninsert.ogg', 50, 1)
		else
			to_chat(user, "<span class='notice'>\The [src] already has a vial.</span>")
	else
		..()
