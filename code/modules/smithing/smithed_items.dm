/obj/item/basaltblock
	name = "basalt block"
	desc = "A block of basalt."
	icon = 'icons/obj/smith.dmi'
	icon_state = "sandvilnoir"


/obj/item/smithing
	name = "base class /obj/item/smithing"
	icon = 'icons/obj/smith.dmi'
	icon_state = "unfinished"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/quality = 0 //quality. Changed by the smithing process.
	var/obj/item/finishingitem = /obj/item/stick //What this item needs to be hit by to create finalitem
	var/obj/item/finalitem
	var/artifact = FALSE

/obj/item/ingot
	name = "ingot"
	icon = 'icons/obj/smith.dmi'
	icon_state = "ingot"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/currentquality = 0
	var/worktemp = 0 //how many steps can be done before we cool down?
	var/height = 72
	var/datum/smith_recipe/plan
	var/list/last3steps = list(null,null,null)

/obj/item/ingot/proc/add_step(var/stepdone)
	if(!stepdone)
		return FALSE
	last3steps[3] = last3steps[2]
	last3steps[2] = last3steps[1]
	last3steps[1] = stepdone

/obj/item/ingot/on_attack_hand(mob/user)
	var/mob/living/carbon/human/H
	if(!worktemp)
		return ..()
	var/prot = 0
	if(ishuman(user))
		H = user
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.max_heat_protection_temperature)
				prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 0
	if(prot > 0 || HAS_TRAIT(user, TRAIT_RESISTHEAT) || HAS_TRAIT(user, TRAIT_RESISTHEATHANDS))
		to_chat(user, "<span class='notice'>You pick up the [src].</span>")
		return ..()
	else
		to_chat(user, "<span class='warning'>You try to move the [src], but you burn your hand on it!</span>")
	if(H)
		var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
			H.update_damage_overlays()

/obj/item/ingot/iron
	custom_materials = list(/datum/material/iron=12000)

/obj/item/ingot/diamond
	custom_materials = list(/datum/material/diamond=12000)

/obj/item/ingot/uranium
	custom_materials = list(/datum/material/uranium=12000)

/obj/item/ingot/plasma
	custom_materials = list(/datum/material/plasma=12000)//yeah ok

/obj/item/ingot/gold
	custom_materials = list(/datum/material/gold=12000)

/obj/item/ingot/silver
	custom_materials = list(/datum/material/silver=12000)

/obj/item/ingot/bananium
	custom_materials = list(/datum/material/bananium=12000)

/obj/item/ingot/titanium
	custom_materials = list(/datum/material/titanium=12000)

/obj/item/ingot/adamantine
	custom_materials = list(/datum/material/adamantine=12000)

/obj/item/ingot/cult
	custom_materials = list(/datum/material/runedmetal=12000)

/obj/item/ingot/bronze
	custom_materials = list(/datum/material/bronze=12000)

/obj/item/ingot/ratvar
	custom_materials = list(/datum/material/brass=12000)
	desc = "On closer inspection, what appears to be soft brass is actually primarily replicant alloy. Nezbere must have switched it while you weren't looking."


/obj/item/smithing/attackby(obj/item/I, mob/user)
	if(istype(I, finishingitem))
		qdel(I)
		startfinish()
	else
		return ..()

/obj/item/smithing/proc/startfinish()
	dofinish()

/obj/item/smithing/proc/dofinish()
	var/qualname
	switch(quality)
		if(-1)
			qualname = "poor"
		if(0)
			qualname = "normal"
		if(1)
			qualname = "above-average"
		if(2)
			qualname = "good"
		if(3)
			qualname = "excellent"
		if(4)
			qualname = "masterwork"
		if(5)
			qualname = "legendary"

	var/datum/material/mat = custom_materials[1]
	finalitem.set_custom_materials(custom_materials)
	mat = mat.name
	if(artifact)
		dwarfyartifact(finalitem, mat)
	else
		finalitem.name = "[qualname] [mat] [initial(finalitem.name)]"
		finalitem.desc = "A [qualname] [initial(finalitem.name)]. Its quality is [quality]."
	finalitem.forceMove(get_turf(src))
	qdel(src)


/obj/item/smithing/proc/dwarfyartifact(var/obj/item/finalitem, var/mat)
	var/finaldesc = "A [initial(finalitem.name)] made of [mat], all craftsmanship is of the highest quality. It "
	switch(pick(1,2,3,4,5))
		if(1)
			finaldesc += "is encrusted with [pick("","synthetic ","multi-faceted ","magical ","sparkling ") + pick("rubies","emeralds","jade","opals","lapiz lazuli")]."
		if(2)
			finaldesc += "is laced with studs of [pick("gold","silver","aluminium","titanium")]."
		if(3)
			finaldesc += "is encircled with bands of [pick("durasteel","metallic hydrogen","ferritic-alloy","plasteel","duranium")]."
		if(4)
			finaldesc += "menaces with spikes of [pick("ytterbium","uranium","white pearl","black steel")]."
		if(5)
			finaldesc += "is encrusted with [pick("","synthetic ","multi-faceted ","magical ","sparkling ") + pick("rubies","emeralds","jade","opals","lapis lazuli")],laced with studs of [pick("gold","silver","aluminium","titanium")], encircled with bands of [pick("durasteel","metallic hydrogen","ferritic-alloy","plasteel","duranium")] and menaces with spikes of [pick("ytterbium","uranium","white pearl","black steel")]."
	finalitem.desc = finaldesc
	finalitem.name = pick("Delersibnir", "Nekolangrir", "Zanoreshik","Öntakrítin", "Nogzatan", "Vunomam", "Nazushagsaldôbar", "Sergeb", "Zafaldastot", "Vudnis", "Dostust", "Shotom", "Mugshith", "Angzak", "Oltud", "Deleratîs", "Nökornomal") //one of these is literally BLOOD POOL CREATE.iirc its Nazushagsaldôbar.

/obj/item/smithing/hammerhead
	name = "smithed hammer head"
	finalitem = /obj/item/melee/smith/hammer
	icon_state = "hammer"

/obj/item/smithing/hammerhead/startfinish()
	var/obj/item/melee/smith/hammer/finalforreal = new /obj/item/melee/smith/hammer(src)
	finalforreal.force += quality/2
	finalitem = finalforreal
	..()



/obj/item/smithing/scytheblade
	name = "smithed scythe head"
	finalitem = /obj/item/scythe/smithed
	icon_state = "scythe"

/obj/item/smithing/scytheblade/startfinish()
	finalitem = new /obj/item/scythe/smithed(src)
	finalitem.force += quality
	..()

/obj/item/smithing/cogheadclubhead
	name = "smithed coghead club head"
	finalitem = /obj/item/melee/smith/cogheadclub
	icon_state = "coghead"

/obj/item/smithing/cogheadclubhead/startfinish()
	finalitem = new /obj/item/melee/smith/cogheadclub(src)
	finalitem.force += quality
	..()

/obj/item/smithing/javelinhead
	name = "smithed javelin head"
	finalitem = /obj/item/melee/smith/twohand/javelin
	icon_state = "javelin"

/obj/item/smithing/javelinhead/startfinish()
	var/obj/item/melee/smith/twohand/javelin/finalforreal = new /obj/item/melee/smith/twohand/javelin(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalforreal.throwforce = finalforreal.force*2
	finalitem = finalforreal
	..()

/obj/item/smithing/pikehead
	name = "smithed pike head"
	finalitem = /obj/item/melee/smith/twohand/pike
	icon_state = "pike"

/obj/item/smithing/pikehead/startfinish()
	var/obj/item/melee/smith/twohand/pike/finalforreal = new /obj/item/melee/smith/twohand/pike(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalforreal.throwforce = finalforreal.force/10
	finalitem = finalforreal
	..()

/obj/item/smithing/pickaxehead
	name = "smithed pickaxe head"
	finalitem = /obj/item/pickaxe/smithed
	icon_state = "pickaxe"

/obj/item/smithing/pickaxehead/startfinish()
	var/obj/item/pickaxe/smithed/finalforreal = new /obj/item/pickaxe/smithed(src)
	finalforreal.force += quality
	if(quality > 0)
		finalforreal.toolspeed = max(0.05,(1-(quality/6)))
	else
		finalforreal.toolspeed = max(1, (quality * -1))
	switch(quality)
		if(2)
			finalforreal.digrange = 2
		if(2 to INFINITY)
			finalforreal.digrange = 4
		else
			finalforreal.digrange = 1
	finalitem = finalforreal
	..()


/obj/item/smithing/prospectingpickhead
	name = "smithed prospector's pickaxe head"
	finalitem = /obj/item/mining_scanner/prospector
	icon_state = "minipick"

/obj/item/smithing/prospectingpickhead/startfinish()
	var/obj/item/mining_scanner/prospector/finalforreal = new /obj/item/mining_scanner/prospector(src)
	finalforreal.range = 4 + quality
	if(quality > 0)
		finalforreal.cooldown /= quality
	finalitem = finalforreal
	..()



/obj/item/smithing/scimitarblade
	name = "smithed scimitar blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/scimitar
	icon_state = "scimitar"

/obj/item/smithing/scimitarblade/startfinish()
	finalitem = new /obj/item/melee/smith/scimitar(src)
	finalitem.force += quality
	..()

/obj/item/smithing/rapierblade
	name = "smithed rapier blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/rapier
	icon_state = "rapier"

/obj/item/smithing/rapierblade/startfinish()
	finalitem = new /obj/item/melee/smith/rapier(src)
	finalitem.force += quality
	..()

/obj/item/smithing/broadblade
	name = "smithed broadsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/broadsword
	icon_state = "broadsword"

/obj/item/smithing/broadblade/startfinish()
	var/obj/item/melee/smith/twohand/broadsword/finalforreal = new /obj/item/melee/smith/twohand/broadsword(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalitem = finalforreal
	..()

/obj/item/smithing/katanablade
	name = "smithed katana blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/katana
	icon_state = "katana-s"


/obj/item/smithing/katanablade/startfinish()
	var/obj/item/melee/smith/twohand/katana/finalforreal = new /obj/item/melee/smith/twohand/katana(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalitem = finalforreal
	..()

/obj/item/stick
	name = "wooden rod"
	desc = "It's a rod, suitable for use of a handle of a tool. Also could serve as a weapon, in a pinch."
	icon = 'icons/obj/smith.dmi'
	icon_state = "stick"
	force = 7

/obj/item/swordhandle
	name = "sword handle"
	desc = "It's a crudlely shaped wooden sword hilt."
	icon = 'icons/obj/smith.dmi'
	icon_state = "shorthilt"
