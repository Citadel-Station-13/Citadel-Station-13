/datum/eldritch_knowledge/base_flesh
	name = "Principle of Hunger"
	desc = "Inducts you into the Path of Flesh. Allows you to transmute a pool of blood with a spear into a Blade of Flesh."
	gain_text = "Hundreds of us starved, but not me... I found strength in my greed."
	banned_knowledge = list(/datum/eldritch_knowledge/base_ash,/datum/eldritch_knowledge/base_rust,/datum/eldritch_knowledge/final/ash_final,/datum/eldritch_knowledge/final/rust_final,/datum/eldritch_knowledge/final/void_final,/datum/eldritch_knowledge/base_void)
	next_knowledge = list(/datum/eldritch_knowledge/flesh_grasp)
	required_atoms = list(/obj/item/spear,/obj/effect/decal/cleanable/blood)
	result_atoms = list(/obj/item/melee/sickly_blade/flesh)
	cost = 0
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_ghoul
	name = "Imperfect Ritual"
	desc = "Allows you to resurrect the dead as voiceless dead by sacrificing them on the transmutation rune with a poppy. Voiceless dead are mute and have 50 HP. You can only have 2 at a time."
	gain_text = "I found notes of a dark ritual, unfinished... yet still, I pushed forward."
	cost = 1
	required_atoms = list(/mob/living/carbon/human,/obj/item/reagent_containers/food/snacks/grown/poppy)
	next_knowledge = list(/datum/eldritch_knowledge/flesh_mark,/datum/eldritch_knowledge/void_cloak,/datum/eldritch_knowledge/ashen_eyes)
	route = PATH_FLESH
	var/max_amt = 2
	var/current_amt = 0
	var/list/ghouls = list()

/datum/eldritch_knowledge/flesh_ghoul/on_finished_recipe(mob/living/user,list/atoms,loc)
	var/mob/living/carbon/human/humie = locate() in atoms
	if(QDELETED(humie) || humie.stat != DEAD)
		return

	if(length(ghouls) >= max_amt)
		return

	if(HAS_TRAIT(humie,TRAIT_HUSK))
		return

	humie.grab_ghost()

	if(!humie.mind || !humie.client)
		var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as a [humie.real_name], a voiceless dead.", ROLE_HERETIC, null, ROLE_HERETIC, 50,humie)
		if(!LAZYLEN(candidates))
			return
		var/mob/dead/observer/C = pick(candidates)
		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(humie)]) to replace an AFK player.")
		humie.ghostize(0)
		humie.key = C.key

	ADD_TRAIT(humie,TRAIT_MUTE,MAGIC_TRAIT)
	log_game("[key_name_admin(humie)] has become a voiceless dead, their master is [user.real_name]")
	humie.revive(full_heal = TRUE, admin_revive = TRUE)
	humie.setMaxHealth(75)
	humie.health = 75 // Voiceless dead are much tougher than ghouls
	humie.become_husk()
	humie.faction |= "heretics"

	var/datum/antagonist/heretic_monster/heretic_monster = humie.mind.add_antag_datum(/datum/antagonist/heretic_monster)
	var/datum/antagonist/heretic/master = user.mind.has_antag_datum(/datum/antagonist/heretic)
	heretic_monster.set_owner(master)
	atoms -= humie
	RegisterSignal(humie,COMSIG_MOB_DEATH,.proc/remove_ghoul)
	ghouls += humie

/datum/eldritch_knowledge/flesh_ghoul/proc/remove_ghoul(datum/source)
	var/mob/living/carbon/human/humie = source
	ghouls -= humie
	humie.mind.remove_antag_datum(/datum/antagonist/heretic_monster)
	UnregisterSignal(source,COMSIG_MOB_DEATH)

/datum/eldritch_knowledge/flesh_grasp
	name = "Grasp of Flesh"
	gain_text = "My new found desires drove me to greater and greater heights."
	desc = "Empowers your mansus grasp to be able to create a single ghoul out of a dead person. Ghouls are only half as sturdy as a regular person and look like husks to the heathens' eyes."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/flesh_ghoul)
	var/ghoul_amt = 4
	var/list/spooky_scaries
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_grasp/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ishuman(target) || target == user)
		return

	if(iscarbon(target))
		user.reagents.add_reagent(/datum/reagent/eldritch, 5)

	var/mob/living/carbon/human/human_target = target
	var/datum/status_effect/eldritch/eldritch_effect = human_target.has_status_effect(/datum/status_effect/eldritch/rust) || human_target.has_status_effect(/datum/status_effect/eldritch/ash) || human_target.has_status_effect(/datum/status_effect/eldritch/flesh)  || human_target.has_status_effect(/datum/status_effect/eldritch/void)
	if(eldritch_effect)
		. = TRUE
		eldritch_effect.on_effect()
		if(iscarbon(target))
			var/mob/living/carbon/carbon_target = target
			var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
			var/datum/wound/slash/severe/crit_wound = new
			crit_wound.apply_wound(bodypart)

	if(QDELETED(human_target) || human_target.stat != DEAD)
		return

	human_target.grab_ghost()

	if(!human_target.mind || !human_target.client)
		to_chat(user, "<span class='warning'>There is no soul connected to this body...</span>")
		return

	if(HAS_TRAIT(human_target, TRAIT_HUSK))
		to_chat(user, "<span class='warning'>You cannot revive a dead ghoul!</span>")
		return

	if(LAZYLEN(spooky_scaries) >= ghoul_amt)
		to_chat(user, "<span class='warning'>Your patron cannot support more ghouls on this plane!</span>")
		return

	LAZYADD(spooky_scaries, human_target)
	log_game("[key_name_admin(human_target)] has become a ghoul, their master is [user.real_name]")
	//we change it to true only after we know they passed all the checks
	. = TRUE
	RegisterSignal(human_target,COMSIG_MOB_DEATH,.proc/remove_ghoul)
	human_target.revive(full_heal = TRUE, admin_revive = TRUE)
	human_target.setMaxHealth(40)
	human_target.health = 40
	human_target.become_husk()
	human_target.faction |= "heretics"
	var/datum/antagonist/heretic_monster/heretic_monster = human_target.mind.add_antag_datum(/datum/antagonist/heretic_monster)
	var/datum/antagonist/heretic/master = user.mind.has_antag_datum(/datum/antagonist/heretic)
	heretic_monster.set_owner(master)
	return


/datum/eldritch_knowledge/flesh_grasp/proc/remove_ghoul(datum/source)
	var/mob/living/carbon/human/humie = source
	spooky_scaries -= humie
	humie.mind.remove_antag_datum(/datum/antagonist/heretic_monster)
	UnregisterSignal(source, COMSIG_MOB_DEATH)

/datum/eldritch_knowledge/flesh_mark
	name = "Mark of Flesh"
	gain_text = "I saw them, the marked ones. The screams... the silence."
	desc = "Your Mansus Grasp now applies the Mark of Flesh on hit. Attack the afflicted with your Sickly Blade to detonate the mark. Upon detonation, the Mark of Flesh causes additional bleeding."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/summon/raw_prophet)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/void_mark)
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_mark/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(isliving(target))
		. = TRUE
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/flesh)

/datum/eldritch_knowledge/flesh_blade_upgrade
	name = "Bleeding Steel"
	gain_text = "And then, blood rained from the heavens. That's when I finally understood the Marshal's teachings."
	desc = "Your Sickly Blade will now cause additional bleeding."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/summon/stalker)
	banned_knowledge = list(/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/rust_blade_upgrade,/datum/eldritch_knowledge/void_blade_upgrade)
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_blade_upgrade/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
		var/datum/wound/slash/severe/crit_wound = new
		crit_wound.apply_wound(bodypart)

/datum/eldritch_knowledge/summon/raw_prophet
	name = "Raw Ritual"
	gain_text = "The Uncanny Man, who walks alone in the valley between the worlds... I was able to summon his aid."
	desc = "You can now summon a Raw Prophet by transmutating a pair of eyes, a left arm and a pool of blood. Raw prophets have increased seeing range, as well as X-Ray vision, but they are very fragile."
	cost = 1
	required_atoms = list(/obj/item/organ/eyes,/obj/item/bodypart/l_arm,/obj/effect/decal/cleanable/blood)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/raw_prophet
	next_knowledge = list(/datum/eldritch_knowledge/flesh_blade_upgrade,/datum/eldritch_knowledge/rune_carver,/datum/eldritch_knowledge/curse/paralysis)
	route = PATH_FLESH

/datum/eldritch_knowledge/summon/stalker
	name = "Lonely Ritual"
	gain_text = "I was able to combine my greed and desires to summon an eldritch beast I had never seen before. An ever shapeshifting mass of flesh, it knew well my goals."
	desc = "You can now summon a Stalker by transmutating a kitchen knife, a candle, a pen and a piece of paper. Stalkers can shapeshift into harmless animals to get close to the victim."
	cost = 1
	required_atoms = list(/obj/item/kitchen/knife,/obj/item/candle,/obj/item/pen,/obj/item/paper)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/stalker
	next_knowledge = list(/datum/eldritch_knowledge/summon/ashy,/datum/eldritch_knowledge/summon/rusty,/datum/eldritch_knowledge/flesh_blade_upgrade_2)
	route = PATH_FLESH

/datum/eldritch_knowledge/summon/ashy
	name = "Ashen Ritual"
	gain_text = "I combined my principle of hunger with my desire for destruction. And the Nightwatcher knew my name."
	desc = "You can now summon an Ashen One by transmuting a pile of ash, a head and a book using a transmutation circle. They possess the ability to jaunt short distances and create a cascade of flames."
	cost = 1
	required_atoms = list(/obj/effect/decal/cleanable/ash,/obj/item/bodypart/head,/obj/item/book)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/ash_spirit
	next_knowledge = list(/datum/eldritch_knowledge/summon/stalker,/datum/eldritch_knowledge/spell/flame_birth)

/datum/eldritch_knowledge/summon/rusty
	name = "Rusted Ritual"
	gain_text = "I combined my principle of hunger with my desire for corruption. And the Rusted Hills called my name."
	desc = "You can now summon a Rust Walker by transmuting a vomit pool, a severed head, and a book using a transmutation circle. Rust Walkers possess the ability to spread rust and can fire bolts of rust to further corrode the area."
	cost = 1
	required_atoms = list(/obj/effect/decal/cleanable/vomit,/obj/item/bodypart/head,/obj/item/book)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/rust_spirit
	next_knowledge = list(/datum/eldritch_knowledge/spell/voidpull,/datum/eldritch_knowledge/spell/entropic_plume)

/datum/eldritch_knowledge/spell/blood_siphon
	name = "Blood Siphon"
	gain_text = "No matter the man, we bleed all the same. That's what the Marshal told me."
	desc = "You gain a spell that drains lifeforce from your enemies to restore your own."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/pointed/blood_siphon
	next_knowledge = list(/datum/eldritch_knowledge/summon/stalker,/datum/eldritch_knowledge/spell/voidpull)

/datum/eldritch_knowledge/final/flesh_final
	name = "Priest's Final Hymn"
	gain_text = "Men of this world. Hear me, for the time of the Lord of Arms has come! The Emperor of Flesh guides my army!"
	desc = "Bring 3 bodies onto a transmutation rune to shed your human form and ascend to untold power."
	required_atoms = list(/mob/living/carbon/human)
	cost = 5
	sacs_needed = 8
	route = PATH_FLESH

/datum/eldritch_knowledge/final/flesh_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	. = ..()
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Ever coiling vortex. Reality unfolded. THE LORD OF ARMS, [user.real_name] has ascended! Fear the ever twisting hand! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", 'sound/announcer/classic/spanomalies.ogg')
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shed_human_form)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	var/datum/antagonist/heretic/heretic = user.mind.has_antag_datum(/datum/antagonist/heretic)
	var/datum/eldritch_knowledge/flesh_grasp/ghoul1 = heretic.get_knowledge(/datum/eldritch_knowledge/flesh_grasp)
	ghoul1.ghoul_amt *= 3
	var/datum/eldritch_knowledge/flesh_ghoul/ghoul2 = heretic.get_knowledge(/datum/eldritch_knowledge/flesh_ghoul)
	ghoul2.max_amt *= 3

	return ..()

/datum/eldritch_knowledge/flesh_blade_upgrade_2
	name = "Remembrance"
	gain_text = "Pain isn't something easily forgotten."
	desc = "Your blade remembers more, and remembers how easily bones broke just as its flesh did, guaranteeing dislocated, or broken bones."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/touch_of_madness)
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_blade_upgrade_2/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
		var/datum/wound/blunt/moderate/moderate_wound = new
		moderate_wound.apply_wound(bodypart)

/datum/eldritch_knowledge/spell/touch_of_madness
	name = "Touch of Madness"
	gain_text = "The ignorant mind that inhabits their feeble bodies will crumble when they acknowledge - willingly or not, the truth."
	desc = "By forcing the knowledge of the Mansus upon my foes, I can show them things that would drive any normal man insane."
	cost = 2
	sacs_needed = 3
	spell_to_add = /obj/effect/proc_holder/spell/targeted/touch/mad_touch
	next_knowledge = list(/datum/eldritch_knowledge/final/flesh_final)
	route = PATH_FLESH

/datum/eldritch_knowledge/spell/touch_of_madness/on_gain(mob/user)
	. = ..()
	priority_announce("The stench of rotting flesh fills the air... An approaching abomination has been detected!", sound = 'sound/misc/notice1.ogg')
