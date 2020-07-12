/**
  * Beatmap datums for rhythm components.
  *
  * If a rhythm component is "slaved" to it, the component will "tick" from it rather than from the subsystem directly.
  */
/datum/beatmap
	/// List of ticks of our beats. This MUST be ascending!
	var/list/beat_ticks
	/// The beat we're on
	var/current_beat = 1
	/// Tick we end on
	var/ending_tick = 0
	/// Do we automatically repeat?
	var/repeat = TRUE
	/// Tick we are currently on
	var/current_tick = 0
	/// Are we active?
	var/active = FALSE
	/// List of rhythm components we're linked to
	var/list/datum/component/rhythm/components = list()

/**
  * Advances our tick. Should ALWAYS be called by a ticker subsystem ticking every tick!
  */
/datum/beatmap/process()
	if(!active)
		return PROCESS_KILL
	if(++current_tick > ending_tick)
		end()
	if(current_tick > beat_ticks[current_beat])
		current_beat++
		tick_components()

/**
  * Ticks all our linked components
  */
/datum/beatmap/proc/tick_components()
	for(var/i in components)
		var/datum/component/rhythm/component/C = i
		C.process()

/**
  * Slaves a component to us
  */
/datum/beatmap/proc/link_component(datum/component/rhythm/C)
	components |= C
	C.beatmap = src
	C.set_activation(RHYTHM_BEATMAP)

/**
  * Releases a component from us
  */
/datum/beatmap/proc/release_component(datum/component/rhythm/C)
	components -= C
	C.beatmap = null
	C.set_activation(RHYTHM_INACTIVE)

/**
  * Converts a list of times in deciseconds to ticks and sets our beatmap to it.
  */
/datum/component/proc/import_ds_list(list/beats)


/**
  * Simple rhythm components that allow syncing up things like life ticks, movement, attack delays, etc
  */
/datum/component/rhythm
	/// Are we activated?
	var/active = RHYTHM_INACTIVE
	/// Beatmap if we're linked to one. Activation shoud always be on RHYTHM_BEATMAP if this exists.
	var/datum/beatmap/beatmap

	// Movement interception
	/// Should we intercept movement *initiated* by our parent?
	var/intercept_self_movement = TRUE
	/// Whether movement is on cooldown
	var/self_movement_cooldown = FALSE
	/// Number of TICKS before each movement
	var/self_movement_delay_ticks = 10

	// Life() interception
	/// Should we intercept Life() ticks if parent is living and handle ticking Life() ourselves?
	var/intercept_life = TRUE
	/// Number of TICKS between each Life()
	var/life_delay_ticks = 20
	/// Number of seconds to pass into Life()
	var/life_seconds_equivalence = 1
	/// Are we currently manaully ticking their Life()?
	var/currently_ticking_life = FALSE

	// Mob AI interception
	/// Should we override mob AI? This is generally necessary as mob AI moves differently from selfmovement at time of writing.
	var/intercept_automated_action = TRUE
	/// ticks between manual automated actions
	var/automated_action_delay_ticks = 10

/datum/component/rhythm/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return

/datum/component/rhythm/Destroy()
	if(beatmap)
		beatmap.release_component(src)
	set_activation(RHYTHM_INACTIVE)
	return ..()

/datum/component/rhythm/RegisterWithParent()
	if(ismob(parent))
		RegisterSignal(parent, COMSIG_MOB_CLIENT_PREMOVE, .proc/intercept_clientmove)
		if(isliving(parent))
			RegisterSignal(parent, COMSIG_LIVING_LIFE, .proc/intercept_life)
			if(istype(parent, /mob/living/simple_animal))
				RegisterSignal(parent, COMSIG_SIMPLE_ANIMAL_AI_TICK, .proc/intercept_ai)

/datum/component/rhythm/UnregisterFromParent()
	if(ismob(parent))
		UnregisterSignal(parent, COMSIG_MOB_CLIENT_PREMOVE)
		if(isliving(parent))
			UnregisterSignal(parent, COMSIG_LIVING_LIFE)
			if(istype(parent, /mob/living/simple_animal))
				UnregisterSignal(parent, COMSIG_SIMPLE_ANIMAL_AI_TICK)

/datum/component/rhythm/proc/set_activation(state)
	if(active == state)
		return
	active = state
	if(active == RHYTHM_STANDALONE)
		START_PROCESSING(SSdcs, src)
	else
		STOP_PROCESSING(SSdcs, src)

/datum/component/rhythm/process(wait, times_fired)
	if(active != RHYTHM_STANDALONE)
		return PROCESS_KILL
	//////// SELF MOVEMENT
	if(intercept_self_movement && !(self_movement_delay_ticks % times_fired))
		self_movement_cooldown = FALSE

	//////// LIFE TICKS
	if(intercept_life && !(life_delay_ticks % times_fired) && isliving(parent))
		currently_ticking_life = TRUE
		var/mob/living/L = parent
		L.Life(life_seconds_equivalence, times_fired)
		currently_ticking_life = FALSE

	//////// AUTOMATED ACTION
	if(intercept_automated_action && !(automated_action_delay_ticks) && istype(parent, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = parent
		SA.handle_automated_movement()
		SA.handle_automated_action()
		SA.handle_automated_speech()

/datum/component/rhythm/proc/intercept_clientmove(datum/source, atom/newloc, direction)
	if(!intercept_self_movement)
		return
	if(self_movement_cooldown)
		return COMPONENT_INTERRUPT_MOVE
	self_movement_cooldown = TRUE

/datum/component/rhythm/proc/intercept_life(datum/source, seconds, times_fired)
	if(intercept_life && !currently_ticking_life)
		return COMPONENT_INTERRUPT_LIFE_BIOLOGICAL | COMPONENT_INTERRUPT_LIFE_PHYSICAL

/datum/component/rhythm/proc/intercept_ai(datum/source)
	if(intercept_automated_action)
		return COMPONENT_INTERRUPT_AUTOMATED_MOVEMENT | COMPONENT_INTERRUPT_AUTOMATED_ACTION | COMPONENT_INTERRUPT_AUTOMATED_SPEECH
