/*
	Changeling Mutations! ~By Miauw (ALL OF IT :V)
	Contains:
		Arm Blade
		Space Suit
		Shield
		Armor
*/


//Parent to shields and blades because muh copypasted code.
/obj/effect/proc_holder/changeling/weapon
	name = "Organic Weapon"
	desc = "Go tell a coder if you see this"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = -1
	genetic_damage = 1000

	var/weapon_type
	var/weapon_name_simple

/obj/effect/proc_holder/changeling/weapon/try_to_sting(mob/user, mob/target)
	if(check_weapon(user, user.r_hand, 1))
		return
	if(check_weapon(user, user.l_hand, 0))
		return
	..(user, target)

/obj/effect/proc_holder/changeling/weapon/proc/check_weapon(mob/user, obj/item/hand_item, right_hand=1)
	if(istype(hand_item, weapon_type))
		playsound(user, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(hand_item)
		user.visible_message("<span class='warning'>With a sickening crunch, [user] reforms their [weapon_name_simple] into an arm!</span>", "<span class='notice'>We assimilate the [weapon_name_simple] back into our body.</span>", "<span class='italics>You hear organic matter ripping and tearing!</span>")
		if(right_hand)
			user.update_inv_r_hand()
		else
			user.update_inv_l_hand()
		return 1

/obj/effect/proc_holder/changeling/weapon/sting_action(mob/living/user)
	if(!user.drop_item())
		user << "<span class='warning'>The [user.get_active_hand()] is stuck to your hand, you cannot grow a [weapon_name_simple] over it!</span>"
		return
	var/limb_regen = 0
	if(user.hand) //we regen the arm before changing it into the weapon
		limb_regen = user.regenerate_limb("l_arm", 1)
	else
		limb_regen = user.regenerate_limb("r_arm", 1)
	if(limb_regen)
		user.visible_message("<span class='warning'>[user]'s missing arm reforms, making a loud, grotesque sound!</span>", "<span class='userdanger'>Your arm regrows, making a loud, crunchy sound and giving you great pain!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
		user.emote("scream")
	var/obj/item/W = new weapon_type(user)
	user.put_in_hands(W)
	playsound(user, 'sound/effects/blobattack.ogg', 30, 1)
	return W

/obj/effect/proc_holder/changeling/weapon/on_refund(mob/user)
	check_weapon(user, user.r_hand, 1)
	check_weapon(user, user.l_hand, 0)

//Parent to space suits and armor.
/obj/effect/proc_holder/changeling/suit
	name = "Organic Suit"
	desc = "Go tell a coder if you see this"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = -1
	genetic_damage = 1000

	var/helmet_type = /obj/item
	var/suit_type = /obj/item
	var/suit_name_simple = "    "
	var/helmet_name_simple = "     "
	var/recharge_slowdown = 0
	var/blood_on_castoff = 0

/obj/effect/proc_holder/changeling/suit/try_to_sting(mob/user, mob/target)
	if(check_suit(user))
		return
	var/mob/living/carbon/human/H = user
	..(H, target)

//checks if we already have an organic suit and casts it off.
/obj/effect/proc_holder/changeling/suit/proc/check_suit(mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	if(!ishuman(user) || !changeling)
		return 1
	var/mob/living/carbon/human/H = user
	if(istype(H.wear_suit, suit_type) || istype(H.head, helmet_type))
		H.visible_message("<span class='warning'>[H] casts off their [suit_name_simple]!</span>", "<span class='warning'>We cast off our [suit_name_simple][genetic_damage > 0 ? ", temporarily weakening our genomes." : "."]</span>", "<span class='italics'>You hear the organic matter ripping and tearing!</span>")
		H.unEquip(H.head, TRUE) //The qdel on dropped() takes care of it
		H.unEquip(H.wear_suit, TRUE)
		H.update_inv_wear_suit()
		H.update_inv_head()
		H.update_hair()

		if(blood_on_castoff)
			H.add_splatter_floor()
			playsound(H.loc, 'sound/effects/splat.ogg', 50, 1) //So real sounds

		changeling.geneticdamage += genetic_damage //Casting off a space suit leaves you weak for a few seconds.
		changeling.chem_recharge_slowdown -= recharge_slowdown
		return 1

/obj/effect/proc_holder/changeling/suit/on_refund(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	check_suit(H)

/obj/effect/proc_holder/changeling/suit/sting_action(mob/living/carbon/human/user)
	if(!user.canUnEquip(user.wear_suit))
		user << "\the [user.wear_suit] is stuck to your body, you cannot grow a [suit_name_simple] over it!"
		return
	if(!user.canUnEquip(user.head))
		user << "\the [user.head] is stuck on your head, you cannot grow a [helmet_name_simple] over it!"
		return

	user.unEquip(user.head)
	user.unEquip(user.wear_suit)

	user.equip_to_slot_if_possible(new suit_type(user), slot_wear_suit, 1, 1, 1)
	user.equip_to_slot_if_possible(new helmet_type(user), slot_head, 1, 1, 1)

	var/datum/changeling/changeling = user.mind.changeling
	changeling.chem_recharge_slowdown += recharge_slowdown
	return 1


//fancy headers yo
/***************************************\
|***************ARM BLADE***************|
\***************************************/
/obj/effect/proc_holder/changeling/weapon/arm_blade
	name = "Arm Blade"
	desc = "We reform one of our arms into a deadly blade."
	helptext = "We may retract our armblade in the same manner as we form it. Cannot be used while in lesser form."
	chemical_cost = 20
	dna_cost = 2
	genetic_damage = 10
	req_human = 1
	max_genetic_damage = 20
	weapon_type = /obj/item/weapon/melee/arm_blade
	weapon_name_simple = "blade"

/obj/item/weapon/melee/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "arm_blade"
	item_state = "arm_blade"
	flags = ABSTRACT | NODROP | DROPDEL
	w_class = 5.0
	force = 25
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	sharpness = IS_SHARP

/obj/item/weapon/melee/arm_blade/New(location,silent)
	..()
	if(ismob(loc) && !silent)
		loc.visible_message("<span class='warning'>A grotesque blade forms around [loc.name]\'s arm!</span>", "<span class='warning'>Our arm twists and mutates, transforming it into a deadly blade.</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")

/obj/item/weapon/melee/arm_blade/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/structure/table))
		var/obj/structure/table/T = target
		T.table_destroy()

	else if(istype(target, /obj/machinery/computer))
		var/obj/machinery/computer/C = target
		C.attack_alien(user) //muh copypasta

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target

		if(!A.requiresID() || A.allowed(user)) //This is to prevent stupid shit like hitting a door with an arm blade, the door opening because you have acces and still getting a "the airlocks motors resist our efforts to force it" message.
			return

		if(A.hasPower())
			if(A.locked)
				user << "<span class='warning'>The airlock's bolts prevent it from being forced!</span>"
				return
			user << "<span class='warning'>The airlock's motors are resisting, this may take time...</span>"
			if(do_after(user, 100, target = A))
				A.open(2)
			return

		else if(A.locked)
			user << "<span class='warning'>The airlock's bolts prevent it from being forced!</span>"
			return

		else
			//user.say("Heeeeeeeeeerrre's Johnny!")
			user.visible_message("<span class='warning'>[user] forces the door to open with \his [src]!</span>", "<span class='warning'>We force the door to open.</span>", "<span class='italics'>You hear a metal screeching sound.</span>")
			A.open(1)


/***************************************\
|****************SHIELD*****************|
\***************************************/
/obj/effect/proc_holder/changeling/weapon/shield
	name = "Organic Shield"
	desc = "We reform one of our arms into a hard shield."
	helptext = "Organic tissue cannot resist damage forever; the shield will break after it is hit too much. The more genomes we absorb, the stronger it is. Cannot be used while in lesser form."
	chemical_cost = 20
	dna_cost = 1
	genetic_damage = 12
	req_human = 1
	max_genetic_damage = 20

	weapon_type = /obj/item/weapon/shield/changeling
	weapon_name_simple = "shield"

/obj/effect/proc_holder/changeling/weapon/shield/sting_action(mob/user)
	var/datum/changeling/changeling = user.mind.changeling //So we can read the absorbedcount.
	if(!changeling)
		return

	var/obj/item/weapon/shield/changeling/S = ..(user)
	S.remaining_uses = round(changeling.absorbedcount * 3)
	return 1

/obj/item/weapon/shield/changeling
	name = "shield-like mass"
	desc = "A mass of tough, boney tissue. You can still see the fingers as a twisted pattern in the shield."
	flags = ABSTRACT | NODROP | DROPDEL
	icon = 'icons/obj/weapons.dmi'
	icon_state = "ling_shield"
	block_chance = 50

	var/remaining_uses //Set by the changeling ability.

/obj/item/weapon/shield/changeling/New()
	..()
	if(ismob(loc))
		loc.visible_message("<span class='warning'>The end of [loc.name]\'s hand inflates rapidly, forming a huge shield-like mass!</span>", "<span class='warning'>We inflate our hand into a strong shield.</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")

/obj/item/weapon/shield/changeling/hit_reaction()
	if(remaining_uses < 1)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.visible_message("<span class='warning'>With a sickening crunch, [H] reforms his shield into an arm!</span>", "<span class='notice'>We assimilate our shield into our body</span>", "<span class='italics>You hear organic matter ripping and tearing!</span>")
			H.unEquip(src, 1)
		qdel(src)
		return 0
	else
		remaining_uses--
		return ..()


/***************************************\
|*********SPACE SUIT + HELMET***********|
\***************************************/
/obj/effect/proc_holder/changeling/suit/organic_space_suit
	name = "Organic Space Suit"
	desc = "We grow an organic suit to protect ourselves from space exposure."
	helptext = "We must constantly repair our form to make it space-proof, reducing chemical production while we are protected. Retreating the suit damages our genomes. Cannot be used in lesser form."
	chemical_cost = 20
	dna_cost = 2
	genetic_damage = 8
	req_human = 1
	max_genetic_damage = 20

	suit_type = /obj/item/clothing/suit/space/changeling
	helmet_type = /obj/item/clothing/head/helmet/space/changeling
	suit_name_simple = "flesh shell"
	helmet_name_simple = "space helmet"
	recharge_slowdown = 0.5
	blood_on_castoff = 1

/obj/item/clothing/suit/space/changeling
	name = "flesh mass"
	icon_state = "lingspacesuit"
	desc = "A huge, bulky mass of pressure and temperature-resistant organic tissue, evolved to facilitate space travel."
	flags = STOPSPRESSUREDMAGE | NODROP | DROPDEL //Not THICKMATERIAL because it's organic tissue, so if somebody tries to inject something into it, it still ends up in your blood. (also balance but muh fluff)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank/internals/emergency_oxygen, /obj/item/weapon/tank/internals/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //No armor at all.

/obj/item/clothing/suit/space/changeling/New()
	..()
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh rapidly inflates, forming a bloated mass around their body!</span>", "<span class='warning'>We inflate our flesh, creating a spaceproof suit!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/space/changeling/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.reagents.add_reagent("salbutamol", REAGENTS_METABOLISM)

/obj/item/clothing/head/helmet/space/changeling
	name = "flesh mass"
	icon_state = "lingspacehelmet"
	desc = "A covering of pressure and temperature-resistant organic tissue with a glass-like chitin front."
	flags = STOPSPRESSUREDMAGE | NODROP | DROPDEL //Again, no THICKMATERIAL.
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/***************************************\
|*****************ARMOR*****************|
\***************************************/
/obj/effect/proc_holder/changeling/suit/armor
	name = "Chitinous Armor"
	desc = "We turn our skin into tough chitin to protect us from damage."
	helptext = "Upkeep of the armor requires a low expenditure of chemicals. The armor is strong against brute force, but does not provide much protection from lasers. Retreating the armor damages our genomes. Cannot be used in lesser form."
	chemical_cost = 20
	dna_cost = 1
	genetic_damage = 11
	req_human = 1
	max_genetic_damage = 20
	recharge_slowdown = 0.25

	suit_type = /obj/item/clothing/suit/armor/changeling
	helmet_type = /obj/item/clothing/head/helmet/changeling
	suit_name_simple = "armor"
	helmet_name_simple = "helmet"

/obj/item/clothing/suit/armor/changeling
	name = "chitinous mass"
	desc = "A tough, hard covering of black chitin."
	icon_state = "lingarmor"
	flags = NODROP | DROPDEL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 20, bomb = 10, bio = 4, rad = 0)
	flags_inv = HIDEJUMPSUIT
	cold_protection = 0
	heat_protection = 0

/obj/item/clothing/suit/armor/changeling/New()
	..()
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh turns black, quickly transforming into a hard, chitinous mass!</span>", "<span class='warning'>We harden our flesh, creating a suit of armor!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")

/obj/item/clothing/head/helmet/changeling
	name = "chitinous mass"
	desc = "A tough, hard covering of black chitin with transparent chitin in front."
	icon_state = "lingarmorhelmet"
	flags = NODROP | DROPDEL
	armor = list(melee = 30, bullet = 30, laser = 40, energy = 20, bomb = 10, bio = 4, rad = 0)
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE
