/**
 * Observers voting on things through orbiting
 */
/datum/component/twitch_plays
	/// Observers
	var/list/mob/players = list()

/datum/component/twitch_plays/Initialize(...)
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ATOM_ORBIT_BEGIN, PROC_REF(on_start_orbit))
	RegisterSignal(parent, COMSIG_ATOM_ORBIT_END, PROC_REF(on_end_orbit))

/datum/component/twitch_plays/Destroy(force, silent)
	for(var/i in players)
		DetachPlayer(i)
	return ..()

/datum/component/twitch_plays/proc/on_start_orbit(datum/source, atom/movable/orbiter)
	if(!isobserver(orbiter))
		return
	AttachPlayer(orbiter)

/datum/component/twitch_plays/proc/on_end_orbit(datum/source, atom/movable/orbiter)
	if(!(orbiter in players))
		return
	DetachPlayer(orbiter)

/datum/component/twitch_plays/proc/AttachPlayer(mob/dead/observer)
	players |= observer
	RegisterSignal(observer, COMSIG_PARENT_QDELETING, PROC_REF(on_end_orbit))

/datum/component/twitch_plays/proc/DetachPlayer(mob/dead/observer)
	players -= observer
	UnregisterSignal(observer, COMSIG_PARENT_QDELETING)

/// Simple movement one
/datum/component/twitch_plays/simple_movement
	/// Movement votes by observer
	var/list/votes = list()
	/// Allow diagonals
	var/allow_diagonal = FALSE

/datum/component/twitch_plays/simple_movement/Initialize(...)
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	RegisterSignal(parent, COMSIG_TWITCH_PLAYS_MOVEMENT_DATA, PROC_REF(fetch_data))

/datum/component/twitch_plays/simple_movement/AttachPlayer(mob/dead/observer)
	. = ..()
	RegisterSignal(observer, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(pre_move))

/datum/component/twitch_plays/simple_movement/DetachPlayer(mob/dead/observer)
	. = ..()
	UnregisterSignal(observer, COMSIG_MOVABLE_PRE_MOVE)

/datum/component/twitch_plays/simple_movement/proc/pre_move(datum/source, turf/newLoc)
	if(get_dist(newLoc, parent) > 1)			// they're trying to escape orbit
		return
	. = COMPONENT_MOVABLE_BLOCK_PRE_MOVE
	var/dir = get_dir(parent, newLoc)
	if(!dir)
		return
	if(allow_diagonal || !((dir - 1) & dir))
		votes[source] = dir
	else		// pick one or the other
		votes[source] = prob(50)? (dir & ~(dir - 1)) : (dir & (dir - 1))

/datum/component/twitch_plays/simple_movement/proc/fetch_data(datum/source, wipe_votes)
	if(!votes.len)
		return
	var/list/total = list(TEXT_NORTH, TEXT_SOUTH, TEXT_EAST, TEXT_WEST)
	for(var/i in votes)
		total[num2text(votes[i])] += 1
	. = text2num(pickweight(total, 0))
	if(wipe_votes)
		votes.len = 0

/datum/component/twitch_plays/simple_movement/auto
	var/move_delay = 2
	var/last_move = 0

/datum/component/twitch_plays/simple_movement/auto/Initialize(move_delay)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!isnull(move_delay))
		src.move_delay = move_delay
	START_PROCESSING(SSfastprocess, src)

/datum/component/twitch_plays/simple_movement/auto/Destroy(force, silent)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/component/twitch_plays/simple_movement/auto/process()
	if(world.time < (last_move + move_delay))
		return
	var/dir = fetch_data(null, TRUE)
	if(!dir)
		return
	last_move = world.time
	step(parent, dir)
