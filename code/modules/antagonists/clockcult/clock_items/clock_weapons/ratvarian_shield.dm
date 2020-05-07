//Subtype of (riot) shield because of already implemented shieldbash stuff aswell as integrity and simillar things
//ratvarian shield: A shield that absorbs energy from attacks and uses it to empower its bashes with remendous force. It is also quite resistant to damage, though less so against lasers and energy weaponry.

/obj/item/shield/riot/ratvarian
	name = "ratvarian shield"
	icon_state = "ratvarian_shield" //Its icons are in the same place the normal shields are in
	item_state = "ratvarian_shield"
	desc = "A resilient shield made out of brass.. It feels warm to the touch."
	var/clockwork_desc = "A powerful shield of ratvarian making. It absorbs blocked attacks to charge devastating bashes."
	armor = list("melee" = 70, "bullet" = 70, "laser" = -10, "energy" = -20, "bomb" = 60, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	shield_flags = SHIELD_FLAGS_DEFAULT
	max_integrity = 100
	repair_material = 0 // Done differently because brass is technically a floortile, not a material sheet.
	var/dam_absorbed = 0
	var/bash_mult_steps = 40
	var/max_bash_mult = 4

/obj/item/shield/riot/ratvarian/examine(mob/user)
	if((is_servant_of_ratvar(user) || isobserver(user)))
		desc = clockwork_desc
		desc +="\n <span class='inathneq_small'>The shield has absorbed [dam_absorbed] damage, multiplying the effectiveness of its bashes by [calc_bash_mult()]</span>"
	. = ..()
	desc = initial(desc)

/obj/item/shield/riot/ratvarian/attackby(obj/item/W, mob/user, params)
	if(is_servant_of_ratvar(user) && istype(W, /obj/item/stack/tile/brass))
		if(obj_integrity >= max_integrity)
			to_chat(user, "<span class='warning'>[src] is already in perfect condition.</span>")
		else
			var/obj/item/stack/tile/brass/B = W
			B.use(1)
			obj_integrity = max_integrity
			to_chat(user, "<span class='notice'>You swiftly repair [src] with [B].</span>")
	else
		return ..()

obj/item/shield/riot/ratvarian/proc/calc_bash_mult()
	var/bash_mult = 0
	if(!dam_absorbed)
		return 1
	else
		bash_mult += round(clamp(1 + (dam_absorbed / bash_mult_steps), 1, max_bash_mult), 0.1) //Multiplies the effect of bashes by up to [max_bash_mult], though never less than one
		return bash_mult

/obj/item/shield/riot/ratvarian/proc/calc_bash_absorb_use()
	var/absorb_use = 0
	absorb_use = max(0, round(dam_absorbed * (calc_bash_mult() / round(1 + (dam_absorbed / bash_mult_steps), 0.1)), 1)) //Calculates how much of the absorbed damage the bash would actually use, so its not wasted
	return absorb_use

/obj/item/shield/riot/ratvarian/on_shield_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	dam_absorbed += damage
	playsound(owner,  'sound/machines/clockcult/steam_whoosh.ogg', 30)
	if(damage <= 10) //The shield itself is hard to break, this DOES NOT modify the actual blocking-mechanic
		damage = 0
	else
		damage -= 5
	return ..()

/obj/item/shield/riot/ratvarian/shatter(mob/living/carbon/human/owner)
	playsound(owner, 'sound/magic/clockwork/anima_fragment_death.ogg', 50)
	new /obj/item/clockwork/alloy_shards/large(get_turf(src))

/obj/item/shield/riot/ratvarian/user_shieldbash(mob/living/user, atom/target, harmful)
	var/actual_bash_mult = calc_bash_mult()
	shieldbash_knockback = round(initial(shieldbash_knockback) * actual_bash_mult, 1)   //Modifying the strength of the bash, done with initial() to prevent magic-number issues if the original shieldbash values are changed
	shieldbash_brutedamage = round(initial(shieldbash_brutedamage) * actual_bash_mult, 1) //Where I think of it, better round this stuff because we don't need even more things that deal like 3.25 damage
	shieldbash_stamdmg = round(initial(shieldbash_stamdmg) * actual_bash_mult, 1) //Like 20 brute and 60 stam + a fuckton of knockback at the moment (at maximum charge), seems mostly fine? I think?
	if(..()) //If this bash actually was executed
		dam_absorbed -= calc_bash_absorb_use()
		return TRUE
	else
		return FALSE
