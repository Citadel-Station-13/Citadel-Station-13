GLOBAL_LIST_EMPTY(rubber_toolbox_icons)

/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon_state = "toolbox_default"
	item_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 12
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("robusted")
	hitsound = 'sound/weapons/smash.ogg'
	custom_materials = list(/datum/material/iron = 500)
	material_flags = MATERIAL_COLOR
	var/latches = "single_latch"
	var/has_latches = TRUE
	var/can_rubberify = TRUE
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE //very protecc too

/obj/item/storage/toolbox/Initialize(mapload)
	if(has_latches)
		if(prob(10))
			latches = "double_latch"
			if(prob(1))
				latches = "triple_latch"
	if(mapload && can_rubberify && prob(5))
		rubberify()
	. = ..()
	update_icon()

/obj/item/storage/toolbox/update_overlays()
	. = ..()
	if(has_latches)
		var/icon/I = icon('icons/obj/storage.dmi', latches)
		. += I


/obj/item/storage/toolbox/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] robusts [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"
	material_flags = NONE

/obj/item/storage/toolbox/emergency/PopulateContents()
	new /obj/item/crowbar/red(src)
	new /obj/item/weldingtool/mini(src)
	new /obj/item/extinguisher/mini(src)
	switch(rand(1,3))
		if(1)
			new /obj/item/flashlight(src)
		if(2)
			new /obj/item/flashlight/glowstick(src)
		if(3)
			new /obj/item/flashlight/flare(src)
	new /obj/item/radio/off(src)

/obj/item/storage/toolbox/emergency/old
	name = "rusty red toolbox"
	icon_state = "toolbox_red_old"
	has_latches = FALSE
	can_rubberify = FALSE

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"
	material_flags = NONE

/obj/item/storage/toolbox/mechanical/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/analyzer(src)
	new /obj/item/wirecutters(src)

/obj/item/storage/toolbox/mechanical/old
	name = "rusty blue toolbox"
	icon_state = "toolbox_blue_old"
	has_latches = FALSE
	can_rubberify = FALSE

/obj/item/storage/toolbox/mechanical/old/heirloom
	name = "old, robust toolbox" //this will be named "X family toolbox"
	desc = "It's seen better days."
	//Citadel change buffed to base levels
	total_mass = 2

/obj/item/storage/toolbox/mechanical/old/heirloom/PopulateContents()
	return

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	material_flags = NONE

/obj/item/storage/toolbox/electrical/PopulateContents()
	var/pickedcolor = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/screwdriver(src)
	new /obj/item/wirecutters(src)
	new /obj/item/t_scanner(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,pickedcolor)
	new /obj/item/stack/cable_coil(src,30,pickedcolor)
	if(prob(5))
		new /obj/item/clothing/gloves/color/yellow(src)
	else
		new /obj/item/stack/cable_coil(src,30,pickedcolor)

/obj/item/storage/toolbox/syndicate
	name = "black and red toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	desc = "A toolbox painted black with a red stripe. It looks more heavier than normal toolboxes."
	force = 15
	throwforce = 18
	material_flags = NONE

/obj/item/storage/toolbox/syndicate/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/toolbox/syndicate/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/wirecutters(src, "red")
	new /obj/item/multitool(src)
	new /obj/item/clothing/gloves/combat(src)

/obj/item/storage/toolbox/drone
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"
	material_flags = NONE

/obj/item/storage/toolbox/drone/PopulateContents()
	var/pickedcolor = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,pickedcolor)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/toolbox/brass
	name = "brass box"
	desc = "A huge brass box with several indentations in its surface."
	icon_state = "brassbox"
	item_state = null
	has_latches = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	w_class = WEIGHT_CLASS_HUGE
	attack_verb = list("robusted", "crushed", "smashed")
	can_rubberify = FALSE
	material_flags = NONE
	var/fabricator_type = /obj/item/clockwork/replica_fabricator/scarab

/obj/item/storage/toolbox/brass/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 28
	STR.max_items = 28

/obj/item/storage/toolbox/brass/prefilled/PopulateContents()
	if(fabricator_type)
		new fabricator_type(src)
	new /obj/item/screwdriver/brass(src)
	new /obj/item/wirecutters/brass(src)
	new /obj/item/wrench/brass(src)
	new /obj/item/crowbar/brass(src)
	new /obj/item/weldingtool/experimental/brass(src)

/obj/item/storage/toolbox/brass/prefilled/servant
	slot_flags = ITEM_SLOT_BELT
	fabricator_type = null

/obj/item/storage/toolbox/brass/prefilled/ratvar
	var/slab_type = /obj/item/clockwork/slab

/obj/item/storage/toolbox/brass/prefilled/ratvar/PopulateContents()
	..()
	new slab_type(src)

/obj/item/storage/toolbox/brass/prefilled/ratvar/admin
	slab_type = /obj/item/clockwork/slab/debug
	fabricator_type = /obj/item/clockwork/replica_fabricator/scarab/debug

/obj/item/storage/toolbox/plastitanium
	name = "plastitanium toolbox"
	desc = "A toolbox made out of plastitanium. Probably packs a massive punch."
	total_mass = 5
	icon_state = "blue"
	item_state = "toolbox_blue"
	w_class = WEIGHT_CLASS_HUGE		//heyo no bohing this!
	force = 18		//spear damage
	can_rubberify = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/plastitanium/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(proximity && isobj(A) && !isitem(A))
		var/obj/O = A
		//50 total object damage but split up for stuff like damage deflection.
		O.take_damage(22)
		O.take_damage(10)

/obj/item/storage/toolbox/artistic
	name = "artistic toolbox"
	desc = "A toolbox painted bright green. Why anyone would store art supplies in a toolbox is beyond you, but it has plenty of extra space."
	icon_state = "green"
	item_state = "toolbox_green"
	w_class = WEIGHT_CLASS_GIGANTIC //Holds more than a regular toolbox!
	material_flags = NONE

/obj/item/storage/toolbox/artistic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 20
	STR.max_items = 10

/obj/item/storage/toolbox/artistic/PopulateContents()
	new /obj/item/storage/crayons(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil/red(src)
	new /obj/item/stack/cable_coil/yellow(src)
	new /obj/item/stack/cable_coil/blue(src)
	new /obj/item/stack/cable_coil/green(src)
	new /obj/item/stack/cable_coil/pink(src)
	new /obj/item/stack/cable_coil/orange(src)
	new /obj/item/stack/cable_coil/cyan(src)
	new /obj/item/stack/cable_coil/white(src)

/obj/item/storage/toolbox/ammo
	name = "ammo box"
	desc = "It contains a few clips."
	icon_state = "ammobox"
	item_state = "ammobox"

/obj/item/storage/toolbox/ammo/PopulateContents()
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)

/obj/item/storage/toolbox/infiltrator
	name = "insidious case"
	desc = "Bearing the emblem of the Syndicate, this case contains a full infiltrator stealth suit, and has enough room to fit weaponry if necessary while being quite the heavy bludgeoning implement when in a pinch."
	icon_state = "infiltrator_case"
	item_state = "infiltrator_case"
	force = 12
	throwforce = 16
	w_class = WEIGHT_CLASS_NORMAL
	has_latches = FALSE

/obj/item/storage/toolbox/infiltrator/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE
	STR.max_items = 10
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.can_hold = typecacheof(list(
		/obj/item/clothing/head/helmet/infiltrator,
		/obj/item/clothing/suit/armor/vest/infiltrator,
		/obj/item/clothing/under/syndicate/bloodred,
		/obj/item/clothing/gloves/color/latex/nitrile/infiltrator,
		/obj/item/clothing/mask/infiltrator,
		/obj/item/clothing/shoes/combat/sneakboots,
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box
		))

/obj/item/storage/toolbox/infiltrator/PopulateContents()
	new /obj/item/clothing/head/helmet/infiltrator(src)
	new /obj/item/clothing/suit/armor/vest/infiltrator(src)
	new /obj/item/clothing/under/syndicate/bloodred(src)
	new /obj/item/clothing/gloves/color/latex/nitrile/infiltrator(src)
	new /obj/item/clothing/mask/infiltrator(src)
	new /obj/item/clothing/shoes/combat/sneakboots(src)

/obj/item/storage/toolbox/plastitanium/gold_real
	name = "golden toolbox"
	desc = "A larger then normal toolbox made of gold plated plastitanium."
	icon_state = "gold"
	item_state = "toolbox_gold"
	has_latches = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/gold_real/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/wirecutters(src, "red")
	new /obj/item/multitool/ai_detect(src)
	new /obj/item/clothing/gloves/combat(src)

/obj/item/storage/toolbox/gold_real/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 40
	STR.max_items = 12

/obj/item/storage/toolbox/gold_fake // used in crafting
	name = "golden toolbox"
	desc = "A gold plated toolbox, fancy and harmless due to the gold plating being on cardboard!"
	icon_state = "gold"
	item_state = "toolbox_gold"
	has_latches = FALSE
	force = 0
	throwforce = 0
	can_rubberify = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/proc/rubberify()
	name = "rubber [name]"
	desc = replacetext(desc, "Danger", "Bouncy")
	desc = replacetext(desc, "robust", "safe")
	desc = replacetext(desc, "heavier", "bouncier")
	DISABLE_BITFIELD(flags_1, CONDUCT_1)
	custom_materials = null
	damtype = STAMINA
	force += 3 //to compensate the higher stamina K.O. threshold compared to actual health.
	throwforce += 3
	attack_verb += "bounced"
	hitsound = 'sound/effects/clownstep1.ogg'
	if(!GLOB.rubber_toolbox_icons[icon_state])
		generate_rubber_toolbox_icon()
	icon = GLOB.rubber_toolbox_icons[icon_state]
	AddComponent(/datum/component/bouncy)

/obj/item/storage/toolbox/proc/generate_rubber_toolbox_icon()
	var/icon/new_icon = icon(icon, icon_state)
	var/icon/smooth = icon('icons/obj/storage.dmi', "rubber_toolbox_blend")
	new_icon.Blend(smooth, ICON_MULTIPLY)
	new_icon = fcopy_rsc(new_icon)
	GLOB.rubber_toolbox_icons[icon_state] = new_icon

/obj/item/storage/toolbox/rubber
	name = "rubber toolbox"
	desc = "Bouncy. Very safe."
	flags_1 = null
	custom_materials = null
	damtype = STAMINA
	force = 15
	throwforce = 15
	attack_verb = list("robusted", "bounced")
	can_rubberify = FALSE //we are already the future.
	material_flags = NONE

/obj/item/storage/toolbox/rubber/Initialize()
	icon_state = pick("blue", "red", "yellow", "green")
	item_state = "toolbox_[icon_state]"
	if(!GLOB.rubber_toolbox_icons[icon_state])
		generate_rubber_toolbox_icon()
	icon = GLOB.rubber_toolbox_icons[icon_state]
	. = ..()
	AddComponent(/datum/component/bouncy)
