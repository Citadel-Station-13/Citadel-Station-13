#define RAD_AMOUNT_LOW 50
#define RAD_AMOUNT_MEDIUM 200
#define RAD_AMOUNT_HIGH 500
#define RAD_AMOUNT_EXTREME 1000

/datum/component/radioactive
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/source

	var/hl3_release_date //the half-life measured in ticks
	var/strength
	var/can_contaminate

/datum/component/radioactive/Initialize(_strength=0, _source, _half_life=RAD_HALF_LIFE, _can_contaminate=TRUE)
	strength = _strength
	source = _source
	hl3_release_date = _half_life
	can_contaminate = _can_contaminate

	if(istype(parent, /atom))
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/rad_examine)
		if(istype(parent, /obj/item))
			RegisterSignal(parent, COMSIG_ITEM_ATTACK, .proc/rad_attack)
			RegisterSignal(parent, COMSIG_ITEM_ATTACK_OBJ, .proc/rad_attack)
	else
		CRASH("Something that wasn't an atom was given /datum/component/radioactive")

	if(strength > RAD_MINIMUM_CONTAMINATION)
		SSradiation.warn(src)

	//Let's make er glow
	//This relies on parent not being a turf or something. IF YOU CHANGE THAT, CHANGE THIS
	var/atom/movable/master = parent
	master.add_filter("rad_glow", 2, list("type" = "outline", "color" = "#39ff1430", "size" = 2))
	addtimer(CALLBACK(src, .proc/glow_loop, master), rand(1,19))//Things should look uneven

	START_PROCESSING(SSradiation, src)

/datum/component/radioactive/Destroy()
	STOP_PROCESSING(SSradiation, src)
	var/atom/movable/master = parent
	master.remove_filter("rad_glow")
	return ..()

/datum/component/radioactive/process()
	if(!prob(50))
		return
	radiation_pulse(parent, strength, RAD_DISTANCE_COEFFICIENT*2, FALSE, can_contaminate)

	if(!hl3_release_date)
		return
	strength -= strength / hl3_release_date
	if(strength <= RAD_BACKGROUND_RADIATION)
		addtimer(CALLBACK(src, .proc/check_dissipate), 5 SECONDS)
		return PROCESS_KILL

/datum/component/radioactive/proc/check_dissipate()
	if(strength <= RAD_BACKGROUND_RADIATION)
		qdel(src)
		return
	if(!(datum_flags & DF_ISPROCESSING))	// keep going
		START_PROCESSING(SSradiation, src)

/datum/component/radioactive/proc/glow_loop(atom/movable/master)
	var/filter = master.get_filter("rad_glow")
	if(filter)
		animate(filter, alpha = 110, time = 15, loop = -1)
		animate(alpha = 40, time = 25)

/datum/component/radioactive/InheritComponent(datum/component/C, i_am_original, _strength, _source, _half_life, _can_contaminate)
	if(!i_am_original)
		return
	if(!hl3_release_date) // Permanently radioactive things don't get to grow stronger
		return
	if(C)
		var/datum/component/radioactive/other = C
		strength = max(strength, other.strength)
	else
		strength = max(strength, _strength)

/datum/component/radioactive/proc/rad_examine(datum/source, mob/user, list/examine_list)
	var/atom/master = parent
	var/list/out = list()
	if(get_dist(master, user) <= 1)
		out += "The air around [master] feels warm"
	switch(strength)
		if(RAD_AMOUNT_LOW to RAD_AMOUNT_MEDIUM)
			out += "[out ? " and it " : "[master] "]feels weird to look at."
		if(RAD_AMOUNT_MEDIUM to RAD_AMOUNT_HIGH)
			out += "[out ? " and it " : "[master] "]seems to be glowing a bit."
		if(RAD_AMOUNT_HIGH to INFINITY) //At this level the object can contaminate other objects
			out += "[out ? " and it " : "[master] "]hurts to look at."
	if(!LAZYLEN(out))
		return
	out += "."
	examine_list += out.Join()

/datum/component/radioactive/proc/rad_attack(datum/source, atom/movable/target, mob/living/user)
	radiation_pulse(parent, strength/20)
	target.rad_act(strength/2)
	if(!hl3_release_date)
		return
	strength -= strength / hl3_release_date

#undef RAD_AMOUNT_LOW
#undef RAD_AMOUNT_MEDIUM
#undef RAD_AMOUNT_HIGH
#undef RAD_AMOUNT_EXTREME
