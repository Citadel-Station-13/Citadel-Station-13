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

/obj/item/ingot
	name = "ingot"
	icon = 'icons/obj/smith.dmi'
	icon_state = "ingot"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/workability = 0


/obj/item/ingot/on_attack_hand(mob/user)
	var/mob/living/carbon/human/H
	if(!workability)
		return ..()
	var/prot = 0
	if(ishuman(user))
		H = user
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.max_heat_protection_temperature)
				prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1
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
	custom_materials = list(/datum/material/diamond=12000) //yeah ok

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

/obj/item/ingot/bronze/ratvar
	material_flags = MATERIAL_COLOR
	name = "brass ingnot"
	desc = "On closer inspection, what appears to be wholly-unsuitable-for-smithing brass is actually more structurally stable bronze. Ratvar must have transformed the brass into bronze. Somehow."

/obj/item/smithing/Initialize()
	..()
	desc = "A [src]. Hit it with a [finishingitem.name] to create a [finalitem.name]."


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
		if(-1000 to -5)
			qualname = "awful"
		if(-1000 to -2)
			qualname = "shoddy"
		if(-1000 to 0)
			qualname =  "poor"
		if(0)
			qualname = "normal"
		if(10 to INFINITY)
			qualname = "legendary"
		if(8,9)
			qualname = "masterwork"
		if(6,7)
			qualname = "excellent"
		if(4,5)
			qualname = "good"
		if(1,2,3)
			qualname = "above-average"
	var/datum/material/mat = custom_materials[1]
	mat = mat.name
	finalitem.name = "[qualname] [mat] [finalitem.name]"
	finalitem.forceMove(get_turf(src))
	qdel(src)

/obj/item/smithing/hammerhead
	name = "smithed hammer head"
	finalitem = /obj/item/melee/smith/hammer
	icon_state = "hammer"

/obj/item/smithing/hammerhead/startfinish()
	var/obj/item/melee/smith/hammer/finalforreal = new /obj/item/melee/smith/hammer(src)
	finalforreal.force += quality/2
	finalforreal.qualitymod = quality/4
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

/obj/item/smithing/shovelhead
	name = "smithed shovel head"
	finalitem = /obj/item/shovel/smithed
	icon_state = "shovel"

/obj/item/smithing/shovelhead/startfinish()
	finalitem = new /obj/item/shovel/smithed(src)
	finalitem.force += quality/2
	if(quality)
		finalitem.toolspeed /= quality
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
	finalforreal.throwforce = finalforreal.force/10 //its a pike not a javelin
	finalitem = finalforreal
	..()

/obj/item/smithing/pickaxehead
	name = "smithed pickaxe head"
	finalitem = /obj/item/pickaxe/smithed
	icon_state = "pickaxe"

/obj/item/smithing/pickaxehead/startfinish()
	var/obj/item/pickaxe/smithed/finalforreal = new /obj/item/pickaxe/smithed(src)
	finalforreal.force += quality/2
	if(quality)
		finalforreal.toolspeed /= quality
	switch(quality)
		if(10 to INFINITY)
			finalforreal.digrange = 4
		if(5 to 9)
			finalforreal.digrange = 3
		if(3,4)
			finalforreal.digrange = 2
	finalitem = finalforreal
	..()


/obj/item/smithing/prospectingpickhead
	name = "smithed prospector's pickaxe head"
	finalitem = /obj/item/mining_scanner/prospector
	icon_state = "minipick"

/obj/item/smithing/prospectingpickhead/startfinish()
	var/obj/item/mining_scanner/prospector/finalforreal = new /obj/item/mining_scanner/prospector(src)
	finalforreal.range = 2 + quality
	if(quality)
		finalforreal.cooldown = 100/quality
	finalitem = finalforreal
	..()


/obj/item/smithing/shortswordblade
	name = "smithed gladius blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword
	icon_state = "gladius"

/obj/item/smithing/shortswordblade/startfinish()
	finalitem = new /obj/item/melee/smith/shortsword(src)
	finalitem.force += quality
	..()

/obj/item/smithing/scimitarblade
	name = "smithed scimitar blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword/scimitar
	icon_state = "scimitar"

/obj/item/smithing/shortswordblade/startfinish()
	finalitem = new /obj/item/melee/smith/shortsword/scimitar(src)
	finalitem.force += quality
	..()

/obj/item/smithing/wakiblade
	name = "smithed wakizashi blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/wakizashi
	icon_state = "waki"

/obj/item/smithing/wakiblade/startfinish()
	finalitem = new /obj/item/melee/smith/wakizashi(src)
	finalitem.force += quality
	..()

/obj/item/smithing/sabreblade
	name = "smithed sabre blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/sabre
	icon_state = "sabre"

/obj/item/smithing/sabrerblade/startfinish()
	finalitem = new /obj/item/melee/smith/sabre(src)
	finalitem.force += quality
	..()

/obj/item/smithing/rapierblade
	name = "smithed rapier blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/sabre/rapier
	icon_state = "rapier"

/obj/item/smithing/rapierblade/startfinish()
	finalitem = new /obj/item/melee/smith/sabre/rapier(src)
	finalitem.force += quality
	..()

/obj/item/smithing/knifeblade
	name = "smithed knife blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/kitchen/knife
	icon_state = "dagger"

/obj/item/smithing/knifehead/startfinish()
	finalitem = new /obj/item/kitchen/knife(src)
	finalitem.force = 4 + quality/2
	finalitem.icon = 'icons/obj/smith.dmi'
	finalitem.icon_state = "dagger"
	var/mutable_appearance/overlay = mutable_appearance('icons/obj/smith.dmi', "daggerhilt")
	overlay.appearance_flags = RESET_COLOR
	finalitem.add_overlay(overlay)
	if(finalitem.force < 0)
		finalitem.force = 0
	finalitem.material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
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

/obj/item/smithing/zweiblade
	name = "smithed zweihander blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/zweihander
	icon_state = "zweihander"

/obj/item/smithing/zweiblade/startfinish()
	var/obj/item/melee/smith/twohand/zweihander/finalforreal = new /obj/item/melee/smith/twohand/zweihander(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalitem = finalforreal
	..()

/obj/item/smithing/halberdhead
	name = "smithed halberd head"
	finalitem = /obj/item/melee/smith/twohand/halberd
	icon_state = "halberd"

/obj/item/smithing/halberdhead/startfinish()
	var/obj/item/melee/smith/twohand/halberd/finalforreal = new /obj/item/melee/smith/twohand/halberd(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.throwforce = finalforreal.force/3
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalitem = finalforreal
	..()

/obj/item/smithing/glaivehead
	name = "smithed glaive head"
	finalitem = /obj/item/melee/smith/twohand/glaive
	icon_state = "glaive"

/obj/item/smithing/glaive/startfinish()
	var/obj/item/melee/smith/twohand/glaive/finalforreal = new /obj/item/melee/smith/twohand/glaive(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalforreal.throwforce = finalforreal.force
	finalforreal.AddComponent(/datum/component/two_handed, force_unwielded=finalforreal.force, force_wielded=finalforreal.wield_force, icon_wielded="[icon_state]")
	finalitem = finalforreal
	..()

/obj/item/smithing/katanablade
	name = "smithed katana blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/katana
	icon_state = "katana"


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
