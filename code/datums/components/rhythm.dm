/**
  * Simple rhythm components that allow syncing up things like life ticks, movement, attack delays, etc
  */
/datum/component/rhythm
	/// Are we activated?
	var/active = FALSE

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

/datum/component/rhythm/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return


/datum/component/rhythm/RegisterWithParent()
	if(ismob(parent))
		RegisterSignal(parent, COMSIG_MOB_CLIENT_PREMOVE, .proc/intercept_clientmove)
		if(isliving(parent))
			RegisterSignal(parent, COMSIG_LIVING_LIFE, .proc/intercept_life)

/datum/component/rhythm/UnregisterFromParent()
	if(ismob(parent))
		UnregisterSignal(parent, COMSIG_MOB_CLIENT_PREMOVE)
		if(isliving(parent))
			UnregisterSignal(parent, COMSIG_LIVING_LIFE)

/datum/component/rhythm/proc/set_activation(state)
	state = state? TRUE : FALSE
	if(active == state)
		return
	active = state
	if(active)
		START_PROCESSING(SSdcs, src)
	else
		STOP_PROCESSING(SSdcs, src)

/datum/component/rhythm/process(wait, times_Fired)
	//////// SELF MOVEMENT
	if(intercept_self_movement && !(self_movement_delay_ticks % times_fired))
		self_movement_cooldown = FALSE

	//////// LIFE TICKS
	if(intercept_life && !(life_delay_ticks % times_fired))
		currently_ticking_life = TRUE
		var/mob/living/L = parent
		L.Life(life_seconds_equivalence, times_fired)
		currently_ticking_life = FALSE

/datum/component/rhythm/proc/intercept_clientmove(datum/source, atom/newloc, direction)
	if(!intercept_self_movement)
		return
	if(self_movement_cooldown)
		return COMPONENT_INTERRUPT_MOVE
	self_movement_cooldown = TRUE

/datum/component/rhythm/proc/intercept_life(datum/source, seconds, times_fired)
	if(intercept_life && !currently_ticking_life)
		return COMPONENT_INTERRUPT_LIFE_BIOLOGICAL | COMPONENT_INTERRUPT_LIFE_PHYSICAL
