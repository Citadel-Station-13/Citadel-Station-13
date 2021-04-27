/datum/yelling_wavefill
	var/stop = FALSE
	var/list/atom/collected

/datum/yelling_wavefill/Destroy(force, ...)
	stop = TRUE
	return ..()

/datum/yelling_wavefill/proc/run(atom/source, dist = 50)
	collected = list()
	do_run(source, dist)
	// gc
	if(QDELETED(src))
		collected = null

// blatantly copied from wave explosion code
/datum/yelling_wavefill/proc/do_run(atom/source, dist)
	var/list/edges = list(source = (NORTH|SOUTH|EAST|WEST))
	var/list/powers = list(source = dist)
	var/list/processed_last = list()
	var/turf/T
	var/turf/expanding
	var/power
	var/dir
	var/returned
#define RUN_YELL(_T, _P, _D) \
	returned = max(powers[_T] - _T.get_yelling_resistance() - 1, 0); \
	_T.maptext = "[returned]";

	var/list/turf/edges_next = list()
	var/list/turf/powers_next = list()
	var/list/turf/powers_returned = list()
	var/list/turf/diagonals = list()
	var/list/turf/diagonal_powers = list()
	var/list/turf/diagonal_powers_max = list()

	while(edges.len)
		// process cardinals
		for(var/i in edges)
			T = i
			power = powers[T]
			dir = edges[T]
			RUN_YELL(T, power, dir)
			powers_returned[T] = returned
			if(returned)
				// get hearing atoms
			else
				continue

	// diagonal power calc when multiple things hit one diagonal
#define CALCULATE_DIAGONAL_POWER(existing, adding, maximum) min(maximum, existing + adding)
	// diagonal hitting cardinal expansion
#define CALCULATE_DIAGONAL_CROSS_POWER(existing, adding) max(existing, adding)
	// insanity define to mark the next set of cardinals.
#define CARDINAL_MARK(ndir, cdir, edir) \
	if(edir & cdir) { \
		expanding = get_step(T,ndir); \
		if(expanding && !processed_last[expanding] && !edges[expanding]) { \
			powers_next[expanding] = max(powers_next[expanding], returned); \
			edges_next[expanding] = (cdir | edges_next[expanding]); \
		}; \
	};

#define DIAGONAL_SUBSTEP(ndir, cdir, edir) \
	expanding = get_step(T,ndir); \
	if(expanding && !processed_last[expanding] && !edges[expanding]) { \
		if(!edges_next[expanding]) { \
			diagonal_powers_max[expanding] = max(diagonal_powers_max[expanding], returned, powers[T]); \
			diagonal_powers[expanding] = CALCULATE_DIAGONAL_POWER(diagonal_powers[expanding], returned, diagonal_powers_max[expanding]); \
			diagonals[expanding] = (cdir | diagonals[expanding]); \
		}; \
		else { \
			powers_next[expanding] = CALCULATE_DIAGONAL_CROSS_POWER(powers_next[expanding], returned); \
		}; \
	};

#define DIAGONAL_MARK(ndir, cdir, edir) \
	if(edir & cdir) { \
		DIAGONAL_SUBSTEP(turn(ndir, 90), turn(cdir, 90), edir); \
		DIAGONAL_SUBSTEP(turn(ndir, -90), turn(cdir, -90), edir); \
	};
			CARDINAL_MARK(NORTH, NORTH, dir)
			CARDINAL_MARK(SOUTH, SOUTH, dir)
			CARDINAL_MARK(EAST, EAST, dir)
			CARDINAL_MARK(WEST, WEST, dir)
			CHECK_TICK

		// to_chat(world, "DEBUG: cycle mid edges_next [english_list_assoc(edges_next)]")

		// Sweep after cardinals for diagonals
		for(var/i in edges)
			T = i
			power = powers[T]
			dir = edges[T]
			returned = powers_returned[T]
			DIAGONAL_MARK(NORTH, NORTH, dir)
			DIAGONAL_MARK(SOUTH, SOUTH, dir)
			DIAGONAL_MARK(EAST, EAST, dir)
			DIAGONAL_MARK(WEST, WEST, dir)
			CHECK_TICK

		// to_chat(world, "DEBUG: cycle mid diagonals [english_list_assoc(diagonals)]")

		// Process diagonals:
		for(var/i in diagonals)
			T = i
			power = diagonal_powers[T]
			dir = diagonals[T]
			RUN_YELL(T, power, dir)
			if(!returned)
				continue
			CARDINAL_MARK(NORTH, NORTH, dir)
			CARDINAL_MARK(SOUTH, SOUTH, dir)
			CARDINAL_MARK(EAST, EAST, dir)
			CARDINAL_MARK(WEST, WEST, dir)
			CHECK_TICK

		// to_chat(world, "DEBUG: cycle end edges_next [english_list_assoc(edges_next)]")

		// flush lists
		processed_last = edges + diagonals
		edges = edges_next
		powers = powers_next

#undef RUN_YELL
#undef DIAGONAL_SUBSTEP
#undef DIAGONAL_MARK
#undef CARDINAL_MARK

/proc/yelling_wavefill(atom/source, dist = 50)
	var/datum/yelling_wavefill/Y = new
	Y.run(source, dist)
	return Y.collected || list()

