/datum/round_event_control/cat_surgeon
    name = "Cat Surgeon"
    typepath = /datum/round_event/cat_surgeon
    max_occurrences = 1
    weight = 10


/datum/round_event/cat_surgeon/start()
    var/list/spawn_locs = list()
    for(var/X in GLOB.xeno_spawn)
        spawn_locs += X

    if(!spawn_locs.len)
        message_admins("No valid spawn locations found, aborting...")
        return MAP_ERROR

    var/turf/T = get_turf(pick(spawn_locs))
    var/mob/living/simple_animal/hostile/cat_butcherer/S = new(T)
    playsound(S, 'sound/misc/catscream.ogg', 50, 1, -1)
    message_admins("A cat surgeon has been spawned at [COORD(T)][ADMIN_JMP(T)]")
    log_game("A cat surgeon has been spawned at [COORD(T)]")
    return SUCCESSFUL_SPAWN
