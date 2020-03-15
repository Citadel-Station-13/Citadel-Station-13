// This file has a weird name, but it's for anything related to the checks for shields, blocking, dodging, and similar "stop this attack before it actually impacts the target" as opposed to "defend once it has hit".

/*
/// Bitflags for check_block() and handle_block(). Meant to be combined. You can be hit and still reflect, for example, if you do not use BLOCK_SUCCESS.
/// Attack was not blocked
#define BLOCK_NONE						NONE
/// Attack was blocked, do not do damage. THIS FLAG MUST BE THERE FOR DAMAGE/EFFECT PREVENTION!
#define BLOCK_SUCCESS					(1<<1)

/// The below are for "metadata" on "how" the attack was blocked.

/// Attack was and should be reflected (NOTE: the SHOULD here is important, as it says "the thing blocking isn't handling the reflecting for you so do it yourself"!)
#define BLOCK_SHOULD_REFLECT			(1<<2)
/// Attack was manually redirected (including reflected) by any means by the defender. For when YOU are handling the reflection, rather than the thing hitting you. (see sleeping carp)
#define BLOCK_REDIRECTED				(1<<3)
/// Attack was blocked by something like a shield.
#define BLOCK_PHYSICAL_EXTERNAL			(1<<4)
/// Attack was blocked by something worn on you.
#define BLOCK_PHYSICAL_INTERNAL			(1<<5)
/// Attack should pass through. Like SHOULD_REFLECT but for.. well, passing through harmlessly.
#define BLOCK_SHOULD_PASSTHROUGH		(1<<6)
/// Attack outright missed because the target dodged. Should usually be combined with SHOULD_PASSTHROUGH or something (see martial arts)
#define BLOCK_TARGET_DODGED				(1<<7)
*/

///Check whether or not we can block, without "triggering" a block. Basically run checks without effects like depleting shields. Wrapper for do_run_block(). The arguments on that means the same as for this.
/mob/living/proc/check_block(atom/object, damage, attack_text = "the attack", attack_type, armour_penetration, mob/attacker, def_zone)
	return do_run_block(FALSE, object, damage, attack_Text, attack_type, armour_penetration, attacker, check_zone(def_zone))

/// Runs a block "sequence", effectively checking and then doing effects if necessary. Wrapper for do_run_block(). The arguments on that means the same as for this.
/mob/living/proc/run_block(atom/object, damage, attack_text = "the attack", attack_type, armour_penetration, mob/attacker, def_zone)
	return do_run_block(TRUE, object, damage, attack_Text, attack_type, armour_penetration, attacker, check_zone(def_zone))

/** The actual proc for block checks. DO NOT USE THIS DIRECTLY UNLESS YOU HAVE VERY GOOD REASON TO. To reduce copypaste for differences between handling for real attacks and virtual checks.
  * Automatically checks all held items for /obj/item/proc/run_block() with the same parameters.
  * @params
  * real_attack - If this attack is real
  * object - Whatever /atom is actually hitting us, in essence. For example, projectile if gun, item if melee, structure/whatever if it's a thrown, etc.
  * damage - The nominal damage this would do if it was to hit. Obviously doesn't take into effect explosions/magic/similar things.. unless you implement it to raise the value.
  * attack_text - The text that this attack should show, in the context of something like "[src] blocks [attack_text]!"
  * attack_type - See __DEFINES/combat.dm - Attack types, to distinguish between, for example, someone throwing an item at us vs bashing us with it.
  * armour_penetration - 0-100 value of how effectively armor penetrating the attack should be.
  * attacker - Set to the mob attacking IF KNOWN. Do not expect this to always be set!
  * def_zone - The zone this'll impact.
  */
/mob/living/proc/do_run_block(real_attack = TRUE, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone)
	// Component signal block runs have highest priority.. for now.
	. = SEND_SIGNAL(src, COMSIG_MOB_RUN_BLOCK, real_attack, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone)
	if(. & BLOCK_INTERRUPT_CHAIN)
		return
	for(var/obj/item/I in held_items)
		if(istype(I, /obj/item/clothing))			//yeah usually this shouldn't.. uh, work. This is a bad check and should be removed though.
			continue



/mob/living/proc/_check_shields()
	var/block_chance_modifier = round(damage / -3)
	for(var/obj/item/I in held_items)
		if(!istype(I, /obj/item/clothing))
			var/final_block_chance = I.block_chance - (CLAMP((armour_penetration-I.armour_penetration)/2,0,100)) + block_chance_modifier //So armour piercing blades can still be parried by other blades, for example
			if(I.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type))
				return TRUE
	return FALSE

/mob/living/proc/_check_reflect(def_zone) //Reflection checks for anything in your hands, based on the reflection chance of the object(s)
	for(var/obj/item/I in held_items)
		if(I.IsReflect(def_zone))
			return TRUE
	return FALSE

/obj/item
	/// The 0% to 100% chance for the default implementation of random block rolls.
	var/block_chance = 0

/obj/item/proc/run_block(real_attack, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance)

/obj/item/proc/_hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	if(prob(final_block_chance))
		owner.visible_message("<span class='danger'>[owner] blocks [attack_text] with [src]!</span>")
		return 1
	return 0

/obj/item/proc/_IsReflect(var/def_zone) //This proc determines if and at what% an object will reflect energy projectiles if it's in l_hand,r_hand or wear_suit
	return 0


/mob/living/carbon/human/check_reflect(def_zone)
	if(wear_suit?.IsReflect(def_zone))
		return TRUE
	return ..()

/mob/living/carbon/human/check_shields(atom/AM, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armour_penetration = 0)
	. = ..()
	if(.)
		return
	var/block_chance_modifier = round(damage / -3)
	if(wear_suit)
		var/final_block_chance = wear_suit.block_chance - (CLAMP((armour_penetration-wear_suit.armour_penetration)/2,0,100)) + block_chance_modifier
		if(wear_suit.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type))
			return TRUE
	if(w_uniform)
		var/final_block_chance = w_uniform.block_chance - (CLAMP((armour_penetration-w_uniform.armour_penetration)/2,0,100)) + block_chance_modifier
		if(w_uniform.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type))
			return TRUE
	if(wear_neck)
		var/final_block_chance = wear_neck.block_chance - (CLAMP((armour_penetration-wear_neck.armour_penetration)/2,0,100)) + block_chance_modifier
		if(wear_neck.hit_reaction(src, AM, attack_text, final_block_chance, damage, attack_type))
			return TRUE
	return FALSE
