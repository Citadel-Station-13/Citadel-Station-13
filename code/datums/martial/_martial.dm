/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/id = "" //ID, used by mind/has_martialartcode\game\objects\items\granters.dm:345:error: user.mind.has_martialart: undefined proccode\game\objects\items\granters.dm:345:error: user.mind.has_martialart: undefined proccode\game\objects\items\granters.dm:345:error: user.mind.has_martialart: undefined proccode\game\objects\items\granters.dm:345:error: user.mind.has_martialart: undefined proccode\game\objects\items\granters.dm:345:error: user.mind.has_martialart: undefined proc
	var/current_target
	var/datum/martial_art/base // The permanent style. This will be null unless the martial art is temporary
	var/block_chance = 0 //Chance to block melee attacks using items while on throw mode.
	var/restraining = 0 //used in cqc's disarm_act to check if the disarmed is being restrained and so whether they should be put in a chokehold or not
	var/help_verb
	var/pacifism_check = TRUE //are the martial arts combos/attacks unable to be used by pacifist.
	var/allow_temp_override = TRUE //if this martial art can be overridden by temporary martial arts
	/// Can we be used to unarmed parry?
	var/can_martial_parry = FALSE
	/// Set this variable to something not null, this'll be the preferred unarmed parry in most cases if [can_martial_parry] is TRUE. YOU MUST RUN [get_block_parry_data(this)] INSTEAD OF DIRECTLY ACCESSING!
	var/datum/block_parry_data/block_parry_data
	var/pugilist = FALSE
	var/datum/weakref/holder //owner of the martial art
	var/display_combos = FALSE //shows combo meter if true

/datum/martial_art/proc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return FALSE

/datum/martial_art/proc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return FALSE

/datum/martial_art/proc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return FALSE

/datum/martial_art/proc/can_use(mob/living/carbon/human/owner_human)
	return TRUE

/datum/martial_art/proc/add_to_streak(element,mob/living/carbon/human/D)
	if(D != current_target)
		reset_streak(D)
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak, 1 + length(streak[1]))
	if(display_combos)
		var/mob/living/holder_living = holder.resolve()
		holder_living?.hud_used?.combo_display.update_icon_state(streak)
	return

/datum/martial_art/proc/reset_streak(mob/living/carbon/human/new_target)
	current_target = new_target
	streak = ""
	var/mob/living/holder_living = holder.resolve()
	holder_living?.hud_used?.combo_display.update_icon_state(streak)

/datum/martial_art/proc/damage_roll(mob/living/carbon/human/A, mob/living/carbon/human/D)
	//Here we roll for our damage to be added into the damage var in the various attack procs. This is changed depending on whether we are in combat mode, lying down, or if our target is in combat mode.
	var/damage = rand(A.dna.species.punchdamagelow, A.dna.species.punchdamagehigh)
	if(!CHECK_MOBILITY(A, MOBILITY_STAND))
		damage *= 0.7
	return damage

/datum/martial_art/proc/teach(mob/living/carbon/human/owner_human, make_temporary = FALSE)
	if(!istype(owner_human) || !owner_human.mind)
		return FALSE
	if(owner_human.mind.martial_art)
		if(make_temporary)
			if(!owner_human.mind.martial_art.allow_temp_override)
				return FALSE
			store(owner_human.mind.martial_art,owner_human)
		else
			owner_human.mind.martial_art.on_remove(owner_human)
	else if(make_temporary)
		base = owner_human.mind.default_martial_art
	if(help_verb)
		add_verb(owner_human, help_verb)
	owner_human.mind.martial_art = src
	holder = WEAKREF(owner_human)
	if(pugilist)
		ADD_TRAIT(owner_human, TRAIT_PUGILIST, MARTIAL_ARTIST_TRAIT)
	return TRUE

/datum/martial_art/proc/store(datum/martial_art/M,mob/living/carbon/human/owner_human)
	M.on_remove(owner_human)
	if(M.base) //Checks if M is temporary, if so it will not be stored.
		base = M.base
	else //Otherwise, M is stored.
		base = M

/datum/martial_art/proc/remove(mob/living/carbon/human/owner_human)
	if(!istype(owner_human) || !owner_human.mind || owner_human.mind.martial_art != src)
		return
	on_remove(owner_human)
	if(base)
		base.teach(owner_human)
	else
		var/datum/martial_art/X = owner_human.mind.default_martial_art
		X.teach(owner_human)
	REMOVE_TRAIT(owner_human, TRAIT_PUGILIST, MARTIAL_ARTIST_TRAIT)
	holder = null

/datum/martial_art/proc/on_remove(mob/living/carbon/human/owner_human)
	if(help_verb)
		remove_verb(owner_human, help_verb)
	return

///Gets called when a projectile hits the owner. Returning anything other than BULLET_ACT_HIT will stop the projectile from hitting the mob.
/datum/martial_art/proc/on_projectile_hit(mob/living/carbon/human/A, obj/item/projectile/P, def_zone)
	return BULLET_ACT_HIT
