/datum/component/butchering
	var/speed = 80 //time in deciseconds taken to butcher something
	var/effectiveness = 100 //percentage effectiveness; numbers above 100 yield extra drops
	var/bonus_modifier = 0 //percentage increase to bonus item chance
	var/butcher_sound = 'sound/weapons/slice.ogg' //sound played when butchering
	var/butchering_enabled = TRUE
	var/can_be_blunt = FALSE

/datum/component/butchering/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(_speed)
		speed = _speed
	if(_effectiveness)
		effectiveness = _effectiveness
	if(_bonus_modifier)
		bonus_modifier = _bonus_modifier
	if(_butcher_sound)
		butcher_sound = _butcher_sound
	if(disabled)
		butchering_enabled = FALSE
	if(_can_be_blunt)
		can_be_blunt = _can_be_blunt
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, .proc/onItemAttack)

/datum/component/butchering/proc/onItemAttack(obj/item/source, mob/living/M, mob/living/user)
	if(user.a_intent == INTENT_HARM && M.stat == DEAD && (M.butcher_results || M.guaranteed_butcher_results)) //can we butcher it?
		if(butchering_enabled && (can_be_blunt || source.get_sharpness()))
			INVOKE_ASYNC(src, .proc/startButcher, source, M, user)
			return COMPONENT_ITEM_NO_ATTACK

/datum/component/butchering/proc/startButcher(obj/item/source, mob/living/M, mob/living/user)
	to_chat(user, "<span class='notice'>You begin to butcher [M]...</span>")
	playsound(M.loc, butcher_sound, 50, TRUE, -1)
	if(do_mob(user, M, speed) && M.Adjacent(source))
		Butcher(user, M)

/datum/component/butchering/proc/Butcher(mob/living/butcher, mob/living/meat)
	var/turf/T = meat.drop_location()
	var/final_effectiveness = effectiveness - meat.butcher_difficulty
	var/bonus_chance = max(0, (final_effectiveness - 100) + bonus_modifier) //so 125 total effectiveness = 25% extra chance
	for(var/V in meat.butcher_results)
		var/obj/bones = V
		var/amount = meat.butcher_results[bones]
		for(var/_i in 1 to amount)
			if(!prob(final_effectiveness))
				if(butcher)
					to_chat(butcher, "<span class='warning'>You fail to harvest some of the [initial(bones.name)] from [meat].</span>")
			else if(prob(bonus_chance))
				if(butcher)
					to_chat(butcher, "<span class='info'>You harvest some extra [initial(bones.name)] from [meat]!</span>")
				for(var/i in 1 to 2)
					new bones (T)
			else
				new bones (T)
		meat.butcher_results.Remove(bones) //in case you want to, say, have it drop its results on gib
	for(var/V in meat.guaranteed_butcher_results)
		var/obj/sinew = V
		var/amount = meat.guaranteed_butcher_results[sinew]
		for(var/i in 1 to amount)
			new sinew (T)
		meat.guaranteed_butcher_results.Remove(sinew)
	if(butcher)
		meat.visible_message("<span class='notice'>[butcher] butchers [meat].</span>")
	ButcherEffects(meat)
	meat.harvest(butcher)
	meat.gib(FALSE, FALSE, TRUE)

/datum/component/butchering/proc/ButcherEffects(mob/living/meat) //extra effects called on butchering, override this via subtypes
	return

///Special snowflake component only used for the recycler.
/datum/component/butchering/recycler

/datum/component/butchering/recycler/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(!istype(parent, /obj/machinery/recycler)) //EWWW
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, .proc/onCrossed)

/datum/component/butchering/recycler/proc/onCrossed(datum/source, mob/living/L)
	if(!istype(L))
		return
	var/obj/machinery/recycler/eater = parent
	if(eater.safety_mode || (eater.stat & (BROKEN|NOPOWER))) //I'm so sorry.
		return
	if(L.stat == DEAD && (L.butcher_results || L.guaranteed_butcher_results))
		Butcher(parent, L)