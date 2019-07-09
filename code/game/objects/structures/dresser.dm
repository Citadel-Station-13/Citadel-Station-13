/obj/structure/dresser
	name = "dresser"
	desc = "A nicely-crafted wooden dresser. It's filled with lots of undies."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "dresser"
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You begin to [anchored ? "unwrench" : "wrench"] [src].</span>")
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, "<span class='notice'>You successfully [anchored ? "unwrench" : "wrench"] [src].</span>")
			setAnchored(!anchored)
	else
		return ..()

/obj/structure/dresser/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)
	qdel(src)

/obj/structure/dresser/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.dna && H.dna.species && (NO_UNDERWEAR in H.dna.species.species_traits))
			to_chat(user, "<span class='warning'>You are not capable of wearing underwear.</span>")
			return

		var/choice = input(user, "Underwear, Undershirt, or Socks?", "Changing") as null|anything in list("Underwear","Undershirt","Socks")
		if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
			return
		switch(choice)
			if("Underwear")
				var/new_undies = input(user, "Select your underwear", "Changing")  as null|anything in GLOB.underwear_list
				if(new_undies)
					H.underwear = new_undies
					var/datum/sprite_accessory/underwear/bottom/B = GLOB.underwear_list[new_undies]
					if(B?.has_color)
						var/n_undie_color = input(user, "Choose your underwear's color.", "Character Preference", H.undie_color) as color|null
						if(n_undie_color)
							H.undie_color = n_undie_color
			if("Undershirt")
				var/new_undershirt = input(user, "Select your undershirt", "Changing") as null|anything in GLOB.undershirt_list
				if(new_undershirt)
					H.undershirt = new_undershirt
					var/datum/sprite_accessory/underwear/top/T = GLOB.undershirt_list[new_undershirt]
					if(T?.has_color)
						var/n_shirt_color = input(user, "Choose your underwear's color.", "Character Preference", H.shirt_color) as color|null
						if(n_shirt_color)
							H.shirt_color = n_shirt_color
			if("Socks")
				var/new_socks = input(user, "Select your socks", "Changing") as null|anything in GLOB.socks_list
				if(new_socks)
					H.socks= new_socks
					var/datum/sprite_accessory/underwear/socks/S = GLOB.socks_list[new_socks]
					if(S?.has_color)
						var/n_socks_color = input(user, "Choose your underwear's color.", "Character Preference", H.socks_color) as color|null
						if(n_socks_color)
							H.socks_color = n_socks_color

		add_fingerprint(H)
		H.update_body()
