/datum/ghostrole/hermit
	name = "Space Hermit"
	assigned_role = "Hermit"
	desc = "A stranded cryo-occupant in deep space."
	spawntext = "You've been late to awaken from your cryo slumber. Blasted machine, you set it to 10 days not 10 weeks!</span><b> Where have the others gone while we were out? Did they manage to survive?"
	instantiator = /datum/ghostrole_instantiator/human/random

/datum/ghostrole/hermit/Instantiate(client/C, atom/loc, list/params)
	var/rp = rand(1, 4)
	switch(rp)
		if(1)
			params["fluff"] = "proper"
		if(2)
			params["fluff"] = "tiger"
		if(3)
			params["fluff"] = "exile"
		if(4)
			params["fluff"] = "tourist"
	return ..()

/datum/ghostrole/hermit/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "Each day you barely scrape by, and between the terrible conditions of your makeshift shelter, \
	the hostile creatures, and the ash drakes swooping down from the cloudless skies, all you can wish for is the feel of soft grass between your toes and \
	the fresh air of Earth. These thoughts are dispelled by yet another recollection of how you got here... "
	switch(params["fluff"])
		if("proper")
			flavour_text += "you were a [pick("arms dealer", "shipwright", "docking manager")]'s assistant on a small trading station several sectors from here. Raiders attacked, and there was \
			only one pod left when you got to the escape bay. You took it and launched it alone, and the crowd of terrified faces crowding at the airlock door as your pod's engines burst to \
			life and sent you to this hell are forever branded into your memory."
		if("tiger")
			flavour_text += "you're an exile from the Tiger Cooperative. Their technological fanaticism drove you to question the power and beliefs of the Exolitics, and they saw you as a \
			heretic and subjected you to hours of horrible torture. You were hours away from execution when a high-ranking friend of yours in the Cooperative managed to secure you a pod, \
			scrambled its destination's coordinates, and launched it. You awoke from stasis when you landed and have been surviving - barely - ever since."
		if("exile")
			flavour_text += "you were a doctor on one of Nanotrasen's space stations, but you left behind that damn corporation's tyranny and everything it stood for. From a metaphorical hell \
			to a literal one, you find yourself nonetheless missing the recycled air and warm floors of what you left behind... but you'd still rather be here than there."
		if("tourist")
			flavour_text += "you were always joked about by your friends for \"not playing with a full deck\", as they so <i>kindly</i> put it. It seems that they were right when you, on a tour \
			at one of Nanotrasen's state-of-the-art research facilities, were in one of the escape pods alone and saw the red button. It was big and shiny, and it caught your eye. You pressed \
			it, and after a terrifying and fast ride for days, you landed here. You've had time to wisen up since then, and you think that your old friends wouldn't be laughing now."
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/random/hermit
	mob_traits = list(
		TRAIT_EXEMPT_HEALTH_EVENTS
	)

/datum/ghostrole_instantiator/human/random/hermit/GetOutfit(client/C, mob/M, list/params)
	var/datum/outfit/outfit = ..()
	switch(params["fluff"])
		if("proper")
			outfit.uniform = /obj/item/clothing/under/misc/assistantformal
			outfit.shoes = /obj/item/clothing/shoes/sneakers/black
			outfit.back = /obj/item/storage/backpack
		if("tiger")
			outfit.uniform = /obj/item/clothing/under/rank/prisoner
			outfit.shoes = /obj/item/clothing/shoes/sneakers/orange
			outfit.back = /obj/item/storage/backpack
		if("exile")
			outfit.uniform = /obj/item/clothing/under/rank/medical/doctor
			outfit.suit = /obj/item/clothing/suit/toggle/labcoat
			outfit.back = /obj/item/storage/backpack/medic
			outfit.shoes = /obj/item/clothing/shoes/sneakers/black
		if("tourist")
			outfit.uniform = /obj/item/clothing/under/color/grey/glorf
			outfit.shoes = /obj/item/clothing/shoes/sneakers/black
			outfit.back = /obj/item/storage/backpack
	return outfit

//Malfunctioning cryostasis sleepers: Spawns in makeshift shelters in lavaland. Ghosts become hermits with knowledge of how they got to where they are now.
/obj/structure/ghost_role_spawner/hermit
	name = "malfunctioning cryostasis sleeper"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	role_type = /datum/ghostrole/hermit

/obj/structure/ghost_role_spawner/hermit/Destroy()
	new/obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()
