
/obj/item/melee/smith
	name = "base class obj/item/melee/smith" //tin. handles overlay and quality and shit.
	desc = null
	icon = 'icons/obj/smith.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON //yeah ok
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	force = 12
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	var/quality
	var/overlay_state = "stick"
	var/mutable_appearance/overlay
	var/wielded_mult = 1
	var/wield_force = 15

/obj/item/melee/smith/Initialize()
	..()
	if(!desc)
		desc = "A handmade [name]."
	overlay = mutable_appearance(icon, overlay_state)
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0


/obj/item/melee/smith/twohand
	item_flags = NEEDS_PERMIT //it's a bigass sword/spear. beepsky is going to give you shit for it.
	sharpness = SHARP_EDGED
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	force = 10
	wielded_mult = 1.8
	w_class = WEIGHT_CLASS_BULKY

/obj/item/melee/smith/twohand/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.
	AddElement(/datum/element/sword_point)



///////////////////////////
//        Mining         //
///////////////////////////
/obj/item/mining_scanner/prospector
	name = "prospector's pickaxe"
	desc = "A pickaxe that can sound rocks to find mineral deposits and stop gibtonite detonations."
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	icon = 'icons/obj/smith.dmi'
	icon_state = "minipick" //todo:sprite
	sharpness = SHARP_POINTY//it doesnt have a blade it has a point

/obj/item/mining_scanner/prospector/Initialize()
	..()
	var/mutable_appearance/overlay
	overlay = mutable_appearance(icon, "minihandle")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0

/obj/item/pickaxe/smithed
	name = "pickaxe"
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	icon = 'icons/obj/smith.dmi'
	icon_state = "pickaxe"
	sharpness = SHARP_POINTY

/obj/item/pickaxe/smithed/Initialize()
	..()
	var/mutable_appearance/overlay
	overlay = mutable_appearance(icon, "stick")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0

/obj/item/pickaxe/smithed/attack_self(mob/user)
		to_chat(user, "<span class='notice'>Tool does not have a configureable dig range.</span>")


///////////////////////////
//        Spears         //
///////////////////////////

/obj/item/melee/smith/twohand/javelin
	name = "javelin"
	icon_state = "javelin"
	overlay_state = "longhandle"
	wielded_mult = 1.5
	slot_flags = ITEM_SLOT_BACK
	sharpness = SHARP_POINTY


/obj/item/melee/smith/twohand/javelin/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)


/obj/item/melee/smith/twohand/pike
	name = "pike"
	icon_state = "pike"
	w_class = WEIGHT_CLASS_HUGE
	wielded_mult = 2
	slowdown = 0.1 //we'll see about this
	overlay_state = "longhandle"
	reach = 2 //yeah ok
	slot_flags = ITEM_SLOT_BACK
	sharpness = SHARP_POINTY


//////////////////////////
//      Other Melee     //
///////////////////////////


/obj/item/melee/smith/hammer//blacksmithing, not warhammer.
	name = "hammer"
	icon_state = "hammer"
	overlay_state = "hammerhandle"

/obj/item/scythe/smithed //we need to inherit scythecode, but that's about it.
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS


/obj/item/melee/smith/cogheadclub
	name = "coghead club"
	icon_state = "coghead"
	overlay_state = "stick"

/obj/item/melee/smith/scimitar
	name = "scimitar"
	sharpness = SHARP_EDGED
	icon_state = "scimitar"
	overlay_state = "scimitarhilt"

/datum/block_parry_data/katana //like longbokken but worse reflect
	parry_stamina_cost = 6
	parry_time_windup = 0
	parry_time_active = 15 //decent window
	parry_time_spindown = 0
	parry_time_perfect = 2
	parry_time_perfect_leeway = 0.75
	parry_imperfect_falloff_percent = 7.5
	parry_efficiency_to_counterattack = INFINITY
	parry_efficiency_considered_successful = 80
	parry_efficiency_perfect = 120
	parry_failed_stagger_duration = 3 SECONDS
	parry_data = list(PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN = 1.9)

/obj/item/melee/smith/twohand/broadsword
	name = "broadsword"
	icon_state = "broadsword"
	overlay_state = "broadhilt"

/obj/item/melee/smith/twohand/katana
	name = "katana"
	icon_state = "katana-s"
	overlay_state = "katanahilt"
	item_flags = ITEM_CAN_PARRY | NEEDS_PERMIT
	obj_flags = UNIQUE_RENAME //want to name your katana "DEMON BLADE" or some shit? go ahead, idiot.
	block_parry_data = /datum/block_parry_data/katana

/obj/item/melee/smith/rapier
	name = "rapier"
	icon_state = "rapier"
	sharpness = SHARP_EDGED
	overlay_state = "rapierhilt"
	force = 12 //less force, stronger parry
	sharpness = SHARP_POINTY
	armour_penetration = 30
	block_parry_data = /datum/block_parry_data/smithrapier

/datum/block_parry_data/smithrapier
	parry_stamina_cost = 12 //dont miss
	parry_time_active = 4
	parry_time_perfect = 2
	parry_time_perfect_leeway = 2
	parry_failed_stagger_duration = 3 SECONDS
	parry_time_windup = 0
	parry_time_spindown = 0
	parry_imperfect_falloff_percent = 0
	parry_efficiency_to_counterattack = INFINITY
	parry_efficiency_considered_successful = 120
	parry_efficiency_perfect = 120
	parry_data = list(PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN = 4)
	parry_automatic_enabled = TRUE
	autoparry_single_efficiency = 75

//unique hammers
/obj/item/melee/smith/hammer/toolbox
	name = "toolbox hammer"
	desc = "A metal filled toolbox on a stick. Useable as a really shitty hammer."
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "toolbox"
	overlay_state = "hammerhandle"

/obj/item/melee/smith/hammer/narsie
	name = "runemetal hammer"
	custom_materials = list(/datum/material/runedmetal = 12000)
	desc = "A metal hammer inscribed with geometeric runes."

/obj/item/melee/smith/hammer/narsie/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							 "<span class='cultlarge'>\"You shouldn't be touching tools that aren't yours.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/melee/smith/hammer/ratvar
	name = "brass hammer"
	custom_materials = list(/datum/material/bronze = 12000)
	desc = "A brass hammer inscribed with odd writing. You can't read it."

/obj/item/melee/smith/hammer/ratvar/attack(mob/living/target, mob/living/carbon/human/user)
	if(!is_servant_of_ratvar(user))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", "<span class='neovgre'>\"You shouldn't be touching tools that aren't yours.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/melee/smith/hammer/debug
	name = "debugging hammer"
	desc = "A DEBUGGING HAMMER!! EPIC!!."
