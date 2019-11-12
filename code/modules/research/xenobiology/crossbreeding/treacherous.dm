/*
Treacherous extracts:
	Have a unique effect when you stab someone with it, 8% chance of it stabbing you instead.
*/
/obj/item/slimecross/treacherous
	name = "treacherous extract"
	desc = "Looking at it makes you want to stab your friends."
	effect = "treacherous"
	icon_state = "treacherous"
	var/uses = 1

/obj/item/slimecross/treacherous/afterattack(atom/target,mob/user,proximity)
	. = ..()
	if (!proximity)
		return
	if (isliving(target))
		var/mob/living/H = target
		var/mob/living/G = user
		if (rand(1,25) < 23)
			H.apply_damage(5,BRUTE,pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD))
			H.visible_message("<span class='warning'>[user] stabs [target] with [src]!</span>","<span class='userdanger'>[user] shanks you with the [src]!</span>")
			playsound(H, 'sound/weapons/bladeslice.ogg', 40, 1)
			var/delete = do_effect(G, H)
			if (uses == 0 && delete == TRUE)
				qdel(src)
				return
			if (delete == TRUE)
				uses--
		else
			G.apply_damage(5,BRUTE,pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD))
			G.visible_message("<span class='warning'>[user] tries to stab [target] with [src], but stabs themself instead!</span>","<span class='userdanger'>A hidden blade slides out of the [src] and stabs you!</span>")
			playsound(G, 'sound/weapons/bladeslice.ogg', 40, 1)
			var/delete = do_effect(H, G)
			if (uses - 1 == 0 && delete == TRUE)
				qdel(src)
				return
			if (delete == TRUE)
				uses--

/obj/item/slimecross/treacherous/proc/do_effect(mob/user,mob/living/target)
	return TRUE

/obj/item/slimecross/treacherous/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] stabs [user.p_them()]self in the head with [src]! But the hardened slime blade retracted, it betrayed [user.p_their()] intentions!</span>")
	return MANUAL_SUICIDE

/obj/item/slimecross/treacherous/grey
	colour = "grey"

/obj/item/slimecross/treacherous/grey/do_effect(mob/user,mob/living/target)
	target.adjustCloneLoss(rand(30,40))
	..()

/obj/item/slimecross/treacherous/orange
	colour = "orange"
	uses = 5

/obj/item/slimecross/treacherous/orange/do_effect(mob/user,mob/living/target)
	target.fire_stacks = 5
	target.adjust_bodytemperature(40)
	target.IgniteMob()
	..()

/obj/item/slimecross/treacherous/purple
	colour = "purple"

/obj/item/slimecross/treacherous/purple/do_effect(mob/user,mob/living/target)
	target.revive(full_heal = 1)
	target.adjustToxLoss(rand(50,60))
	target.visible_message("<span class='warning'>[src] dissolves in [target], leaving no wound.</span>")
	..()

/obj/item/slimecross/treacherous/blue
	colour = "blue"
	uses = 10

/obj/item/slimecross/treacherous/blue/do_effect(mob/user,mob/living/target)
	target.slip(100,target.loc,GALOSHES_DONT_HELP,0,TRUE)
	..()

/obj/item/slimecross/treacherous/metal
	colour = "metal"

/obj/item/slimecross/treacherous/metal/do_effect(mob/user,mob/living/target)
	var/r = rand(1,10)
	for (var/turf/H in orange(target,1))
		if (get_dist(get_turf(user),H) > 0)
			if (r < 9)
				new /turf/closed/wall(H)
			else
				new /turf/closed/wall/r_wall(H)
	..()

/obj/item/slimecross/treacherous/yellow
	colour = "yellow"
	uses = 7

/obj/item/slimecross/treacherous/yellow/do_effect(mob/user,mob/living/target)
	playsound(get_turf(src), 'sound/weapons/zapbang.ogg', 50, 1)
	target.electrocute_act(rand(50,60),src)
	..()

/obj/item/slimecross/treacherous/darkpurple
	colour = "dark purple"

/obj/item/slimecross/treacherous/darkpurple/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] dissolves into plasma before lighting on fire!</span>")
	var/turf/T = get_turf(target)
	T.atmos_spawn_air("plasma=200")
	..()

/obj/item/slimecross/treacherous/darkblue
	colour = "dark blue"
	//suit environmentproof

/obj/item/slimecross/treacherous/darkblue/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] releases a burst of chilling smoke!</span>")
	var/datum/reagents/R = new/datum/reagents(100)
	R.add_reagent("frostoil", 40)
	user.reagents.add_reagent("cryoxadone",10)
	var/datum/effect_system/smoke_spread/chem/smoke = new
	smoke.set_up(R, 7, get_turf(user))
	smoke.start()
	..()

/obj/item/slimecross/treacherous/silver
	colour = "silver"

/obj/item/slimecross/treacherous/silver/do_effect(mob/user,mob/living/target)
	var/amount = rand(3,6)
	var/list/turfs = list()
	for(var/turf/open/T in range(1,get_turf(user)))
		turfs += T
	for(var/i = 0, i < amount, i++)
		var/path = get_random_food()
		var/obj/item/O = new path(pick(turfs))
		O.reagents.add_reagent("slimejelly",5) //Oh god it burns
		if(prob(50))
			O.desc += " It smells strange..."
	user.visible_message("<span class='danger'>[src] produces a few pieces of food!</span>")
	..()

/obj/item/slimecross/treacherous/bluespace
	colour = "bluespace"

/obj/item/slimecross/treacherous/bluespace/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] sparks, and lets off a shockwave of bluespace energy!</span>")
	for(var/mob/living/L in range(1, get_turf(user)))
		if(L != user)
			do_teleport(L, get_turf(L), 6, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE) //Somewhere between the effectiveness of fake and real BS crystal
			new /obj/effect/particle_effect/sparks(get_turf(L))
			playsound(get_turf(L), "sparks", 50, 1)
	..()

/obj/item/slimecross/treacherous/sepia
	colour = "sepia"

/obj/item/slimecross/treacherous/sepia/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='notice'>[src] shapes itself into a camera!</span>")
	new /obj/item/camera/timefreeze(get_turf(user))
	..()

/obj/item/slimecross/treacherous/cerulean
	colour = "cerulean"

/obj/item/slimecross/treacherous/cerulean/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='notice'>[src] produces a potion!</span>")
	new /obj/item/slimepotion/extract_cloner(get_turf(user))
	..()

/obj/item/slimecross/treacherous/pyrite
	uses = 5
	colour = "pyrite"
	var/mob/living/carbon/human/victim

/obj/item/slimecross/treacherous/pyrite/do_effect(mob/user,mob/living/target)
	if (ishuman(target))
		if (uses != 0)
			if (victim && victim != target)
				victim.eye_color = initial(victim.eye_color)
				victim.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				REMOVE_TRAIT(victim, TRAIT_CULT_EYES, "valid_cultist")
				victim.cut_overlays()
				victim.regenerate_icons()
			victim = target
			var/istate = pick("halo1","halo2","halo3","halo4","halo5","halo6")
			var/mutable_appearance/halo = mutable_appearance('icons/effects/32x64.dmi',istate, -BODY_FRONT_LAYER)
			victim.add_overlay(halo)
			victim.eye_color = "f00"
			victim.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
			ADD_TRAIT(victim,TRAIT_CULT_EYES,"valid_cultist")
			victim.update_body()
			uses--
		else
			to_chat(user,"<span class='warning'>[src] has no more uses!</span>")
	return FALSE

/obj/item/slimecross/treacherous/pyrite/attack_self(mob/user)
	if (victim)
		victim.eye_color = initial(victim.eye_color)
		victim.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		REMOVE_TRAIT(victim, TRAIT_CULT_EYES, "valid_cultist")
		victim.cut_overlays()
		victim.regenerate_icons()
		if (uses == 0)
			qdel(src)

/obj/item/slimecross/treacherous/red
	colour = "red"

/obj/item/slimecross/treacherous/red/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] pulses a hazy red aura for a moment, which wraps around [user]!</span>")
	for(var/mob/living/simple_animal/slime/S in view(7, get_turf(user)))
		if(user in S.Friends)
			var/friendliness = S.Friends[user]
			S.Friends = list()
			S.Friends[user] = friendliness
		else
			S.Friends = list()
		S.rabid = 1
		S.visible_message("<span class='danger'>The [S] is driven into a dangerous frenzy!</span>")
	..()

/obj/item/slimecross/treacherous/green
	colour = "green"

/obj/item/slimecross/treacherous/green/do_effect(mob/user,mob/living/target)
	var/which_hand = "l_hand"
	if(!(user.active_hand_index % 2))
		which_hand = "r_hand"
	var/mob/living/L = user
	if(!istype(user))
		return
	var/obj/item/held = L.get_active_held_item() //This should be itself, but just in case...
	L.dropItemToGround(held)
	var/obj/item/melee/arm_blade/slime/blade = new(user)
	if(!L.put_in_hands(blade))
		qdel(blade)
		user.visible_message("<span class='warning'>[src] melts onto [user]'s arm, boiling the flesh horribly!</span>")
	else
		user.visible_message("<span class='danger'>[src] sublimates the flesh around [user]'s arm, transforming the bone into a gruesome blade!</span>")
	user.emote("scream")
	L.apply_damage(30,BURN,which_hand)
	..()

/obj/item/slimecross/treacherous/pink
	colour = "pink"

/obj/item/slimecross/treacherous/pink/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='notice'>[src] shrinks into a small, gel-filled pellet!</span>")
	new /obj/item/slimecrossbeaker/pax(get_turf(user))
	..()

/obj/item/slimecross/treacherous/gold
	colour = "gold"

/obj/item/slimecross/treacherous/gold/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] shudders violently, and summons an army for [user]!</span>")
	for(var/i in 1 to 3) //Less than gold normally does, since it's safer and faster.
		var/mob/living/simple_animal/S = create_random_mob(get_turf(user), HOSTILE_SPAWN)
		S.faction |= "[REF(user)]"
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(S, pick(NORTH,SOUTH,EAST,WEST))
	..()

/obj/item/slimecross/treacherous/oil
	colour = "oil"

/obj/item/slimecross/treacherous/oil/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] begins to shake with rapidly increasing force!</span>")
	addtimer(CALLBACK(src, .proc/boom), 50)

/obj/item/slimecross/treacherous/oil/proc/boom()
	explosion(get_turf(src), 2, 4, 4) //Same area as normal oils, but increased high-impact values by one each, then decreased light by 2.
	qdel(src)

/obj/item/slimecross/treacherous/black
	colour = "black"

/obj/item/slimecross/treacherous/black/do_effect(mob/user,mob/living/target)
	var/mob/living/L = user
	if(!istype(L))
		return
	user.visible_message("<span class='danger'>[src] absorbs [user], transforming [user.p_them()] into a slime!</span>")
	var/obj/effect/proc_holder/spell/targeted/shapeshift/slimeform/S = new()
	S.remove_on_restore = TRUE
	user.mind.AddSpell(S)
	S.cast(list(user),user)
	..()

/obj/item/slimecross/treacherous/lightpink
	colour = "light pink"

/obj/item/slimecross/treacherous/lightpink/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] lets off a hypnotizing pink glow!</span>")
	for(var/mob/living/carbon/C in view(7, get_turf(user)))
		C.reagents.add_reagent("pax",5)
	..()

/obj/item/slimecross/treacherous/adamantine
	colour = "adamantine"

/obj/item/slimecross/treacherous/adamantine/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='notice'>[src] crystallizes into a large shield!</span>")
	new /obj/item/twohanded/required/adamantineshield(get_turf(user))
	..()

/obj/item/slimecross/treacherous/rainbow
	colour = "rainbow"

/obj/item/slimecross/treacherous/rainbow/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='notice'>[src] flattens into a glowing rainbow blade.</span>")
	new /obj/item/kitchen/knife/rainbowknife(get_turf(user))
	..()
