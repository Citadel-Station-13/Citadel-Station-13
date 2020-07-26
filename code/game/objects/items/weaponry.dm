w/obj/item/banhammer
	desc = "A banhammer."
	name = "banhammer"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "toyhammer"
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	force = 1
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	attack_verb = list("banned")
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 70)
	resistance_flags = FIRE_PROOF

/obj/item/banhammer/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is hitting [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to ban [user.p_them()]self from life.</span>")
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)
/*
oranges says: This is a meme relating to the english translation of the ss13 russian wiki page on lurkmore.
mrdoombringer sez: and remember kids, if you try and PR a fix for this item's grammar, you are admitting that you are, indeed, a newfriend.
for further reading, please see: https://github.com/tgstation/tgstation/pull/30173 and https://translate.google.com/translate?sl=auto&tl=en&js=y&prev=_t&hl=en&ie=UTF-8&u=%2F%2Flurkmore.to%2FSS13&edit-text=&act=url
*/
/obj/item/banhammer/attack(mob/M, mob/user)
	if(user.zone_selected == BODY_ZONE_HEAD)
		M.visible_message("<span class='danger'>[user] are stroking the head of [M] with a bangammer</span>", "<span class='userdanger'>[user] are stroking the head with a bangammer</span>", "you hear a bangammer stroking a head");
	else
		M.visible_message("<span class='danger'>[M] has been banned FOR NO REISIN by [user]</span>", "<span class='userdanger'>You have been banned FOR NO REISIN by [user]</span>", "you hear a banhammer banning someone")
	playsound(loc, 'sound/effects/adminhelp.ogg', 15) //keep it at 15% volume so people don't jump out of their skin too much
	if(user.a_intent != INTENT_HELP)
		return ..(M, user)

/obj/item/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 2
	throwforce = 1
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/sord/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is trying to impale [user.p_them()]self with [src]! It might be a suicide attempt if it weren't so shitty.</span>", \
	"<span class='suicide'>You try to impale yourself with [src], but it's USELESS...</span>")
	return SHAME

/obj/item/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 50
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON

/obj/item/claymore/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 40, 105)
	AddElement(/datum/element/sword_point)

/obj/item/claymore/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is falling on [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return(BRUTELOSS)

/obj/item/claymore/purified
	name = "purified longsword"
	desc = "A hastily-purified longsword. While not as holy as it could be, it's still a formidable weapon against those who would rather see you dead."
	force = 25
	block_chance = 0

/obj/item/claymore/highlander //ALL COMMENTS MADE REGARDING THIS SWORD MUST BE MADE IN ALL CAPS
	desc = "<b><i>THERE CAN BE ONLY ONE, AND IT WILL BE YOU!!!</i></b>\nActivate it in your hand to point to the nearest victim."
	flags_1 = CONDUCT_1
	item_flags = DROPDEL
	slot_flags = null
	block_chance = 0 //RNG WON'T HELP YOU NOW, PANSY
	light_range = 3
	attack_verb = list("brutalized", "eviscerated", "disemboweled", "hacked", "carved", "cleaved") //ONLY THE MOST VISCERAL ATTACK VERBS
	var/notches = 0 //HOW MANY PEOPLE HAVE BEEN SLAIN WITH THIS BLADE
	var/obj/item/disk/nuclear/nuke_disk //OUR STORED NUKE DISK

/obj/item/claymore/highlander/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER)
	START_PROCESSING(SSobj, src)

/obj/item/claymore/highlander/Destroy()
	if(nuke_disk)
		nuke_disk.forceMove(get_turf(src))
		nuke_disk.visible_message("<span class='warning'>The nuke disk is vulnerable!</span>")
		nuke_disk = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/claymore/highlander/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		loc.layer = LARGE_MOB_LAYER //NO HIDING BEHIND PLANTS FOR YOU, DICKWEED (HA GET IT, BECAUSE WEEDS ARE PLANTS)
		H.bleedsuppress = TRUE //AND WE WON'T BLEED OUT LIKE COWARDS
		H.adjustStaminaLoss(-50) //CIT CHANGE - AND MAY HE NEVER SUCCUMB TO EXHAUSTION
	else
		if(!(flags_1 & ADMIN_SPAWNED_1))
			qdel(src)


/obj/item/claymore/highlander/pickup(mob/living/user)
	. = ..()
	to_chat(user, "<span class='notice'>The power of Scotland protects you! You are shielded from all stuns and knockdowns.</span>")
	user.add_stun_absorption("highlander", INFINITY, 1, " is protected by the power of Scotland!", "The power of Scotland absorbs the stun!", " is protected by the power of Scotland!")
	user.ignore_slowdown(HIGHLANDER)

/obj/item/claymore/highlander/dropped(mob/living/user)
	. = ..()
	user.unignore_slowdown(HIGHLANDER)
	if(!QDELETED(src))
		qdel(src) //If this ever happens, it's because you lost an arm

/obj/item/claymore/highlander/examine(mob/user)
	. = ..()
	. += "It has [!notches ? "nothing" : "[notches] notches"] scratched into the blade."
	if(nuke_disk)
		. += "<span class='boldwarning'>It's holding the nuke disk!</span>"

/obj/item/claymore/highlander/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!QDELETED(target) && iscarbon(target) && target.stat == DEAD && target.mind && target.mind.special_role == "highlander")
		user.fully_heal() //STEAL THE LIFE OF OUR FALLEN FOES
		add_notch(user)
		target.visible_message("<span class='warning'>[target] crumbles to dust beneath [user]'s blows!</span>", "<span class='userdanger'>As you fall, your body crumbles to dust!</span>")
		target.dust()

/obj/item/claymore/highlander/attack_self(mob/living/user)
	var/closest_victim
	var/closest_distance = 255
	for(var/mob/living/carbon/human/H in GLOB.player_list - user)
		if(H.client && H.mind.special_role == "highlander" && (!closest_victim || get_dist(user, closest_victim) < closest_distance))
			closest_victim = H
	if(!closest_victim)
		to_chat(user, "<span class='warning'>[src] thrums for a moment and falls dark. Perhaps there's nobody nearby.</span>")
		return
	to_chat(user, "<span class='danger'>[src] thrums and points to the [dir2text(get_dir(user, closest_victim))].</span>")

/obj/item/claymore/highlander/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if((attack_type & ATTACK_TYPE_PROJECTILE) && is_energy_reflectable_projectile(object))
		return BLOCK_SUCCESS | BLOCK_SHOULD_REDIRECT | BLOCK_PHYSICAL_EXTERNAL | BLOCK_REDIRECTED
	return ..()

/obj/item/claymore/highlander/proc/add_notch(mob/living/user) //DYNAMIC CLAYMORE PROGRESSION SYSTEM - THIS IS THE FUTURE
	notches++
	force++
	var/new_name = name
	switch(notches)
		if(1)
			to_chat(user, "<span class='notice'>Your first kill - hopefully one of many. You scratch a notch into [src]'s blade.</span>")
			to_chat(user, "<span class='warning'>You feel your fallen foe's soul entering your blade, restoring your wounds!</span>")
			new_name = "notched claymore"
		if(2)
			to_chat(user, "<span class='notice'>Another falls before you. Another soul fuses with your own. Another notch in the blade.</span>")
			new_name = "double-notched claymore"
			add_atom_colour(rgb(255, 235, 235), ADMIN_COLOUR_PRIORITY)
		if(3)
			to_chat(user, "<span class='notice'>You're beginning to</span> <span class='danger'><b>relish</b> the <b>thrill</b> of <b>battle.</b></span>")
			new_name = "triple-notched claymore"
			add_atom_colour(rgb(255, 215, 215), ADMIN_COLOUR_PRIORITY)
		if(4)
			to_chat(user, "<span class='notice'>You've lost count of</span> <span class='boldannounce'>how many you've killed.</span>")
			new_name = "many-notched claymore"
			add_atom_colour(rgb(255, 195, 195), ADMIN_COLOUR_PRIORITY)
		if(5)
			to_chat(user, "<span class='boldannounce'>Five voices now echo in your mind, cheering the slaughter.</span>")
			new_name = "battle-tested claymore"
			add_atom_colour(rgb(255, 175, 175), ADMIN_COLOUR_PRIORITY)
		if(6)
			to_chat(user, "<span class='boldannounce'>Is this what the vikings felt like? Visions of glory fill your head as you slay your sixth foe.</span>")
			new_name = "battle-scarred claymore"
			add_atom_colour(rgb(255, 155, 155), ADMIN_COLOUR_PRIORITY)
		if(7)
			to_chat(user, "<span class='boldannounce'>Kill. Butcher. <i>Conquer.</i></span>")
			new_name = "vicious claymore"
			add_atom_colour(rgb(255, 135, 135), ADMIN_COLOUR_PRIORITY)
		if(8)
			to_chat(user, "<span class='userdanger'>IT NEVER GETS OLD. THE <i>SCREAMING</i>. THE <i>BLOOD</i> AS IT <i>SPRAYS</i> ACROSS YOUR <i>FACE.</i></span>")
			new_name = "bloodthirsty claymore"
			add_atom_colour(rgb(255, 115, 115), ADMIN_COLOUR_PRIORITY)
		if(9)
			to_chat(user, "<span class='userdanger'>ANOTHER ONE FALLS TO YOUR BLOWS. ANOTHER WEAKLING UNFIT TO LIVE.</span>")
			new_name = "gore-stained claymore"
			add_atom_colour(rgb(255, 95, 95), ADMIN_COLOUR_PRIORITY)
		if(10)
			user.visible_message("<span class='warning'>[user]'s eyes light up with a vengeful fire!</span>", \
			"<span class='userdanger'>YOU FEEL THE POWER OF VALHALLA FLOWING THROUGH YOU! <i>THERE CAN BE ONLY ONE!!!</i></span>")
			user.update_icons()
			new_name = "GORE-DRENCHED CLAYMORE OF [pick("THE WHIMSICAL SLAUGHTER", "A THOUSAND SLAUGHTERED CATTLE", "GLORY AND VALHALLA", "ANNIHILATION", "OBLITERATION")]"
			icon_state = "claymore_valhalla"
			item_state = "cultblade"
			remove_atom_colour(ADMIN_COLOUR_PRIORITY)

	name = new_name
	playsound(user, 'sound/items/screwdriver2.ogg', 50, 1)

/obj/item/katana
	name = "katana"
	desc = "Woefully underpowered in D20."
	icon_state = "katana"
	item_state = "katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 50
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON

/obj/item/katana/cursed
	slot_flags = null

/obj/item/katana/cursed/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/katana/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting [user.p_their()] stomach open with [src]! It looks like [user.p_theyre()] trying to commit seppuku!</span>")
	playsound(src, 'sound/weapons/bladeslice.ogg', 50, 1)
	return(BRUTELOSS)

/obj/item/melee/bokken // parrying stick
	name = "bokken"
	desc = "A space-Japanese training sword made of wood and shaped like a katana."
	icon_state = "bokken"
	item_state = "bokken"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	force = 9
	throwforce = 10
	damtype = STAMINA
	attack_verb = list("whacked", "smacked", "struck")
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON
	hitsound = 'sound/weapons/grenadelaunch.ogg' // no good wood thunk sounds
	var/harm = FALSE // TRUE = brute, FALSE = stam
	var/reinforced = FALSE
	var/burnt = FALSE
	var/burned_in // text you burned in (with a welder)
	var/quick_parry = FALSE // false = default parry, true = really small parry window
	item_flags = ITEM_CAN_PARRY
	block_parry_data = /datum/block_parry_data/bokken
	bare_wound_bonus = 0
	wound_bonus = 0

/datum/block_parry_data/bokken // fucked up parry data, emphasizing quicker, shorter parries
	parry_stamina_cost = 8 // be wise about when you parry, though, else you won't be able to fight enough to make it count
	parry_time_windup = 0
	parry_time_active = 10 // small parry window
	parry_time_spindown = 0
	// parry_flags = PARRY_DEFAULT_HANDLE_FEEDBACK		// bokken users can no longer strike while parrying
	parry_time_perfect = 1.5
	parry_time_perfect_leeway = 1
	parry_imperfect_falloff_percent = 7.5
	parry_efficiency_to_counterattack = 100
	parry_efficiency_considered_successful = 65		// VERY generous
	parry_efficiency_perfect = 120
	parry_efficiency_perfect_override = list(
		"[ATTACK_TYPE_PROJECTILE]" = 30,
	)
	parry_failed_stagger_duration = 3 SECONDS
	parry_data = list(PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN = 2.5) // 7*2.5 = 17.5, 8*2.5 = 20, 9*2.5 = 22.5, 10*2.5 = 25

/datum/block_parry_data/bokken/quick_parry // emphasizing REALLY SHORT PARRIES
	parry_stamina_cost = 6 // still more costly than most parries, but less than a full bokken parry
	parry_time_active = 5 // REALLY small parry window
	parry_time_perfect = 2.5 // however...
	parry_time_perfect_leeway = 2.5 // the entire time, the parry is perfect
	parry_failed_stagger_duration = 1 SECONDS
	parry_failed_clickcd_duration = 1 SECONDS // more forgiving punishments for missed parries
	// still, don't fucking miss your parries or you're down stamina and staggered to shit

/obj/item/melee/bokken/Initialize()
	. = ..()
	AddElement(/datum/element/sword_point)

/obj/item/melee/bokken/attack_self(mob/user)
	harm = !harm
	if(harm)
		force -= 2
		damtype = BRUTE
		attack_verb = list("bashed", "smashed", "attacked")
		bare_wound_bonus = 15 // having your leg smacked by a wooden stick is probably not great for it if it's naked
		wound_bonus = 0
	else
		force += 2
		damtype = STAMINA
		attack_verb = list("whacked", "smacked", "struck")
		bare_wound_bonus = 0
		wound_bonus = 0
	to_chat(user, "<span class='notice'>[src] is now [harm ? "harmful" : "not quite as harmful"].</span>")

/obj/item/melee/bokken/AltClick(mob/user)
	. = ..()
	quick_parry = !quick_parry
	if(quick_parry)
		block_parry_data = /datum/block_parry_data/bokken/quick_parry
	else
		block_parry_data = /datum/block_parry_data/bokken
	to_chat(user, "<span class='notice'>[src] is now [quick_parry ? "emphasizing shorter parries, forcing you to riposte or be staggered" : "emphasizing longer parries, with a shorter window to riposte but more forgiving parries"].</span>")

/obj/item/melee/bokken/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/pen))
		var/new_name = stripped_input(user, "What do you wish to name [src]?", "New Name", "bo
