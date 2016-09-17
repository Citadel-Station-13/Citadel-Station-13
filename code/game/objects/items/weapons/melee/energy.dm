/obj/item/weapon/melee/energy
	var/active = 0
	var/force_on = 30 //force when active
	var/throwforce_on = 20
	var/icon_state_on = "axe1"
	var/list/attack_verb_on = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	w_class = 2
	var/w_class_on = 4
	heat = 3500

/obj/item/weapon/melee/energy/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is slitting \his stomach open with [src]! It looks like \he's trying to commit seppuku.</span>", \
						"<span class='suicide'>[user] is falling on [src]! It looks like \he's trying to commit suicide.</span>"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/add_blood(list/blood_dna)
	return 0

/obj/item/weapon/melee/energy/is_sharp()
	return active * sharpness

/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	force = 40
	force_on = 150
	throwforce = 25
	throwforce_on = 30
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 5
	w_class = 3
	w_class_on = 5
	flags = CONDUCT
	armour_penetration = 100
	origin_tech = "combat=4;magnets=3"
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	attack_verb_on = list()

/obj/item/weapon/melee/energy/axe/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] swings the [src.name] towards \his head! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	force = 3
	throwforce = 5
	hitsound = "swing_hit" //it starts deactivated
	throw_speed = 3
	throw_range = 5
	sharpness = IS_SHARP
	embed_chance = 75
	embedded_impact_pain_multiplier = 10
	armour_penetration = 35
	origin_tech = "combat=3;magnets=4;syndicate=4"
	block_chance = 50
	var/hacked = 0

/obj/item/weapon/melee/energy/sword/New()
	if(item_color == null)
		item_color = pick("red", "blue", "green", "purple")

/obj/item/weapon/melee/energy/sword/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	if(active)
		return ..()
	return 0

/obj/item/weapon/melee/energy/attack_self(mob/living/carbon/user)
	if(user.disabilities & CLUMSY && prob(50))
		user << "<span class='warning'>You accidentally cut yourself with [src], like a doofus!</span>"
		user.take_organ_damage(5,5)
	active = !active
	if (active)
		force = force_on
		throwforce = throwforce_on
		hitsound = 'sound/weapons/blade1.ogg'
		throw_speed = 4
		if(attack_verb_on.len)
			attack_verb = attack_verb_on
		if(!item_color)
			icon_state = icon_state_on
		else
			icon_state = "sword[item_color]"
		w_class = w_class_on
		playsound(user, 'sound/weapons/saberon.ogg', 35, 1) //changed it from 50% volume to 35% because deafness
		user << "<span class='notice'>[src] is now active.</span>"
	else
		force = initial(force)
		throwforce = initial(throwforce)
		hitsound = initial(hitsound)
		throw_speed = initial(throw_speed)
		if(attack_verb_on.len)
			attack_verb = list()
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		playsound(user, 'sound/weapons/saberoff.ogg', 35, 1)  //changed it from 50% volume to 35% because deafness
		user << "<span class='notice'>[src] can now be concealed.</span>"
	add_fingerprint(user)

/obj/item/weapon/melee/energy/is_hot()
	return active * heat

/obj/item/weapon/melee/energy/sword/cyborg
	var/hitcost = 50

/obj/item/weapon/melee/energy/sword/cyborg/attack(mob/M, var/mob/living/silicon/robot/R)
	if(R.cell)
		var/obj/item/weapon/stock_parts/cell/C = R.cell
		if(active && !(C.use(hitcost)))
			attack_self(R)
			R << "<span class='notice'>It's out of charge!</span>"
			return
		..()
	return

/obj/item/weapon/melee/energy/sword/cyborg/saw //Used by medical Syndicate cyborgs
	name = "energy saw"
	desc = "For heavy duty cutting. It has a carbon-fiber blade in addition to a toggleable hard-light edge to dramatically increase sharpness."
	icon_state = "esaw"
	force_on = 30
	force = 18 //About as much as a spear
	hitsound = 'sound/weapons/circsawhit.ogg'
	icon = 'icons/obj/surgery.dmi'
	icon_state = "esaw_0"
	icon_state_on = "esaw_1"
	hitcost = 75 //Costs more than a standard cyborg esword
	item_color = null
	w_class = 3
	sharpness = IS_SHARP

/obj/item/weapon/melee/energy/sword/cyborg/saw/New()
	..()
	icon_state = "esaw_0"
	item_color = null

/obj/item/weapon/melee/energy/sword/cyborg/saw/hit_reaction()
	return 0

/obj/item/weapon/melee/energy/sword/saber

/obj/item/weapon/melee/energy/sword/saber/blue
	item_color = "blue"

/obj/item/weapon/melee/energy/sword/saber/purple
	item_color = "purple"

/obj/item/weapon/melee/energy/sword/saber/green
	item_color = "green"

/obj/item/weapon/melee/energy/sword/saber/red
	item_color = "red"

/obj/item/weapon/melee/energy/sword/saber/attackby(obj/item/weapon/W, mob/living/user, params)
	if(istype(W, /obj/item/weapon/melee/energy/sword/saber))
		user << "<span class='notice'>You attach the ends of the two \
			energy swords, making a single double-bladed weapon! \
			You're cool.</span>"
		var/obj/item/weapon/melee/energy/sword/saber/other_esword = W
		var/obj/item/weapon/twohanded/dualsaber/newSaber = new(user.loc)
		if(hacked || other_esword.hacked)
			newSaber.hacked = TRUE
			newSaber.item_color = "rainbow"
		user.unEquip(W)
		user.unEquip(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(newSaber)
	else if(istype(W, /obj/item/device/multitool))
		if(hacked == 0)
			hacked = 1
			item_color = "rainbow"
			user << "<span class='warning'>RNBW_ENGAGE</span>"

			if(active)
				icon_state = "swordrainbow"
				// Updating overlays, copied from welder code.
				// I tried calling attack_self twice, which looked cool, except it somehow didn't update the overlays!!
				if(user.r_hand == src)
					user.update_inv_r_hand(0)
				else if(user.l_hand == src)
					user.update_inv_l_hand(0)
		else
			user << "<span class='warning'>It's already fabulous!</span>"
	else
		return ..()

/obj/item/weapon/twohanded/attackby(obj/item/weapon/W, mob/living/user, params)
	if(istype(W, /obj/item/weapon/melee/energy/sword/saber))
		switch(alert(user, "You feel like the sword might be a bit more dangerous to yourself than to others if you do this.", "Combine?", "Proceed", "Abort"))
			if("Abort" || !in_range(src, user) || !src || !W || user.incapacitated())
				return
		user << "<span class='notice'>You attach the energy sword to the double \
			bladed energy sword, making a single triple-bladed weapon! \
			You're a genius!</span>"
		var/obj/item/weapon/trisword/newSaber = new(user.loc)
		user.unEquip(W)
		user.unEquip(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(newSaber)
		return

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"
	icon_state_on = "cutlass1"

/obj/item/weapon/melee/energy/sword/pirate/New()
	return

/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 30	//Normal attacks deal esword damage
	hitsound = 'sound/weapons/blade1.ogg'
	active = 1
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 3
	throw_range = 1
	w_class = 4//So you can't hide it in your pocket or some such.
	var/datum/effect_system/spark_spread/spark_system

//Most of the other special functions are handled in their own files. aka special snowflake code so kewl
/obj/item/weapon/melee/energy/blade/New()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/melee/energy/blade/dropped()
	..()
	qdel(src)

/obj/item/weapon/melee/energy/blade/attack_self(mob/user)
	return

/* Triple Esword! [joke weapon] */
/obj/item/weapon/trisword
	name = "triple-bladed energy sword"
	desc = "Wow, an energy sword with THREE blades! This must be a REALLY good weapon."
	force = 3
	throwforce = 5
	w_class = 2
	icon_state = "trisaber_off"
	item_state = "sword0"
	var/progress = 0
	var/on = 0

/obj/item/weapon/trisword/attack_self(mob/living/carbon/user)
	if(on || progress > 5)
		return
	if(progress == 0)
		user << "<span class='notice'>You extend the... Hey, wait a second, how do you turn this thing on?</span>"
		progress = 1
		return
	if(progress == 1)
		user << "<span class='notice'>No, seriously, what the fuck? Does this thing even have a button on it?</span>"
		progress = 2
		return
	if(progress == 2)
		user << "<span class='danger'>Okay, you're getting sick of this. You mash random panels on [src], trying to find a way to activate it.</span>"
		progress = 3
		return
	if(progress == 3)
		user << "<span class='danger'>God dammit, how the fuck do you turn this shit on?</span>"
		progress = 4
		return
	if(progress == 4)
		user << "<span class='notice'>You find what feels like a button on [src]! Now you just need to press it.</span>"
		progress = 5
		return
	if(progress == 5)
		user << "<span class='userdanger'>The third blade on [src] extends straight into your gut! God fucking dammit.</span>"
		playsound(user, 'sound/weapons/saberon.ogg', 35, 1)
		playsound(user, 'sound/weapons/blade1.ogg', 35, 1)
		on = 1
		icon_state = "trisaber"
		if(!remove_item_from_storage(user))
			user.unEquip(src)
		user.adjustBruteLoss(110)

/obj/item/weapon/trisword/dropped()
	..()
	if(!on)
		progress = 0

/obj/item/weapon/trisword/attack_hand(mob/living/carbon/user)
	if(on)
		user << "<span class='userdanger'>You try to pick up [src], but accidentally grab one of the blades, and quickly drop the whole thing out of pain.</span>"
		user.adjustBruteLoss(15)
		playsound(user, 'sound/weapons/blade1.ogg', 35, 1)
	else
		..()

/obj/item/weapon/trisword/attack_tk(mob/living/carbon/user)
	user << "<span class='danger'>You try to comprehend \the [src].</span>"
	user << "<span class='userdanger'>Your head hurts.</span>"
	user.adjustBrainLoss(50)
	user.confused += 15