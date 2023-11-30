//spears
/obj/item/spear
	icon_state = "spearglass0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 20
	throw_speed = 4
	embedding = list("impact_pain_mult" = 3)
	armour_penetration = 10
	custom_materials = list(/datum/material/iron=1150, /datum/material/glass=2075)
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/obj/item/grenade/explosive = null
	var/war_cry = "AAAAARGH!!!"
	var/icon_prefix = "spearglass"
	var/wielded = FALSE // track wielded status on item
	wound_bonus = -15
	bare_wound_bonus = 15

/obj/item/spear/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/spear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.
	AddComponent(/datum/component/jousting)
	AddElement(/datum/element/sword_point)
	AddComponent(/datum/component/two_handed, force_unwielded=10, force_wielded=18, icon_wielded="[icon_prefix]1")

/// triggered on wield of two handed item
/obj/item/spear/proc/on_wield(obj/item/source, mob/user)
	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/spear/proc/on_unwield(obj/item/source, mob/user)
	wielded = FALSE

/obj/item/spear/rightclick_attack_self(mob/user)
	if(explosive)
		explosive.attack_self(user)
		return
	. = ..()

/obj/item/spear/update_icon_state()
	icon_state = "[icon_prefix]0"

/obj/item/spear/update_overlays()
	. = ..()
	if(explosive)
		. += "spearbomb_overlay"

/obj/item/spear/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to sword-swallow \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(explosive) //Citadel Edit removes qdel and explosive.forcemove(AM)
		user.say("[war_cry]", forced="spear warcry")
		explosive.prime()
		user.gib()
		return BRUTELOSS
	return BRUTELOSS

/obj/item/spear/examine(mob/user)
	. = ..()
	if(explosive)
		. += "<span class='notice'>Alt-click to set your war cry.</span>"
		. += "<span class='notice'>Right-click in combat mode to activate the attached explosive.</span>"

/obj/item/spear/afterattack(atom/movable/AM, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(isopenturf(AM)) //So you can actually melee with it
		return
	if(explosive && wielded) //Citadel edit removes qdel and explosive.forcemove(AM)
		user.say("[war_cry]", forced="spear warcry")
		explosive.prime()

/obj/item/spear/grenade_prime_react(obj/item/grenade/nade) //Citadel edit, removes throw_impact because memes
	nade.forceMove(get_turf(src))
	qdel(src)

/obj/item/spear/AltClick(mob/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE))
		..()
		if(!explosive)
			return
		if(istype(user) && loc == user)
			var/input = stripped_input(user,"What do you want your war cry to be? You will shout it when you hit someone in melee.", ,"", 50)
			if(input)
				src.war_cry = input
		return TRUE

/obj/item/spear/CheckParts(list/parts_list)
	var/obj/item/shard/tip = locate() in parts_list
	if (istype(tip, /obj/item/shard/plasma))
		throwforce = 21
		embedding = list(embed_chance = 75, pain_mult = 1.5) //plasmaglass spears are sharper
		updateEmbedding()
		icon_prefix = "spearplasma"
		AddComponent(/datum/component/two_handed, force_unwielded=11, force_wielded=19, icon_wielded="[icon_prefix]1")
	qdel(tip)
	var/obj/item/spear/S = locate() in parts_list
	if(S)
		if(S.explosive)
			S.explosive.forceMove(get_turf(src))
			S.explosive = null
		parts_list -= S
		qdel(S)
	..()
	var/obj/item/grenade/G = locate() in contents
	if(G)
		explosive = G
		name = "explosive lance"
		embedding = list(embed_chance = 0, pain_mult = 1)//elances should not be embeddable
		updateEmbedding()
		desc = "A makeshift spear with \a [G] attached to it."
	update_icon()

//GREY TIDE
/obj/item/spear/grey_tide
	icon_state = "spearglass0"
	name = "\improper Grey Tide"
	desc = "Recovered from the aftermath of a revolt aboard Defense Outpost Theta Aegis, in which a seemingly endless tide of Assistants caused heavy casualities among Nanotrasen military forces."
	throwforce = 20
	throw_speed = 4
	attack_verb = list("gored")
	var/clonechance = 50
	var/clonedamage = 12
	var/clonespeed = 0
	var/clone_replication_chance = 30
	var/clone_lifespan = 100

/obj/item/spear/grey_tide/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=15, force_wielded=25, icon_wielded="[icon_prefix]1")

/obj/item/spear/grey_tide/afterattack(atom/movable/AM, mob/living/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.faction |= "greytide([REF(user)])"
	if(isliving(AM))
		var/mob/living/L = AM
		if(istype (L, /mob/living/simple_animal/hostile/illusion))
			return
		if(!L.stat && prob(clonechance))
			var/mob/living/simple_animal/hostile/illusion/M = new(user.loc)
			M.faction = user.faction.Copy()
			M.set_varspeed(clonespeed)
			M.Copy_Parent(user, clone_lifespan, user.health/2.5, clonedamage, clone_replication_chance)
			M.GiveTarget(L)

/*
 * Bone Spear
 */
/obj/item/spear/bonespear	//Blatant imitation of spear, but made out of bone. Not valid for explosive modification.
	icon_state = "bone_spear0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "bone spear"
	desc = "A haphazardly-constructed yet still deadly weapon. The pinnacle of modern technology."
	force = 11
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	reach = 2
	throwforce = 22
	embedding = list("embedded_impact_pain_multiplier" = 3)
	armour_penetration = 15				//Enhanced armor piercing
	custom_materials = null
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	sharpness = SHARP_EDGED
	icon_prefix = "bone_spear"

/obj/item/spear/bonespear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=11, force_wielded=20, icon_wielded="[icon_prefix]1")
